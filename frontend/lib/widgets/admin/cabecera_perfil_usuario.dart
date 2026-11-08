import 'package:flutter/material.dart';

class CabeceraPerfilUsuario extends StatelessWidget {
  final String nombre;
  final String apellidos;
  final String fechaRegistro;

  const CabeceraPerfilUsuario({
    super.key,
    required this.nombre,
    required this.apellidos,
    required this.fechaRegistro,
  });

  String get _iniciales {
    final a = nombre.isNotEmpty ? nombre[0] : '';
    final b = apellidos.isNotEmpty ? apellidos[0] : '';
    return ('$a$b').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F0FE),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            _iniciales,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF285FE8),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          nombre,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF17243C),
          ),
        ),
        Text(
          apellidos,
          style: const TextStyle(fontSize: 15, color: Color(0xFF66758D)),
        ),
        if (fechaRegistro.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Registro: $fechaRegistro',
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A0B3)),
          ),
        ],
      ],
    );
  }
}
