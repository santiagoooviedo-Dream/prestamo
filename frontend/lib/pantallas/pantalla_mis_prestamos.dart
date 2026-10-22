import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_inicio.dart';
import 'pantalla_solicitar_prestamo.dart';

class PantallaMisPrestamos extends StatefulWidget {
  const PantallaMisPrestamos({super.key});

  @override
  State<PantallaMisPrestamos> createState() => _PantallaMisPrestamosState();
}

class _PantallaMisPrestamosState extends State<PantallaMisPrestamos> {
  late Future<Map<String, List<Map<String, dynamic>>>> _datos;

  @override
  void initState() {
    super.initState();
    _datos = _cargar();
  }

  Future<Map<String, List<Map<String, dynamic>>>> _cargar() async {
    final resultados = await Future.wait([
      ApiService.obtenerSolicitudes(),
      ApiService.obtenerPrestamos(),
    ]);
    return {'solicitudes': resultados[0], 'prestamos': resultados[1]};
  }

  void _recargar() => setState(() => _datos = _cargar());

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
              future: _datos,
              builder: (context, snapshot) {
                return ListView(
                  padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BotonVolver(
                          alPresionar: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PantallaInicio(),
                              ),
                              (_) => false,
                            );
                          },
                        ),
                        Text(
                          'PRÉSTAMOS',
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
                      'Mis préstamos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (snapshot.hasError)
                      _EstadoCarga(
                        mensaje: snapshot.error is ApiException
                            ? (snapshot.error as ApiException).mensaje
                            : 'No se pudo cargar la información.',
                        accion: _recargar,
                      )
                    else ...[
                      for (final solicitud in snapshot.data!['solicitudes']!)
                        _TarjetaSolicitud(solicitud: solicitud),
                      for (final prestamo in snapshot.data!['prestamos']!)
                        _TarjetaPrestamo(prestamo: prestamo),
                      if (snapshot.data!['solicitudes']!.isEmpty &&
                          snapshot.data!['prestamos']!.isEmpty)
                        const _EstadoVacio(),
                    ],
                    const SizedBox(height: 20),
                    BotonPrimario(
                      texto: 'Solicitar un préstamo',
                      alPresionar: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PantallaSolicitarPrestamo(),
                        ),
                      ),
                    ),
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

class _TarjetaSolicitud extends StatelessWidget {
  final Map<String, dynamic> solicitud;

  const _TarjetaSolicitud({required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final estado = solicitud['estado']?.toString() ?? 'pendiente';
    final esAprobada = estado == 'aceptada';
    final metodo = solicitud['metodo_desembolso']?.toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Solicitud #${solicitud['id_solicitud'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF17243C),
                  ),
                ),
              ),
              _EtiquetaEstado(estado: estado),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '\$${_formatoMonto(solicitud['monto_solicitado'])} · ${solicitud['coutas'] ?? '—'} cuotas',
            style: const TextStyle(fontSize: 16, color: Color(0xFF17243C)),
          ),
          const SizedBox(height: 5),
          Text(
            'Desembolso: ${metodo == 'nequi' ? 'Nequi · ${solicitud['telefono_nequi'] ?? ''}' : 'Efectivo'}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF66758D)),
          ),
          if (esAprobada) ...[
            const SizedBox(height: 8),
            Text(
              'Fecha y hora: ${_fechaHora(solicitud['fecha_desembolso'])}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF285FE8)),
            ),
            if (metodo == 'efectivo')
              Text(
                'Punto de recogida: ${solicitud['lugar_recogida'] ?? 'Consulta tus notificaciones'}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF285FE8)),
              ),
          ],
        ],
      ),
    );
  }
}

class _TarjetaPrestamo extends StatelessWidget {
  final Map<String, dynamic> prestamo;

  const _TarjetaPrestamo({required this.prestamo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF214EC4), Color(0xFF2865D8)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Préstamo activo',
            style: TextStyle(fontSize: 13, color: Color(0xFFE4EDFF)),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${_formatoMonto(prestamo['monto'])}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${prestamo['coutas'] ?? '—'} cuotas · Cuota mensual \$${_formatoMonto(prestamo['coutas_mensual'])}',
            style: const TextStyle(fontSize: 13, color: Color(0xFFE4EDFF)),
          ),
        ],
      ),
    );
  }
}

class _EtiquetaEstado extends StatelessWidget {
  final String estado;

  const _EtiquetaEstado({required this.estado});

  @override
  Widget build(BuildContext context) {
    final color = estado == 'aceptada'
        ? const Color(0xFF168261)
        : estado == 'rechazada'
        ? const Color(0xFFB42318)
        : const Color(0xFF285FE8);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        estado[0].toUpperCase() + estado.substring(1),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _EstadoCarga extends StatelessWidget {
  final String mensaje;
  final VoidCallback accion;

  const _EstadoCarga({required this.mensaje, required this.accion});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      children: [
        Text(
          mensaje,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF66758D)),
        ),
        TextButton(onPressed: accion, child: const Text('Reintentar')),
      ],
    ),
  );
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 48),
    child: Center(
      child: Text(
        'Todavía no tienes solicitudes ni préstamos.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Color(0xFF66758D)),
      ),
    ),
  );
}

String _formatoMonto(dynamic valor) {
  final numero = int.tryParse(valor?.toString() ?? '') ?? 0;
  final texto = numero.toString();
  final salida = StringBuffer();
  for (var i = 0; i < texto.length; i++) {
    if (i > 0 && (texto.length - i) % 3 == 0) salida.write('.');
    salida.write(texto[i]);
  }
  return salida.toString();
}

String _fechaHora(dynamic valor) {
  final fecha = DateTime.tryParse(valor?.toString() ?? '');
  if (fecha == null) return 'Consulta tus notificaciones';
  final local = fecha.toLocal();
  final dia = local.day.toString().padLeft(2, '0');
  final mes = local.month.toString().padLeft(2, '0');
  final hora = local.hour.toString().padLeft(2, '0');
  final minuto = local.minute.toString().padLeft(2, '0');
  return '$dia/$mes/${local.year} · $hora:$minuto';
}
