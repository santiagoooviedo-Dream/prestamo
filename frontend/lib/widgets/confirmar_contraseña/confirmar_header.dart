import 'package:flutter/material.dart';
import '../../core/colores.dart';

class ConfirmarHeader extends StatelessWidget {
  final double width;
  final double height;

  const ConfirmarHeader({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Back arrow
        Positioned(
          left: width * 0.04,
          top: height * 0.012,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back,
              color: Colores.negro,
              size: 28,
            ),
          ),
        ),

        // Step indicator
        Positioned(
          right: width * 0.06,
          top: height * 0.020,
          child: const Text(
            '2 de 3',
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.blanco,
              fontSize: 14,
            ),
          ),
        ),

        // Progress bar background
        Positioned(
          left: width * 0.26,
          right: width * 0.26,
          top: height * 0.107,
          height: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colores.azulClaro,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Progress bar filled (2/3)
        Positioned(
          left: width * 0.26,
          top: height * 0.107,
          width: width * 0.32,
          height: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colores.azulOscuro,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Title
        Positioned(
          left: width * 0.08,
          right: width * 0.08,
          top: height * 0.184,
          child: const Text(
            'Confirmar contraseña',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 32,
              height: 1.05,
            ),
          ),
        ),

        // Subtitle
        Positioned(
          left: width * 0.10,
          right: width * 0.10,
          top: height * 0.278,
          child: const Text(
            'Vuelve a ingresar tu nueva contraseña\npara confirmar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 16,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
