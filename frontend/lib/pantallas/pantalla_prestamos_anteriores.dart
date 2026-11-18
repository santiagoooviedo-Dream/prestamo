import 'package:flutter/material.dart';

import '../models/prestamo_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_detalle_prestamo_completado.dart';

class PantallaPrestamosAnteriores extends StatefulWidget {
  const PantallaPrestamosAnteriores({super.key});

  @override
  State<PantallaPrestamosAnteriores> createState() =>
      _PantallaPrestamosAnterioresState();
}

class _PantallaPrestamosAnterioresState
    extends State<PantallaPrestamosAnteriores> {
  final _modelo = const PrestamoModel();
  late Future<PrestamosUsuario> _datos;

  @override
  void initState() {
    super.initState();
    _datos = _modelo.obtenerMisPrestamos();
  }

  void _reintentar() => setState(() => _datos = _modelo.obtenerMisPrestamos());

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<PrestamosUsuario>(
              future: _datos,
              builder: (context, snapshot) {
                final datos = snapshot.data;
                final anteriores = datos?.prestamosAnteriores ?? const [];
                final rechazadas = datos?.solicitudesRechazadas ?? const [];
                return ListView(
                  padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BotonVolver(alPresionar: () => Navigator.pop(context)),
                        Text(
                          'PRÉSTAMOS / HISTORIAL',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ColoresApp.textoContexto,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Préstamos anteriores',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Revisa tu historial de préstamos.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF8090A7)),
                    ),
                    const SizedBox(height: 18),
                    if (snapshot.hasError)
                      _ErrorHistorial(
                        mensaje: snapshot.error is ApiException
                            ? (snapshot.error as ApiException).mensaje
                            : 'No se pudo cargar el historial.',
                        alReintentar: _reintentar,
                      )
                    else if (!snapshot.hasData)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (anteriores.isEmpty && rechazadas.isEmpty)
                      const _HistorialVacio()
                    else ...[
                      if (rechazadas.isNotEmpty) ...[
                        const _TituloSeccionHistorial(
                          texto: 'Solicitudes rechazadas',
                        ),
                        for (final solicitud in rechazadas)
                          _TarjetaSolicitudRechazada(
                            solicitud: solicitud,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PantallaDetalleSolicitudRechazada(
                                      solicitud: solicitud,
                                    ),
                              ),
                            ),
                          ),
                      ],
                      if (anteriores.isNotEmpty) ...[
                        const _TituloSeccionHistorial(
                          texto: 'Préstamos completados',
                        ),
                        for (final prestamo in anteriores)
                          _TarjetaPrestamoAnterior(
                            prestamo: prestamo,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PantallaDetallePrestamoCompletado(
                                      prestamo: prestamo,
                                      cuotas: datos!.cuotasDelPrestamo(
                                        prestamo['id_prestamo'],
                                      ),
                                    ),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ],
                );
              },
            ),
          ),
          const BarraNavegacion(actual: DestinoNav.prestamos),
        ],
      ),
    );
  }
}

class _TituloSeccionHistorial extends StatelessWidget {
  final String texto;

  const _TituloSeccionHistorial({required this.texto});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 8),
    child: Text(
      texto,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF17243C),
      ),
    ),
  );
}

class _TarjetaSolicitudRechazada extends StatelessWidget {
  final Map<String, dynamic> solicitud;
  final VoidCallback onTap;

  const _TarjetaSolicitudRechazada({
    required this.solicitud,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final metodo = solicitud['metodo_desembolso']?.toString().toLowerCase();
    final fecha = solicitud['created_at'] ?? solicitud['fecha_solicitud'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E8F3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  color: Color(0xFFB3261E),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Solicitud #${solicitud['id_solicitud'] ?? ''}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF17243C),
                              ),
                            ),
                          ),
                          const _EtiquetaRechazada(),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '\$${formatoMontoPrestamo(solicitud['monto_solicitado'])} · ${solicitud['coutas'] ?? '—'} cuotas',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF17243C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Solicitud: ${formatoFechaPrestamo(fecha)} · ${metodo == 'nequi' ? 'Nequi' : 'Efectivo'}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF66758D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF285FE8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EtiquetaRechazada extends StatelessWidget {
  const _EtiquetaRechazada();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFFCE8E6),
      borderRadius: BorderRadius.circular(100),
    ),
    child: const Text(
      'Rechazada',
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: Color(0xFFB3261E),
      ),
    ),
  );
}

class _TarjetaPrestamoAnterior extends StatelessWidget {
  final Map<String, dynamic> prestamo;
  final VoidCallback onTap;

  const _TarjetaPrestamoAnterior({required this.prestamo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E8F3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Préstamo personal',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF17243C),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF7F0),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              'Completado',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF168261),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${formatoMontoPrestamo(prestamo['monto'])}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17243C),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formatoFechaPrestamo(prestamo['fecha_inicio']),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8090A7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF285FE8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PantallaDetalleSolicitudRechazada extends StatelessWidget {
  final Map<String, dynamic> solicitud;

  const PantallaDetalleSolicitudRechazada({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final metodo = solicitud['metodo_desembolso']?.toString().toLowerCase();
    final fecha = solicitud['created_at'] ?? solicitud['fecha_solicitud'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          24,
          top + 6,
          24,
          24 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BotonVolver(alPresionar: () => Navigator.pop(context)),
              Text(
                'PRÉSTAMOS / DETALLE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ColoresApp.textoContexto,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Solicitud rechazada',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Color(0xFF17243C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Solicitud #${solicitud['id_solicitud'] ?? ''}',
            style: const TextStyle(fontSize: 14, color: Color(0xFF66758D)),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE8E6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.cancel_outlined, color: Color(0xFFB3261E)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'El administrador rechazó esta solicitud.',
                    style: TextStyle(
                      color: Color(0xFF8C1D18),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E8F3)),
            ),
            child: Column(
              children: [
                _FilaDetalleSolicitud(
                  etiqueta: 'Monto solicitado',
                  valor:
                      '\$${formatoMontoPrestamo(solicitud['monto_solicitado'])}',
                ),
                _FilaDetalleSolicitud(
                  etiqueta: 'Número de cuotas',
                  valor: solicitud['coutas']?.toString() ?? '—',
                ),
                _FilaDetalleSolicitud(
                  etiqueta: 'Motivo de la solicitud',
                  valor: solicitud['motivo']?.toString() ?? '—',
                ),
                _FilaDetalleSolicitud(
                  etiqueta: 'Método de desembolso',
                  valor: metodo == 'nequi' ? 'Nequi' : 'Efectivo',
                ),
                if (metodo == 'nequi')
                  _FilaDetalleSolicitud(
                    etiqueta: 'Número Nequi',
                    valor: solicitud['telefono_nequi']?.toString() ?? '—',
                  ),
                _FilaDetalleSolicitud(
                  etiqueta: 'Fecha de solicitud',
                  valor: formatoFechaPrestamo(fecha),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Si necesitas más información sobre la decisión, comunícate con soporte.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF66758D),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaDetalleSolicitud extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const _FilaDetalleSolicitud({required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            etiqueta,
            style: const TextStyle(fontSize: 12, color: Color(0xFF66758D)),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF17243C),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ErrorHistorial extends StatelessWidget {
  final String mensaje;
  final VoidCallback alReintentar;

  const _ErrorHistorial({required this.mensaje, required this.alReintentar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Text(mensaje, textAlign: TextAlign.center),
          TextButton(onPressed: alReintentar, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}

class _HistorialVacio extends StatelessWidget {
  const _HistorialVacio();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          'Aún no tienes préstamos completados ni solicitudes rechazadas.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF66758D)),
        ),
      ),
    );
  }
}
