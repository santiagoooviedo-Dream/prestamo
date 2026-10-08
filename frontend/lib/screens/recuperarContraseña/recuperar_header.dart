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
          top: height * .115,
          height: height * .138,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colores.azulClaro.withOpacity(.72),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Recuperar\nContraseña',
              style: TextStyle(
                color: Colores.negro,
                fontSize: 37,
                height: .93,
              ),
            ),
          ),
        ),

        Positioned(
          left: width * .075,
          right: width * .075,
          top: height * .275,
          height: height * .085,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colores.azulSeguridad.withOpacity(.38),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Ingresa tu correo y te enviaremos un enlace\n'
              'para restablecer tu contraseña',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colores.negro,
                fontSize: 13,
                height: 1.25,
              ),
            ),
          ),
        ),
      ],
    );
  }
}