import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_calendario_pagos.dart';
import 'pantalla_actividad_cuenta.dart';

class PantallaEstadoCuenta extends StatelessWidget {
  const PantallaEstadoCuenta({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'MI CUENTA',
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
              'Estado de cuenta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Un resumen de tu actividad más reciente.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF214EC4), Color(0xFF2865D8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Monto total',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFFE4EDFF))),
                          SizedBox(height: 6),
                          Text(
                            '\$1.000.000',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Cuotas pagadas',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFE4EDFF))),
                                    SizedBox(height: 4),
                                    Text('2 de 12',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Próximo pago',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFE4EDFF))),
                                    SizedBox(height: 4),
                                    Text('20 mayo 2026',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Actividad reciente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF17243C),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaActividadCuenta())),
                          child: const Text(
                            'Ver todo',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF285FE8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _Movimiento(
                      icono: Icons.calendar_today_outlined,
                      titulo: 'Pago de cuota',
                      sub: 'Cuota #2 de 12',
                      monto: '+\$200.000',
                      fecha: '20 abril 2026',
                      positivo: true,
                    ),
                    const SizedBox(height: 10),
                    const _Movimiento(
                      icono: Icons.south_west_rounded,
                      titulo: 'Desembolso',
                      sub: 'Préstamo personal',
                      monto: '+\$1.000.000',
                      fecha: '10 abril 2026',
                      positivo: true,
                    ),
                    const SizedBox(height: 10),
                    const _Movimiento(
                      icono: Icons.percent_rounded,
                      titulo: 'Interés aplicado',
                      sub: 'Mensual',
                      monto: '-\$12.000',
                      fecha: '10 abril 2026',
                      positivo: false,
                    ),
                    const SizedBox(height: 16),
                    const AvisoSeguridad(
                      texto:
                          'Consulta el calendario de pagos para ver todas tus fechas importantes.',
                    ),
                  ],
                ),
              ),
            ),
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
    );
  }
}

class _Movimiento extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String sub;
  final String monto;
  final String fecha;
  final bool positivo;

  const _Movimiento({
    required this.icono,
    required this.titulo,
    required this.sub,
    required this.monto,
    required this.fecha,
    required this.positivo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icono, size: 20, color: const Color(0xFF285FE8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C))),
                Text(sub,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF66758D))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                monto,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: positivo
                      ? const Color(0xFF168261)
                      : const Color(0xFFD97706),
                ),
              ),
              Text(fecha,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF66758D))),
            ],
          ),
        ],
      ),
    );
  }
}
