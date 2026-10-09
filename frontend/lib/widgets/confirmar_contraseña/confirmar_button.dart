import 'package:flutter/material.dart';
import '../../core/colores.dart';

class ConfirmarButton extends StatelessWidget {
  final double width;
  final double height;

  const ConfirmarButton({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.074,
      right: width * 0.074,
      top: height * 0.761,
      height: height * 0.071,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colores.azulSecundario,
          foregroundColor: Colores.blanco,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          'Continuar',
          style: TextStyle(
            fontFamily: "Poly_Regular",
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
