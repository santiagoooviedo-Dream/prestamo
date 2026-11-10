import 'package:flutter/material.dart';

class TarjetaConversacionAdmin extends StatelessWidget {
  final String nombre;
  final String preview;
  final bool esPagoPersonal;
  final bool yaValidado;
  final bool sinRevisar;
  final VoidCallback onTap;

  const TarjetaConversacionAdmin({
    super.key,
    required this.nombre,
    required this.preview,
    required this.esPagoPersonal,
    this.yaValidado = false,
    this.sinRevisar = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color fondo = yaValidado ? const Color(0xFFEAF7F0) : Colors.white;
    final Color borde =
        yaValidado ? const Color(0xFFB7E4C7) : const Color(0xFFE1E8F3);
    final Color iconoFondo =
        yaValidado ? const Color(0xFFD1FAE5) : const Color(0xFFE8F0FE);
    final Color iconoColor =
        yaValidado ? const Color(0xFF168261) : const Color(0xFF285FE8);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borde),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconoFondo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      yaValidado
                          ? Icons.check_circle_outline_rounded
                          : (esPagoPersonal
                              ? Icons.payments_outlined
                              : Icons.chat_bubble_outline_rounded),
                      color: iconoColor,
                      size: 22,
                    ),
                  ),
                  if (sinRevisar && !yaValidado)
                    Positioned(
                      top: -2,
                      left: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF17243C),
                          ),
                        ),
                      ),
                      if (yaValidado)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Verificado',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF168261),
                            ),
                          ),
                        )
                      else if (esPagoPersonal)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Pago personal',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF285FE8),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: yaValidado
                          ? const Color(0xFF168261)
                          : const Color(0xFF66758D),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: yaValidado
                  ? const Color(0xFF168261)
                  : const Color(0xFF94A0B3),
            ),
          ],
        ),
      ),
    );
  }
}
