import 'package:flutter/material.dart';

import 'resumen_estimado.dart';
import '../../nucleo/colores_app.dart';

class CalendarioCuotas extends StatelessWidget {
  final int monto;
  final int cuotas;
  final double tasa;

  const CalendarioCuotas({
    super.key,
    required this.monto,
    required this.cuotas,
    this.tasa = 0.10,
  });

  @override
  Widget build(BuildContext context) {
    final interes = (monto * tasa).round();
    final total = monto + interes;
    final montos = ResumenEstimado.montosCuotasRedondeados(total, cuotas);

    final ahora = DateTime.now();
    final inicio = DateTime(ahora.year, ahora.month + 1, 15);

    String fFecha(DateTime d) {
      final dd = d.day.toString().padLeft(2, '0');
      final mm = d.month.toString().padLeft(2, '0');
      return '$dd/$mm/${d.year}';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColoresApp.bordeTarjeta),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Calendario de pagos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ColoresApp.fondoSeleccionado,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$cuotas pagos',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.primario,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(cuotas, (i) {
            final valor = montos[i];
            final fecha = DateTime(inicio.year, inicio.month + i, 15);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: ColoresApp.fondoSuave,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColoresApp.bordeSuave4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cuota ${i + 1}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ColoresApp.textoPrincipal,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fFecha(fecha),
                          style: const TextStyle(
                            fontSize: 12,
                            color: ColoresApp.textoSuave,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${ResumenEstimado.formato(valor)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
