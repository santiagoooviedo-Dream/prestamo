import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_calendario_pagos.dart';
import 'pantalla_prestamos_anteriores.dart';
import 'pantalla_inicio.dart';
import 'pantalla_detalle_prestamo.dart';

class PantallaMisPrestamos extends StatelessWidget {
  const PantallaMisPrestamos({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BotonVolver(
                      alPresionar: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const PantallaInicio()),
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
                GestureDetector(
                  onTap: () =>
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaDetallePrestamo()),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF214EC4), Color(0xFF2865D8)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x2B285FE8),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Préstamo actual',
                          style:
                              TextStyle(fontSize: 13, color: Color(0xFFE4EDFF)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\$1.000.000',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Divider(color: Color(0x55FFFFFF), height: 1),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cuotas pendientes',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFFE4EDFF)),
                            ),
                            Text(
                              '2 de 12',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () =>
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaDetallePrestamo()),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE1E8F3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Préstamo personal',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF17243C),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF7F0),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Text(
                                'Activo',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF168261),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const _Fila(label: 'Fecha', valor: '10 abril 2026'),
                        const _Fila(label: 'Cuota mensual', valor: '\$200.000'),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: const LinearProgressIndicator(
                            value: 2 / 12,
                            minHeight: 6,
                            backgroundColor: Color(0xFFE3E9F2),
                            valueColor:
                                AlwaysStoppedAnimation(Color(0xFF285FE8)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '2 de 12 cuotas pagadas',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF66758D)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () =>
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaPrestamosAnteriores()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE1E8F3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF3FF),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(Icons.history,
                              size: 20, color: Color(0xFF285FE8)),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'Préstamos anteriores',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF17243C)),
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: Color(0xFF94A0B3)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BotonPrimario(
                  texto: 'Ver calendario de pagos',
                  alPresionar: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaCalendarioPagos()),
                  );
                  },
                ),
              ],
            ),
          ),
          const BarraNavegacion(actual: DestinoNav.prestamos),
        ],
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  final String label;
  final String valor;
  const _Fila({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF66758D))),
          Text(valor,
              style: const TextStyle(fontSize: 13, color: Color(0xFF17243C))),
        ],
      ),
    );
  }
}
