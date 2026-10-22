import 'package:flutter/material.dart';

class OpcionMetodo extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool seleccionado;
  final VoidCallback onTap;

  const OpcionMetodo({
    super.key,
    required this.icono,
    required this.titulo,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: seleccionado ? const Color(0xFFEDF3FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFFD5E3FF)
                : const Color(0xFFE1E8F3),
          ),
        ),
        child: Row(
          children: [
            Icon(icono, size: 24, color: const Color(0xFF285FE8)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(fontSize: 16, color: Color(0xFF17243C)),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: seleccionado
                      ? const Color(0xFF285FE8)
                      : const Color(0xFFCCD9F0),
                  width: 2,
                ),
                color: seleccionado ? const Color(0xFF285FE8) : Colors.white,
              ),
              child: seleccionado
                  ? const Icon(Icons.circle, size: 10, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
