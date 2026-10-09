import 'package:flutter/material.dart';
import '../../core/colores.dart';

class ListaButton extends StatelessWidget {
  final double width;
  final double height;

  const ListaButton({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.10,
      right: width * 0.10,
      top: height * 0.80,
      height: height * 0.068,
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
          'Ir a iniciar sesion',
          style: TextStyle(
            fontFamily: "Poly_Regular",
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
