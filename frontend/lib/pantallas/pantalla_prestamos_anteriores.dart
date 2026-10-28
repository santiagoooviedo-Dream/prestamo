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
                final anteriores = snapshot.data?.prestamosAnteriores;
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
                    else if (anteriores!.isEmpty)
                      const _HistorialVacio()
                    else
                      for (final prestamo in anteriores)
                        _TarjetaPrestamoAnterior(
                          prestamo: prestamo,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PantallaDetallePrestamoCompletado(
                                prestamo: prestamo,
                                cuotas: snapshot.data!.cuotasDelPrestamo(
                                  prestamo['id_prestamo'],
                                ),
                              ),
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
          'Aún no tienes préstamos completados.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF66758D)),
        ),
      ),
    );
  }
}
