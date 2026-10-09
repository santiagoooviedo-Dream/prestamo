import 'package:flutter/material.dart';
import '../../core/colores.dart';

class CrearHeader extends StatelessWidget {
  final double width;
  final double height;

  const CrearHeader({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Título grande
        Positioned(
          left: width * 0.08,
          top: height * 0.06,
          child: const Text(
            'Crear\ncuenta',
            style: TextStyle(
              fontFamily: "Poly",
              color: Colores.negro,
              fontSize: 40,
              height: 1.05,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Subtítulo
        Positioned(
          left: width * 0.08,
          top: height * 0.195,
          child: const Text(
            'Completa tus datos para comenzar',
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
