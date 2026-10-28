import 'package:flutter/material.dart';

import '../models/prestamo_model.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_calendario_pagos.dart';

class PantallaDetallePrestamo extends StatelessWidget {
  final Map<String, dynamic> prestamo;
  final List<Map<String, dynamic>> cuotas;

  const PantallaDetallePrestamo({
    super.key,
    required this.prestamo,
    required this.cuotas,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final totalCuotas =
        int.tryParse(prestamo['coutas']?.toString() ?? '') ?? cuotas.length;
    final pagadas = cuotas.where(_estaPagada).length;
    final progreso = totalCuotas == 0
        ? 0.0
        : (pagadas / totalCuotas).clamp(0.0, 1.0).toDouble();
    final pendientes = cuotas.where((cuota) => !_estaPagada(cuota)).toList()
      ..sort((a, b) {
        final fechaA = DateTime.tryParse(a['fecha_pago']?.toString() ?? '');
        final fechaB = DateTime.tryParse(b['fecha_pago']?.toString() ?? '');
        if (fechaA == null) return 1;
        if (fechaB == null) return -1;
        return fechaA.compareTo(fechaB);
      });
    final proximoPago = pendientes.isEmpty
        ? '—'
        : formatoFechaPrestamo(pendientes.first['fecha_pago']);
    final interes = num.tryParse(prestamo['interes']?.toString() ?? '');
    final interesPorcentaje = interes == null
        ? '—'
        : '${interes > 1 ? interes.toStringAsFixed(0) : (interes * 100).toStringAsFixed(0)}%';
    final estadoRecibido = prestamo['estado']?.toString() ?? '';
    final estado = estadoRecibido.isEmpty ? 'Activo' : estadoRecibido;

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
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF285FE8), Color(0xFF214EC4)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monto total',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFE4EDFF),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${formatoMontoPrestamo(prestamo['monto'])}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _FilaDetalle(
                          etiqueta: 'Cuota mensual',
                          valor:
                              '\$${formatoMontoPrestamo(prestamo['coutas_mensual'])}',
                          claro: true,
                        ),
                        const SizedBox(height: 8),
                        _FilaDetalle(
                          etiqueta: 'Próximo pago',
                          valor: proximoPago,
                          claro: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE1E8F3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              totalCuotas == 0
                                  ? 'Cuotas no disponibles'
                                  : '$pagadas de $totalCuotas cuotas',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF17243C),
                              ),
                            ),
                            Text(
                              '${(progreso * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF285FE8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progreso,
                            minHeight: 5,
                            backgroundColor: const Color(0xFFE3E9F2),
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF285FE8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE1E8F3)),
                    ),
                    child: Column(
                      children: [
                        _FilaDetalle(
                          etiqueta: 'Fecha de inicio',
                          valor: formatoFechaPrestamo(prestamo['fecha_inicio']),
                        ),
                        _FilaDetalle(
                          etiqueta: 'Plazo',
                          valor: totalCuotas == 0 ? '—' : '$totalCuotas meses',
                        ),
                        _FilaDetalle(
                          etiqueta: 'Tasa de interés',
                          valor: interesPorcentaje,
                        ),
                        _FilaDetalle(
                          etiqueta: 'Estado',
                          valor:
                              '${estado[0].toUpperCase()}${estado.substring(1)}',
                        ),
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
                  MaterialPageRoute(
                    builder: (_) => const PantallaCalendarioPagos(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaDetalle extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final bool claro;

  const _FilaDetalle({
    required this.etiqueta,
    required this.valor,
    this.claro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          etiqueta,
          style: TextStyle(
            fontSize: 12,
            color: claro ? const Color(0xFFE4EDFF) : const Color(0xFF66758D),
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontSize: 12,
            color: claro ? Colors.white : const Color(0xFF17243C),
          ),
        ),
      ],
    );
  }
}

bool _estaPagada(Map<String, dynamic> cuota) {
  final estado = cuota['estado']?.toString().toLowerCase();
  return estado == 'pagada' || estado == 'pagado';
}
