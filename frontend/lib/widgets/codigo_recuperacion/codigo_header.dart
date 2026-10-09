import 'package:flutter/material.dart';
import '../../core/colores.dart';

class CodigoHeader extends StatelessWidget {
  final double width;
  final double height;

  const CodigoHeader({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenedor principal semi-transparente
        Positioned(
          left: width * 0.036,
          right: width * 0.036,
          top: height * 0.066,
          height: height * 0.894,
          child: Container(
            decoration: BoxDecoration(
              color: Colores.grisClaro.withOpacity(0.50),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        // Título
        Positioned(
          left: width * 0.143,
          right: width * 0.143,
          top: height * 0.241,
          child: const Text(
            '¡Enlace enviado!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.azulOscuro,
              fontSize: 32,
              height: 1.0,
            ),
          ),
        ),

        // Subtítulo
        Positioned(
          left: width * 0.12,
          right: width * 0.12,
          top: height * 0.314,
          child: const Text(
            'Te enviaremos un enlace a',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 15,
            ),
          ),
        ),

        // Email
        Positioned(
          left: width * 0.12,
          right: width * 0.12,
          top: height * 0.345,
          child: const Text(
            'correo@ejemplo.com',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.azulOscuro,
              fontSize: 18,
            ),
          ),
        ),

        // Descripción
        Positioned(
          left: width * 0.08,
          right: width * 0.08,
          top: height * 0.395,
          child: const Text(
            'Revisa tu bandeja de entrada y sigue\n'
            'las instrucciones para restablecer tu\n'
            'contraseña',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 16,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}
