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

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final fechaFinRaw = prestamo['fecha_finalizacion'] ?? prestamo['fecha_fin'];
    final numeroCuotas =
        int.tryParse(prestamo['coutas']?.toString() ?? '') ?? cuotas.length;

    // Calcular fecha de finalización si el backend no la envía
    String fechaFinCalculada = '—';
    if (fechaFinRaw != null && fechaFinRaw.toString().isNotEmpty) {
      fechaFinCalculada = formatoFechaPrestamo(fechaFinRaw);
    } else {
      // Intentar con la última cuota pagada/programada
      if (cuotas.isNotEmpty) {
        final ordenadas = List<Map<String, dynamic>>.from(cuotas)
          ..sort((a, b) {
            final fa = DateTime.tryParse(a['fecha_pago']?.toString() ?? '');
            final fb = DateTime.tryParse(b['fecha_pago']?.toString() ?? '');
            if (fa == null) return 1;
            if (fb == null) return -1;
            return fa.compareTo(fb);
          });
        final ultima = ordenadas.last['fecha_pago'];
        if (ultima != null) {
          fechaFinCalculada = formatoFechaPrestamo(ultima);
        }
      }
      // Fallback: fecha_inicio + plazo en meses
      if (fechaFinCalculada == '—') {
        final inicio = DateTime.tryParse(prestamo['fecha_inicio']?.toString() ?? '');
        if (inicio != null && numeroCuotas > 0) {
          final fin = DateTime(inicio.year, inicio.month + numeroCuotas, inicio.day);
          fechaFinCalculada = formatoFechaPrestamo(fin.toIso8601String());
        }
      }
    }

    // La app usa tasa fija del 10%. Si el backend no envía el campo o llega 0, mostramos 10%.
    final interesRaw = num.tryParse(
      prestamo['interes']?.toString() ??
          prestamo['tasa_interes']?.toString() ??
          prestamo['tasa']?.toString() ??
          '',
    );
    final interes = (interesRaw == null || interesRaw == 0) ? 0.10 : interesRaw;
    final interesPorcentaje =
        '${interes > 1 ? interes.toStringAsFixed(0) : (interes * 100).toStringAsFixed(0)}%';

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
                color: const Color(0xFFEAF7F0),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                'Completado',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF168261),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                    style: TextStyle(fontSize: 12, color: Color(0xFFE4EDFF)),
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
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7F0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1FAE5)),
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
                    label: 'Fecha de finalización',
                    valor: fechaFinCalculada,
                  ),
                  _Fila(
                    label: 'Plazo',
                    valor: numeroCuotas == 0 ? '—' : '$numeroCuotas meses',
                  ),
                  _Fila(label: 'Tasa de interés', valor: interesPorcentaje),
                  _Fila(
                    label: 'Cuota mensual',
                    valor:
                        '\$${formatoMontoPrestamo(prestamo['coutas_mensual'])}',
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
