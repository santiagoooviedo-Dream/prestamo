import 'package:flutter/material.dart';
import '../../core/colores.dart';

class RecuperarInfo extends StatelessWidget {
  final double width;
  final double height;

  const RecuperarInfo({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * .145,
      right: width * .12,
      top: height * .695,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: Colores.azul,
            size: 23,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Ingresa tu correo y te enviaremos\n'
              'un enlace para restablecer tu contraseña',
              style: const TextStyle(
                color: Colores.negro,
                fontSize: 15,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}