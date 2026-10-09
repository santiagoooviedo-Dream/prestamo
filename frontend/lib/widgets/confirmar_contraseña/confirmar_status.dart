import 'package:flutter/material.dart';
import '../../core/colores.dart';

class ConfirmarStatus extends StatelessWidget {
  final double width;
  final double height;
  final bool? coinciden;

  const ConfirmarStatus({
    super.key,
    required this.width,
    required this.height,
    required this.coinciden,
  });

  @override
  Widget build(BuildContext context) {
    if (coinciden == null) return const SizedBox.shrink();

    return Positioned(
      left: width * 0.10,
      top: height * 0.470,
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: coinciden! ? Colores.verde : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            coinciden! ? 'Las contraseñas coinciden' : 'Las contraseñas no coinciden',
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: coinciden! ? Colores.negro : Colors.red,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
