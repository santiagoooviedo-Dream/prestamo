import 'package:flutter/material.dart';

import '../models/solicitud_admin.dart';
import '../nucleo/colores_app.dart';
import '../widgets/admin/botones_decision_solicitud.dart';
import '../widgets/admin/contenido_detalle_solicitud.dart';
import '../widgets/comunes/boton_volver.dart';

class PantallaAdminDetalleSolicitud extends StatelessWidget {
  final SolicitudAdmin solicitud;

  const PantallaAdminDetalleSolicitud({
    super.key,
    required this.solicitud,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top + 6, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BotonVolver(
                        alPresionar: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const Text(
                        'ADMINISTRADOR',
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
                    'Préstamo solicitado',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Revisa la información enviada antes de tomar una decisión.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF66758D),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ContenidoDetalleSolicitud(solicitud: solicitud),
                ],
              ),
            ),
          ),
          if (solicitud.pendiente) ...[
            BotonesDecisionSolicitud(solicitud: solicitud),
            SizedBox(height: 12 + bottom),
          ] else
            SizedBox(height: bottom + 8),
        ],
      ),
    );
  }
}
