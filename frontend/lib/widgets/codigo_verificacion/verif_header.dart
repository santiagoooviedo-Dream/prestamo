import 'package:flutter/material.dart';
import '../../core/colores.dart';

class VerifHeader extends StatelessWidget {
  final double width;
  final double height;

  const VerifHeader({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Card semi-transparente
        Positioned(
          left: width * 0.04,
          right: width * 0.04,
          top: height * 0.06,
          height: height * 0.88,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9).withOpacity(0.40),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),

        // Icono sobre con check
        Positioned(
          left: width * 0.30,
          right: width * 0.30,
          top: height * 0.12,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.mail_outline_rounded,
                size: width * 0.22,
                color: Colores.blanco,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colores.azulSecundario,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colores.blanco,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Título
        Positioned(
          left: width * 0.10,
          right: width * 0.10,
          top: height * 0.28,
          child: const Text(
            '¡Enlace enviado!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Color(0xFF051F93),
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Subtítulo
        Positioned(
          left: width * 0.12,
          right: width * 0.12,
          top: height * 0.35,
          child: const Text(
            'Te enviaremos un enlace a',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 14,
            ),
          ),
        ),

        // Email
        Positioned(
          left: width * 0.12,
          right: width * 0.12,
          top: height * 0.385,
          child: const Text(
            'correo@ejemplo.com',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Color(0xFF051F93),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Descripción
        Positioned(
          left: width * 0.10,
          right: width * 0.10,
          top: height * 0.43,
          child: const Text(
            'Revisa tu bandeja de entrada y sigue\n'
            'las instrucciones para crear tu cuenta',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 14,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
