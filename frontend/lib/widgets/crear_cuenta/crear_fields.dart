import 'package:flutter/material.dart';
import '../../core/colores.dart';

class CrearFields extends StatelessWidget {
  final double width;
  final double height;

  const CrearFields({
    super.key,
    required this.width,
    required this.height,
  });

  Widget _campo({
    required String hint,
    required IconData icon,
    TextInputType tipo = TextInputType.text,
    bool ocultar = false,
    String? helper,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          keyboardType: tipo,
          obscureText: ocultar,
          style: const TextStyle(
            color: Colores.negro,
            fontSize: 14,
            fontFamily: "Poly_Regular",
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colores.blanco.withOpacity(0.85),
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colores.grisOscuro,
              fontSize: 14,
              fontFamily: "Poly_Regular",
            ),
            prefixIcon: Icon(icon, color: Colores.azul, size: 20),
            suffixIcon: ocultar
                ? const Icon(Icons.visibility_outlined,
                    color: Colores.grisOscuro, size: 20)
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (helper != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 2),
            child: Text(
              helper,
              style: const TextStyle(
                fontFamily: "Poly_Regular",
                color: Colores.grisOscuro,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * 0.07,
      right: width * 0.07,
      top: height * 0.25,
      child: Column(
        children: [
          _campo(hint: 'Cedula', icon: Icons.badge_outlined, tipo: TextInputType.number),
          SizedBox(height: height * 0.018),
          _campo(hint: 'Nombres', icon: Icons.person_outline),
          SizedBox(height: height * 0.018),
          _campo(hint: 'Apellidos', icon: Icons.person_outline),
          SizedBox(height: height * 0.018),
          _campo(hint: 'Correo', icon: Icons.mail_outline, tipo: TextInputType.emailAddress),
          SizedBox(height: height * 0.018),
          _campo(hint: 'Telefono', icon: Icons.phone_outlined, tipo: TextInputType.phone),
          SizedBox(height: height * 0.018),
          _campo(
            hint: 'Contraseña',
            icon: Icons.lock_outline,
            ocultar: true,
            helper: 'Minimo 8 caracteres',
          ),
        ],
      ),
    );
  }
}
