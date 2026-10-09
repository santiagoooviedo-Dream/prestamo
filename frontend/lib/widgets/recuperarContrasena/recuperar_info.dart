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
      top: height * .625,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: Colores.azul,
            size: 25,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Ingresa tu correo y te enviaremos\n'
              'un código para restablecer tu contraseña',
              style: const TextStyle(
                fontFamily: "Poly_regular",
                color: Colores.negro,
                fontSize: 16,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}