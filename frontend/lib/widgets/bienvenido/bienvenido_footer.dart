import 'package:flutter/material.dart';
import '../../core/colores.dart';

class BienvenidoFooter extends StatelessWidget {
  final double width;
  final double height;

  const BienvenidoFooter({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.08,
      right: width * 0.08,
      bottom: height * 0.05,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: Colores.blanco.withOpacity(0.55),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colores.azul,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: Colores.blanco,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu seguridad es importante\npara nosotros',
                    style: TextStyle(
                      fontFamily: "Poly",
                      color: Colores.negro,
                      fontSize: 13,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Cuidamos tu informacion en\ncada paso',
                    style: TextStyle(
                      fontFamily: "Poly_Regular",
                      color: Colores.negro,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
