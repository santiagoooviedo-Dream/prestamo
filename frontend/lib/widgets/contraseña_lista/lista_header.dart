import 'package:flutter/material.dart';
import '../../core/colores.dart';

class ListaHeader extends StatelessWidget {
  final double width;
  final double height;

  const ListaHeader({
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
          left: width * 0.03,
          top: height * 0.012,
          child: IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back, color: Colores.negro, size: 26),
          ),
        ),

        // 3 de 3
        Positioned(
          right: width * 0.055,
          top: height * 0.022,
          child: const Text(
            '3 de 3',
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.blanco,
              fontSize: 14,
            ),
          ),
        ),

        // Progress bar full
        Positioned(
          left: width * 0.28,
          right: width * 0.28,
          top: height * 0.095,
          height: 6,
          child: Container(
            decoration: BoxDecoration(
              color: Colores.azulOscuro,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ],
    );
  }
}
