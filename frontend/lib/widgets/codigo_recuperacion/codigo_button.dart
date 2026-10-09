import 'package:flutter/material.dart';
import '../../core/colores.dart';

class CodigoButton extends StatelessWidget {
  final double width;
  final double height;

  const CodigoButton({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.063,
      right: width * 0.063,
      top: height * 0.626,
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
