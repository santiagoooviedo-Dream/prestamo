import 'package:flutter/material.dart';
import '../../core/colores.dart';

class NuevaHeader extends StatelessWidget {
  final double width;
  final double height;

  const NuevaHeader({
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
            '1 de 3',
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

        // Progress bar filled
        Positioned(
          left: width * 0.26,
          top: height * 0.107,
          width: width * 0.16,
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
          left: width * 0.09,
          right: width * 0.09,
          top: height * 0.184,
          child: const Text(
            'Nueva contraseña',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 34,
              height: 1.05,
            ),
          ),
        ),

        // Subtitle
        Positioned(
          left: width * 0.08,
          right: width * 0.08,
          top: height * 0.278,
          child: const Text(
            'Crea una contraseña segura para\nproteger tu cuenta',
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
