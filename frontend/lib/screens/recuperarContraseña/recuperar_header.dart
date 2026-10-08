import 'package:flutter/material.dart';
import '../../core/colores.dart';

class RecuperarHeader extends StatelessWidget {
  final double width;
  final double height;

  const RecuperarHeader({
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
          top: height * .105,
          height: height * .145,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colores.azulClaro.withOpacity(.72),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Recuperar\nContraseña',
              style: TextStyle(
                fontFamily: "Poly",
                color: Colores.negro,
                fontSize: 39,
                height: .93,
              ),
            ),
          ),
        ),
        Positioned(
          left: width * .075,
          right: width * .075,
          top: height * .270,
          height: height * .095,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colores.azulSeguridad.withOpacity(.38),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Ingresa tu correo y te enviaremos un enlace\n'
              'para restablecer tu contraseña',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colores.negro,
                fontSize: 14,
                height: 1.25,
              ),
            ),
          ),
        ),
      ],
    );
  }
}