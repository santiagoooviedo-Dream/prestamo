import 'package:flutter/material.dart';

import '../models/prestamo_model.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';

class PantallaDetallePrestamoCompletado extends StatelessWidget {
  final Map<String, dynamic> prestamo;
  final List<Map<String, dynamic>> cuotas;

  const PantallaDetallePrestamoCompletado({
    super.key,
    required this.prestamo,
    required this.cuotas,
  });

  /// Misma regla que el calendario: primer pago = mes siguiente al inicio, día 15.
  static DateTime _basePrimerPago(DateTime? fechaInicio) {
    final ref = fechaInicio ?? DateTime.now();
    return DateTime(ref.year, ref.month + 1, 15);
  }

  static DateTime _fechaMensual(DateTime base, int meses) {
    final y = base.year;
    final m = base.month + meses;
    final year = y + ((m - 1) ~/ 12);
    final month = ((m - 1) % 12) + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = base.day > lastDay ? lastDay : base.day;
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    final numeroCuotas = numeroCuotasPrestamo(prestamo, cuotas);
    final inicioRaw =
        DateTime.tryParse(prestamo['fecha_inicio']?.toString() ?? '');

    final basePrimerPago = _basePrimerPago(inicioRaw);
    final fechaFinCalculada = numeroCuotas > 0
        ? _fechaMensual(basePrimerPago, numeroCuotas - 1)
        : null;

    final tasa = tasaDelPrestamo(prestamo);
    final interesPorcentaje = '${(tasa * 100).toStringAsFixed(0)}%';
    final cuotaMensualRaw = cuotaMensualConInteres(prestamo, cuotas);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 24 + bottom),
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
              'Préstamo completado',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F7F0),
                borderRadius: BorderRadius.circular(20),
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
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${formatoMontoPrestamo(prestamo['monto'])}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F7F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Color(0xFF168261),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Préstamo pagado en su totalidad',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF168261),
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
                  _Fila(
                    label: 'Fecha de inicio',
                    valor: formatoFechaPrestamo(prestamo['fecha_inicio']),
                  ),
                  _Fila(
                    label: 'Primer pago',
                    valor: formatoFechaPrestamo(
                      basePrimerPago.toIso8601String(),
                    ),
                  ),
                  _Fila(
                    label: 'Fecha de finalización',
                    valor: fechaFinCalculada == null
                        ? '—'
                        : formatoFechaPrestamo(
                            fechaFinCalculada.toIso8601String(),
                          ),
                  ),
                  _Fila(
                    label: 'Plazo',
                    valor: numeroCuotas == 0 ? '—' : '$numeroCuotas meses',
                  ),
                  _Fila(label: 'Tasa de interés', valor: interesPorcentaje),
                  _Fila(
                    label: 'Cuota mensual',
                    valor: cuotaMensualRaw <= 0
                        ? '—'
                        : '\$${formatoMontoPrestamo(cuotaMensualRaw)}',
                  ),
                ],
              ),
            ),
          ],
        ),
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
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF66758D)),
          ),
          Text(
            valor,
            style: const TextStyle(fontSize: 12, color: Color(0xFF17243C)),
          ),
        ],
      ),
    );
  }
}
