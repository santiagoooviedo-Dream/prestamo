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
      left: width * 0.105,
      right: width * 0.105,
      bottom: height * 0.078,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 17, 12, 17),
        decoration: BoxDecoration(
          color: const Color(0x33FFFFFF),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              height: 48,
              child: Icon(
                Icons.verified_user_rounded,
                color: Colores.azul,
                size: 43,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tu seguridad es importante\npara nosotros',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Poly',
                      color: Colores.negro,
                      fontSize: 17,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Cuidamos tu informacion en\ncada paso',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poly_Regular',
                        color: Colores.negro,
                        fontSize: 15,
                        height: 1.3,
                      ),
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
