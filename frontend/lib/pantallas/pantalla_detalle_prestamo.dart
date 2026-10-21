import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_calendario_pagos.dart';

class PantallaDetallePrestamo extends StatelessWidget {
  const PantallaDetallePrestamo({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 20),
                  const Text(
                    'Préstamo actual',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Cuota mensual',
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xFFE4EDFF))),
                            Text('\$200.000',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Próximo pago',
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xFFE4EDFF))),
                            Text('20 abril 2026',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE1E8F3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('2 de 12 cuotas',
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFF17243C))),
                            Text('16%',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF285FE8))),
                          ],
                        ),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE1E8F3)),
                    ),
                    child: const Column(
                      children: [
                        _Fila(label: 'Fecha de inicio', valor: '10 febrero 2026'),
                        _Fila(label: 'Plazo', valor: '12 meses'),
                        _Fila(label: 'Tasa de interés', valor: '10%'),
                        _Fila(label: 'Estado', valor: 'Al día'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 16 + bottom),
            child: BotonPrimario(
              texto: 'Ver calendario de pagos',
              alPresionar: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaCalendarioPagos()),
                  );
              },
            ),
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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