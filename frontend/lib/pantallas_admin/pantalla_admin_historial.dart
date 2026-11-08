import 'package:flutter/material.dart';

import '../nucleo/colores_app.dart';
import '../widgets/admin/tarjeta_historial_admin.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_monto_pagado.dart';

/// Figma: Historial de préstamo
class PantallaAdminHistorial extends StatelessWidget {
  final String nombre;
  final String apellidos;

  const PantallaAdminHistorial({
    super.key,
    this.nombre = 'Nombre usuario',
    this.apellidos = 'Apellidos Usuario',
  });

  String get _iniciales {
    final a = nombre.isNotEmpty ? nombre[0] : '';
    final b = apellidos.isNotEmpty ? apellidos[0] : '';
    return ('$a$b').toUpperCase();
  }

  static const _items = [
    ItemHistorialAdmin(
      titulo: 'Préstamo 06 mayo 2026',
      monto: 200000,
      cuotaTexto: 'Cuota 2 de 12',
      estado: 'Completado',
      fechaPago: '20 abril 2026',
      metodo: 'Nequi **** 1234',
    ),
    ItemHistorialAdmin(
      titulo: 'Préstamo 06 mayo 2026',
      monto: 135000,
      cuotaTexto: 'Cuota 1 de 12',
      estado: 'Completado',
      fechaPago: '20 marzo 2026',
      metodo: 'Nequi **** 1234',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(
                  alPresionar: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                ),
                const Text(
                  'HISTORIAL DE PRÉSTAMOS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Historial de préstamo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Revisa el detalle de cada préstamo.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 18),
            _cardUsuario(),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final it = _items[i];
                  return TarjetaHistorialAdmin(
                    item: it,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PantallaAdminMontoPagado(
                            monto: it.monto,
                            tipoPrestamo: it.cuotaTexto,
                            fechaPago: it.fechaPago,
                            metodo: it.metodo,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardUsuario() {
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
