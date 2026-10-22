import 'package:flutter/material.dart';

import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_perfil.dart';

class PantallaCodigoCambioCorreo extends StatelessWidget {
  final String correo;

  const PantallaCodigoCambioCorreo({super.key, required this.correo});

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
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'PERFIL / CORREO',
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
            const CircleAvatar(
              radius: 56,
              backgroundColor: Color(0xFFE8F9F0),
              child: Icon(
                Icons.mark_email_read_outlined,
                size: 48,
                color: Color(0xFF22C55E),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Correo actualizado',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tu cuenta ahora usa $correo.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.5,
              ),
            ),
            const Spacer(flex: 3),
            BotonPrimario(
              texto: 'Volver al perfil',
              alPresionar: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const PantallaPerfil()),
                (route) => route.isFirst,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
