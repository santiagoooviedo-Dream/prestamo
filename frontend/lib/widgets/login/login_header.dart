import 'package:flutter/material.dart';
import '../../core/colores.dart';

class LoginHeader extends StatelessWidget {
  final double width;
  final double height;

  const LoginHeader({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: width * .075,
          right: width * .075,
          top: height * .115,
          height: height * .138,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 32),
            decoration: BoxDecoration(
              color: Colores.azulClaro.withOpacity(.72),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Iniciar\nSesion',
              style: TextStyle(
                fontFamily: "Poly",
                color: Colores.negro,
                fontSize: 38,
                height: .91,
              ),
            ),
          ),
        ),

        Positioned(
          left: width * .075,
          right: width * .075,
          top: height * .275,
          height: height * .087,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colores.azulSeguridad.withOpacity(.38),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Ingresa tu cedula y contraseña',
              style: TextStyle(
                fontFamily: "Poly_Regular",
                color: Colores.negro,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}