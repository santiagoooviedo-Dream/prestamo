import 'package:flutter/material.dart';
import '../../core/colores.dart';

class VerifInputs extends StatelessWidget {
  final double width;
  final double height;

  const VerifInputs({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final boxW = width * 0.115;
    final boxH = height * 0.070;
    final gap = width * 0.018;
    final totalW = (boxW * 6) + (gap * 5);
    final startLeft = (width - totalW) / 2;
    final top = height * 0.52;

    return Stack(
      children: List.generate(6, (i) {
        return Positioned(
          left: startLeft + (boxW + gap) * i,
          top: top,
          width: boxW,
          height: boxH,
          child: Container(
            decoration: BoxDecoration(
              color: Colores.blanco.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colores.azulSecundario.withOpacity(0.6),
                width: 1.5,
              ),
            ),
          ),
        );
      }),
    );
  }
}
