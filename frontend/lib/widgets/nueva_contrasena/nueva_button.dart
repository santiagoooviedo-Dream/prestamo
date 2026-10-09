import 'package:flutter/material.dart';
import '../../core/colores.dart';

class NuevaButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onPressed;
  final bool isLoading;

  const NuevaButton({
    super.key,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.074,
      right: width * 0.074,
      top: height * 0.761,
      height: height * 0.071,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colores.azulSecundario,
          foregroundColor: Colores.blanco,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colores.blanco,
                  strokeWidth: 2,
                ),
              )
            : const Text(
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
