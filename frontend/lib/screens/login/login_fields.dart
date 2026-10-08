import 'package:flutter/material.dart';
import '../../core/colores.dart';

class LoginFields extends StatelessWidget {
  final double width;
  final double height;

  const LoginFields({
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
          top: height * .375,
          height: height * .071,
          child: _campo(
            'Cedula',
            Icons.badge_outlined,
            TextInputType.number,
          ),
        ),

        Positioned(
          left: width * .075,
          right: width * .075,
          top: height * .480,
          height: height * .071,
          child: _campo(
            'Contraseña',
            Icons.lock_outline,
            TextInputType.text,
            ocultar: true,
          ),
        ),

        Positioned(
          left: width * .145,
          top: height * .565,
          child: const Text(
            'Recuperar contraseña',
            style: TextStyle(
              color: Colores.azul,
              fontSize: 10,
            ),
          ),
        ),

        Positioned(
          left: width * .100,
          right: width * .100,
          top: height * .620,
          height: height * .071,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colores.azulSecundario,
              foregroundColor: Colores.blanco,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Confirmar',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _campo(
    String hint,
    IconData icon,
    TextInputType tipo, {
    bool ocultar = false,
  }) {
    return TextField(
      keyboardType: tipo,
      obscureText: ocultar,
      style: const TextStyle(
        color: Colores.negro,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colores.grisMedio,
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colores.negro,
          fontSize: 15,
        ),
        prefixIcon: Icon(
          icon,
          color: Colores.azul,
          size: 17,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}