import 'package:flutter/material.dart';
import '../../core/colores.dart';

class LoginFooter extends StatelessWidget {
  final double width;
  final double height;

  const LoginFooter({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: height * .745,
      child: Column(
        children: [
          const Text(
            'En caso de que no tengas cuenta',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colores.negro,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Crear cuenta',
            style: TextStyle(
              color: Colores.azul,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}