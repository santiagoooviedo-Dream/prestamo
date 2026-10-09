import 'package:flutter/material.dart';
import '../../core/colores.dart';

class VerifButton extends StatelessWidget {
  final double width;
  final double height;

  const VerifButton({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.10,
      right: width * 0.10,
      top: height * 0.62,
      height: height * 0.065,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colores.azulSecundario,
          foregroundColor: Colores.blanco,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Continuar',
          style: TextStyle(
            fontFamily: "Poly_Regular",
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
