import 'package:flutter/material.dart';

import '../../models/solicitud_admin.dart';
import '../../nucleo/colores_app.dart';

class TarjetaSolicitudAdmin extends StatelessWidget {
  final SolicitudAdmin solicitud;
  final VoidCallback onTap;

  const TarjetaSolicitudAdmin({
    super.key,
    required this.solicitud,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = solicitud;
    final fotoUrl = s.foto?.trim();
    final iniciales = s.nombre.isNotEmpty ? s.nombre[0].toUpperCase() : '?';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColoresApp.blanco,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColoresApp.bordeTarjeta),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: ColoresApp.fondoSeleccionado,
              child: ClipOval(
                child: fotoUrl != null && fotoUrl.isNotEmpty
                    ? Image.network(
                        fotoUrl,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _avatarInicial(iniciales),
                      )
                    : _avatarInicial(iniciales),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${s.nombre} ${s.apellidos}'.trim(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${SolicitudAdmin.formatoMonto(s.monto)} · ${s.cuotas} cuotas',
                    style: const TextStyle(
                      fontSize: 13,
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ColoresApp.advertenciaFondo,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                'Pendiente',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ColoresApp.advertenciaProfundo2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarInicial(String inicial) => Center(
    child: Text(
      inicial,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: ColoresApp.primario,
      ),
    ),
  );
}
