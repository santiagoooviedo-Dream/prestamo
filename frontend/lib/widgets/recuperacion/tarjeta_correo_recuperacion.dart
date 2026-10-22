import 'package:flutter/material.dart';

class TarjetaCorreoRecuperacion extends StatelessWidget {
  final String correo;

  const TarjetaCorreoRecuperacion({super.key, required this.correo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF1FF), Color(0xFFF2F6FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD9E5FA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enviamos un código a:',
            style: TextStyle(fontSize: 13, color: Color(0xFF536887)),
          ),
          const SizedBox(height: 8),
          Text(
            correo,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF285FE8),
            ),
          ),
        ],
      ),
    );
  }
}
