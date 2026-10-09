import 'package:flutter/material.dart';
import '../../core/colores.dart';

class CrearFooter extends StatelessWidget {
  final double width;
  final double height;

  const CrearFooter({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Checkbox + términos
        Positioned(
          left: width * 0.09,
          top: height * 0.72,
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  border: Border.all(color: Colores.azul, width: 1.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Acepto los Terminos y condiciones',
                style: TextStyle(
                  fontFamily: "Poly_Regular",
                  color: Colores.negro,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        // Botón Crear cuenta
        Positioned(
          left: width * 0.07,
          right: width * 0.07,
          top: height * 0.78,
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
              'Crear cuenta',
              style: TextStyle(
                fontFamily: "Poly_Regular",
                fontSize: 16,
              ),
            ),
          ),
        ),

        // Ya tienes cuenta
        Positioned(
          left: 0,
          right: 0,
          top: height * 0.875,
          child: const Text.rich(
            TextSpan(
              style: TextStyle(
                fontFamily: "Poly_Regular",
                fontSize: 14,
                color: Colores.negro,
              ),
              children: [
                TextSpan(text: '¿Ya tienes cuenta? '),
                TextSpan(
                  text: 'Iniciar sesion',
                  style: TextStyle(
                    color: Colores.azul,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
