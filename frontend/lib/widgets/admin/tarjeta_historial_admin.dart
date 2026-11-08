import 'package:flutter/material.dart';

import '../../models/solicitud_admin.dart';

class ItemHistorialAdmin {
  final String titulo;
  final int monto;
  final String cuotaTexto;
  final String estado;
  final String fechaPago;
  final String metodo;

  const ItemHistorialAdmin({
    required this.titulo,
    required this.monto,
    required this.cuotaTexto,
    required this.estado,
    required this.fechaPago,
    required this.metodo,
  });
}

class TarjetaHistorialAdmin extends StatelessWidget {
  final ItemHistorialAdmin item;
  final VoidCallback onTap;

  const TarjetaHistorialAdmin({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE1E8F3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7F0),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    item.estado,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF168261),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '\$${SolicitudAdmin.formatoMonto(item.monto)}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.cuotaTexto,
              style: const TextStyle(fontSize: 13, color: Color(0xFF66758D)),
            ),
          ],
        ),
      ),
    );
  }
}
