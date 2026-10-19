import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_detalle_prestamo_completado.dart';

class PantallaPrestamosAnteriores extends StatelessWidget {
  const PantallaPrestamosAnteriores({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final items = List.generate(
      4,
      (_) => ('Préstamo personal', '\$600.000', '15 enero 2026'),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
                  style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
                ),
                const SizedBox(height: 20),
                ...items.map((p) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PantallaDetallePrestamoCompletado()),
                      );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                      Text(
                                        p.$1,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF17243C),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF7F0),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: const Text(
                                          'Completado',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF168261),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    p.$2,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF17243C),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    p.$3,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF66758D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: Color(0xFF94A0B3)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const BarraNavegacion(actual: DestinoNav.prestamos),
        ],
      ),
    );
  }
}
