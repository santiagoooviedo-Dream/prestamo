import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';

class PantallaSolicitudEnviada extends StatelessWidget {
  const PantallaSolicitudEnviada({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
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
            const Text(
              'Pronto te actualizaremos sobre la solicitud de tu préstamo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const AvisoSeguridad(
              texto: '¡Mantente atento a tu correo!',
            ),
            const Spacer(flex: 3),
            BotonPrimario(
              texto: 'Volver al inicio',
              alPresionar: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/inicio',
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
