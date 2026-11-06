import 'package:flutter/material.dart';

class ResumenEstimado extends StatelessWidget {
  final int monto;
  final int cuotas;
  final double tasa; // 0.10 = 10%

  const ResumenEstimado({
    super.key,
    required this.monto,
    required this.cuotas,
    this.tasa = 0.10,
  });

  static String formato(int n) {
    final s = n.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return n < 0 ? '-$buf' : buf.toString();
  }

  /// Reparte [total] en [n] cuotas redondeadas a centenas (ej. 366.700).
  /// Las primeras quedan iguales; la última ajusta para que sumen el total exacto.
  static List<int> montosCuotasRedondeados(int total, int n) {
    if (n <= 0) return const [];
    if (n == 1) return [total];

    final crudo = total / n;
    // Centena más cercana (366.666 → 366.700)
    var base = ((crudo / 100).round() * 100);
    if (base <= 0) base = total ~/ n;

    final lista = List<int>.filled(n, base);
    final sumaParcial = base * (n - 1);
    lista[n - 1] = total - sumaParcial;

    // Seguridad: si la última queda inválida, división entera clásica
    if (lista[n - 1] <= 0) {
      final b = total ~/ n;
      final r = total - b * n;
      return [for (var i = 0; i < n; i++) i == n - 1 ? b + r : b];
    }
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    final interes = (monto * tasa).round();
    final total = monto + interes;
    final montos = montosCuotasRedondeados(total, cuotas);
    final cuotaMensual = montos.isEmpty ? 0 : montos.first;
    final ahora = DateTime.now();
    final inicio = DateTime(ahora.year, ahora.month + 1, 15);
    final fin = DateTime(inicio.year, inicio.month + cuotas - 1, 15);

    String fFecha(DateTime d) {
      final dd = d.day.toString().padLeft(2, '0');
      final mm = d.month.toString().padLeft(2, '0');
      return '$dd/$mm/${d.year}';
    }

    return Container(
      width: double.infinity,
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
              const Expanded(
                child: Text(
                  'Resumen estimado',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17243C),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$cuotas cuotas',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF285FE8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Simulación con interés simple del 10 % sobre el monto solicitado. Confirma si la tasa es total, mensual o anual antes de solicitar.',
            style: TextStyle(fontSize: 12, color: Color(0xFF94A0B3), height: 1.35),
          ),
          const SizedBox(height: 14),
          _fila('Monto solicitado', '\$${formato(monto)}', grande: true),
          const SizedBox(height: 8),
          _fila('Interés total estimado', '10 % · \$${formato(interes)}'),
          const SizedBox(height: 8),
          _fila('Total a pagar', '\$${formato(total)}', grande: true),
          const SizedBox(height: 8),
          _fila('Cuota mensual', '\$${formato(cuotaMensual)}', grande: true),
          const SizedBox(height: 8),
          _fila('Primer pago', fFecha(inicio)),
          const SizedBox(height: 8),
          _fila('Último pago', fFecha(fin)),
        ],
      ),
    );
  }

  Widget _fila(String label, String valor, {bool grande = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: grande ? 14 : 13,
              color: const Color(0xFF66758D),
              fontWeight: grande ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontSize: grande ? 15 : 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF17243C),
          ),
        ),
      ],
    );
  }
}
