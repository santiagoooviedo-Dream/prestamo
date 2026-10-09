import 'package:flutter/material.dart';
import '../../core/colores.dart';

class ConfirmarField extends StatelessWidget {
  final double width;
  final double height;

  const ConfirmarField({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.074,
      right: width * 0.074,
      top: height * 0.382,
      height: height * 0.066,
      child: TextField(
        obscureText: true,
        style: const TextStyle(
          color: Colores.negro,
          fontSize: 15,
          fontFamily: "Poly_Regular",
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colores.grisMedio.withOpacity(0.90),
          hintText: 'Confirmar contraseña',
          hintStyle: const TextStyle(
            color: Colores.negro,
            fontSize: 15,
            fontFamily: "Poly_Regular",
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Colores.azul,
            size: 22,
          ),
          suffixIcon: const Icon(
            Icons.visibility_outlined,
            color: Colores.grisOscuro,
            size: 22,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
