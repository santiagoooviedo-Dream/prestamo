import 'package:flutter/material.dart';

import '../../models/solicitud_admin.dart';
import '../../nucleo/colores_app.dart';

class ItemHistorialAdmin {
  final String titulo;
  final int monto;
  final String cuotaTexto;
  final int numeroCuotas;
  final String estado;
  final String fechaPago;
  final String metodo;
  final String fechaInicio;
  final String fechaFin;
  final DateTime? fechaOrden;

  const ItemHistorialAdmin({
    required this.titulo,
    required this.monto,
    required this.cuotaTexto,
    this.numeroCuotas = 0,
    required this.estado,
    required this.fechaPago,
    required this.metodo,
    this.fechaInicio = '—',
    this.fechaFin = '—',
    this.fechaOrden,
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
          color: ColoresApp.blanco,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ColoresApp.bordeTarjeta),
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
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                ),
                Builder(
                  builder: (_) {
                    final rechazado =
                        item.estado.toLowerCase().contains('rechaz');
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: rechazado
                            ? ColoresApp.errorFondo
                            : ColoresApp.exitoClaro2,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        item.estado,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: rechazado
                              ? ColoresApp.errorRosado
                              : ColoresApp.exitoProfundo,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '\$${SolicitudAdmin.formatoMonto(item.monto)}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: ColoresApp.textoPrincipal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.cuotaTexto,
              style: const TextStyle(fontSize: 13, color: ColoresApp.textoSecundario),
            ),
            if (item.fechaInicio != '—' || item.fechaFin != '—') ...[
              const SizedBox(height: 6),
              Text(
                '${item.fechaInicio}  →  ${item.fechaFin}',
                style: const TextStyle(fontSize: 12, color: ColoresApp.textoMuted2),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
