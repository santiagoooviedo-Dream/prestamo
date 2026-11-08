import 'package:flutter/material.dart';

import 'tarjeta_blanca_admin.dart';

class DatosPerfilUsuario extends StatelessWidget {
  final String correo;
  final String telefono;
  final String cedula;
  final int prestamosActivos;
  final int solicitudesRealizadas;
  final bool cargando;

  const DatosPerfilUsuario({
    super.key,
    required this.correo,
    required this.telefono,
    required this.cedula,
    required this.prestamosActivos,
    required this.solicitudesRealizadas,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    final prestamosTxt = cargando
        ? '…'
        : '$prestamosActivos activo${prestamosActivos == 1 ? '' : 's'}';
    final solTxt = cargando
        ? '…'
        : '$solicitudesRealizadas realizada${solicitudesRealizadas == 1 ? '' : 's'}';

    return TarjetaBlancaAdmin(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        children: [
          // Correo abajo para que no se parta feo
          FilaDatoAdmin(
            etiqueta: 'Correo',
            valor: correo.isEmpty ? '—' : correo,
            valorAbajo: true,
          ),
          FilaDatoAdmin(
            etiqueta: 'Teléfono',
            valor: telefono.isEmpty ? '—' : telefono,
          ),
          FilaDatoAdmin(
            etiqueta: 'Cédula',
            valor: cedula.isEmpty ? '—' : cedula,
          ),
          FilaDatoAdmin(etiqueta: 'Préstamos', valor: prestamosTxt),
          FilaDatoAdmin(
            etiqueta: 'Solicitudes',
            valor: solTxt,
            ultimo: true,
          ),
        ],
      ),
    );
  }
}
