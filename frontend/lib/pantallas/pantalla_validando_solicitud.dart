import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import 'pantalla_solicitud_enviada.dart';

/// Validando → después de 2s va a Solicitud enviada
class PantallaValidandoSolicitud extends StatefulWidget {
  const PantallaValidandoSolicitud({super.key});

  @override
  State<PantallaValidandoSolicitud> createState() =>
      _PantallaValidandoSolicitudState();
}

class _PantallaValidandoSolicitudState
    extends State<PantallaValidandoSolicitud> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaSolicitudEnviada()),
                  );
    });
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 24 + bottom),
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
                  'SOLICITUD / VALIDACIÓN',
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
                color: const Color(0xFFEDF3FF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD6E4FF), width: 6),
              ),
              child: const Padding(
                padding: EdgeInsets.all(28),
                child: CircularProgressIndicator(
                  strokeWidth: 3.5,
                  color: Color(0xFF285FE8),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Solicitud de préstamo\nrealizada',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Estamos validando tu préstamo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const Spacer(flex: 3),
            const AvisoSeguridad(
              texto: 'Te enviaremos una notificación cuando esté listo.',
            ),
          ],
        ),
      ),
    );
  }
}
