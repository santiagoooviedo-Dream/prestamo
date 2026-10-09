import 'package:flutter/material.dart';
import '../../core/colores.dart';

class ConfirmarStatus extends StatelessWidget {
  final double width;
  final double height;

  const ConfirmarStatus({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.10,
      top: height * 0.470,
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colores.verde,
            size: 20,
          ),
          const SizedBox(width: 8),
          const Text(
            'Las contraseñas coinciden',
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
