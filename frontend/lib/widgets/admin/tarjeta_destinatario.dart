import 'package:flutter/material.dart';

class TarjetaDestinatario extends StatelessWidget {
  final String nombre;
  final String detalle;
  final bool seleccionado;
  final VoidCallback onTap;

  const TarjetaDestinatario({
    super.key,
    required this.nombre,
    required this.detalle,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inicial = nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFF285FE8)
                : const Color(0xFFE1E8F3),
            width: seleccionado ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: seleccionado
                    ? const Color(0xFF285FE8)
                    : const Color(0xFFE8F0FE),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                inicial,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: seleccionado ? Colors.white : const Color(0xFF285FE8),
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
                    detalle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF66758D),
                    ),
                  ),
                ],
              ),
            ),
            if (seleccionado)
              const Icon(Icons.check_circle, color: Color(0xFF285FE8), size: 22),
          ],
        ),
      ),
    );
  }
}
