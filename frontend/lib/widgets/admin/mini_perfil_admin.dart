import 'package:flutter/material.dart';

class MiniPerfilAdmin extends StatelessWidget {
  final String nombre;
  final String apellidos;

  const MiniPerfilAdmin({
    super.key,
    required this.nombre,
    required this.apellidos,
  });

  String get _iniciales {
    final a = nombre.isNotEmpty ? nombre[0] : '';
    final b = apellidos.isNotEmpty ? apellidos[0] : '';
    return ('$a$b').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F0FE),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _iniciales,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF285FE8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF17243C),
                  ),
                ),
                Text(
                  apellidos,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF66758D)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
