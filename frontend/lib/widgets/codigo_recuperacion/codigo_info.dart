import 'package:flutter/material.dart';
import '../../core/colores.dart';

class CodigoInfo extends StatelessWidget {
  final double width;
  final double height;

  const CodigoInfo({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.063,
      right: width * 0.063,
      top: height * 0.767,
      height: height * 0.141,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          color: Colores.grisMedio.withOpacity(0.90),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.access_time_rounded,
              color: Colores.azul,
              size: 28,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¿No lo ves?',
                    style: TextStyle(
                      fontFamily: "Poly_Regular",
                      color: Colores.negro,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Revisa tu carpeta de spam o espera unos\n'
                    'minutos y vuelve a intentarlo',
                    style: TextStyle(
                      fontFamily: "Poly_Regular",
                      color: Colores.negro,
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Reenviar enlace',
                    style: TextStyle(
                      fontFamily: "Poly_Regular",
                      color: Colores.azulSecundario,
                      fontSize: 16,
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
