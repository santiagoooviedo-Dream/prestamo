import 'package:flutter/material.dart';

import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import 'pantalla_inicio.dart';

class PantallaSolicitudEnviada extends StatelessWidget {
  final String? idSolicitud;
  final bool correoEnviado;
  final bool notificacionCreada;

  const PantallaSolicitudEnviada({
    super.key,
    this.idSolicitud,
    this.correoEnviado = true,
    this.notificacionCreada = true,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 20 + bottom),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TP / Préstamos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF285FE8),
                  ),
                ),
                Text(
                  'SOLICITUD / ENVIADA',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F9F0),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD1FAE5), width: 8),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 48,
                color: Color(0xFF22C55E),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              '¡Solicitud enviada!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Solicitud${idSolicitud == null ? '' : ' #$idSolicitud'} registrada. Te avisaremos por correo y en Notificaciones cuando tengamos una respuesta.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const AvisoSeguridad(
              texto: 'Mantente atento a tu correo y a las notificaciones de la aplicación.',
            ),
            if (!correoEnviado) ...[
              const SizedBox(height: 8),
              const Text(
                'La solicitud quedó registrada, pero no pudimos enviar el correo de confirmación.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
              ),
            ],
            if (!notificacionCreada) ...[
              const SizedBox(height: 8),
              const Text(
                'La solicitud quedó registrada, pero no se pudo crear la notificación dentro de la aplicación.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
              ),
            ],
            const Spacer(flex: 3),
            BotonPrimario(
              texto: 'Volver',
              alPresionar: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PantallaInicio()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
