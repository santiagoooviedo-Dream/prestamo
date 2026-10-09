import 'package:flutter/material.dart';
import '../../core/colores.dart';

class CodigoInputs extends StatelessWidget {
  final double width;
  final double height;

  const CodigoInputs({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final boxWidth = width * 0.129;
    final boxHeight = height * 0.081;
    final startLeft = width * 0.043;
    final gap = width * 0.025;
    final top = height * 0.500;

    return Stack(
      children: List.generate(6, (index) {
        return Positioned(
          left: startLeft + (boxWidth + gap) * index,
          top: top,
          width: boxWidth,
          height: boxHeight,
          child: Container(
            decoration: BoxDecoration(
              color: Colores.grisMedio,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colores.azulSecundario,
                width: 2,
              ),
            ),
          ),
        );
      }),
    );
  }
}
