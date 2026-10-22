import 'package:flutter/material.dart';

class RequisitoContrasena extends StatelessWidget {
  final String texto;
  final bool ok;

  const RequisitoContrasena({super.key, required this.texto, required this.ok});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: ok ? const Color(0xFF22C55E) : const Color(0xFF94A0B3),
          ),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(
              fontSize: 13,
              color: ok ? const Color(0xFF17243C) : const Color(0xFF66758D),
            ),
          ),
        ],
      ),
    );
  }
}
