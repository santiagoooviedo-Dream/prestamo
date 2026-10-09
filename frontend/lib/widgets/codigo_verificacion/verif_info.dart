import 'package:flutter/material.dart';
import '../../core/colores.dart';

class VerifInfo extends StatelessWidget {
  final double width;
  final double height;

  const VerifInfo({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.08,
      right: width * 0.08,
      top: height * 0.72,
      height: height * 0.16,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
        decoration: BoxDecoration(
          color: Colores.blanco.withOpacity(0.75),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: Colores.azul,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¿No lo ves?',
                    style: TextStyle(
                      fontFamily: "Poly_Regular",
                      color: Colores.negro,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Revisa tu carpeta de spam o espera unos\n'
                    'minutos y vuelve a intentarlo',
                    style: TextStyle(
                      fontFamily: "Poly_Regular",
                      color: Colores.negro,
                      fontSize: 12,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Reenviar enlace',
                    style: TextStyle(
                      fontFamily: "Poly_Regular",
                      color: Colores.azulSecundario,
                      fontSize: 14,
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
