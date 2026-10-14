import 'package:flutter/material.dart';
import '../../core/colores.dart';

class BienvenidoHeader extends StatelessWidget {
  final double width;
  final double height;

  const BienvenidoHeader({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: width * 0.08,
          right: width * 0.08,
          top: height * 0.06,
          child: const Text(
            '¡Bienvenido!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly",
              color: Colores.negro,
              fontSize: 34,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
        ),
        Positioned(
          left: width * 0.08,
          right: width * 0.08,
          top: height * 0.125,
          child: const Text(
            '¿Que te gustaria hacer hoy?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
