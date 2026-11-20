import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class TarjetaProgresoPrestamo extends StatelessWidget {
  const TarjetaProgresoPrestamo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColoresApp.bordeTarjeta),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2 de 12 cuotas',
                style: TextStyle(fontSize: 14, color: ColoresApp.textoPrincipal),
              ),
              Text(
                '16%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColoresApp.primario,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: const LinearProgressIndicator(
              value: 2 / 12,
              minHeight: 6,
              backgroundColor: ColoresApp.bordeSuave,
              valueColor: AlwaysStoppedAnimation(ColoresApp.primario),
            ),
          ),
        ],
      ),
    );
  }
}
