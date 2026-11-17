import 'package:flutter/material.dart';

class CabeceraPerfilUsuario extends StatelessWidget {
  final String nombre;
  final String apellidos;
  final String fechaRegistro;
  final String? foto;

  const CabeceraPerfilUsuario({
    super.key,
    required this.nombre,
    required this.apellidos,
    required this.fechaRegistro,
    this.foto,
  });

  String get _iniciales {
    final a = nombre.isNotEmpty ? nombre[0] : '';
    final b = apellidos.isNotEmpty ? apellidos[0] : '';
    return ('$a$b').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final fotoUrl = foto?.trim();
    return Column(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFFE8F0FE),
            child: ClipOval(
              child: fotoUrl != null && fotoUrl.isNotEmpty
                  ? Image.network(
                      fotoUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _avatarIniciales,
                    )
                  : _avatarIniciales,
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

  Widget get _avatarIniciales => Center(
    child: Text(
      _iniciales.isEmpty ? '?' : _iniciales,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Color(0xFF285FE8),
      ),
    ),
  );
}
