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
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final interes = (monto * tasa).round();
    final total = monto + interes;
    final cuotaBase = total ~/ cuotas;
    final resto = total - cuotaBase * cuotas;
    final cuotaMensual = cuotaBase + (resto > 0 ? 0 : 0); // display base
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          const SizedBox(height: 10),
          const Text(
            'Simulación con interés simple del 10 % sobre el monto solicitado. Confirma si la tasa es total, mensual o anual antes de solicitar.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF66758D),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          _fila('Monto solicitado', '\$${formato(monto)}', grande: true),
          const SizedBox(height: 12),
          _fila('Periodicidad', 'Mensual'),
          const SizedBox(height: 12),
          _fila(
            'Interés total estimado',
            '10 % · \$${formato(interes)}',
          ),
          const SizedBox(height: 12),
          _fila('Total a pagar', '\$${formato(total)}', grande: true),
          const SizedBox(height: 12),
          _fila('Cuota mensual', '\$${formato(cuotaBase)}', grande: true),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _fecha('Inicio', fFecha(inicio))),
              Expanded(child: _fecha('Fin', fFecha(fin))),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Valores estimados. Última cuota ajustada por redondeo. Tasa y condiciones por confirmar.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF94A0B3),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fila(String label, String valor, {bool grande = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF94A0B3)),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: TextStyle(
            fontSize: grande ? 20 : 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF17243C),
          ),
        ),
      ],
    );
  }

  Widget _fecha(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A0B3))),
        const SizedBox(height: 2),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF17243C),
          ),
        ),
      ],
    );
  }
}
