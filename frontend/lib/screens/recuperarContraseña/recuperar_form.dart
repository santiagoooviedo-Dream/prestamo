import 'package:flutter/material.dart';
import '../../core/colores.dart';

class RecuperarForm extends StatelessWidget {
  final double width;
  final double height;

  const RecuperarForm({
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
          top: height * .390,
          height: height * .075,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colores.negro,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colores.grisMedio,
              hintText: 'Correo',
              hintStyle: const TextStyle(
                color: Colores.negro,
                fontSize: 16,
              ),
              prefixIcon: const Icon(
                Icons.mail_outline,
                color: Colores.azul,
                size: 23,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Positioned(
          left: width * .075,
          right: width * .075,
          top: height * .505,
          height: height * .075,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colores.azulSecundario,
              foregroundColor: Colores.blanco,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Enviar enlace',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}