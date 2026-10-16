import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';

class PantallaContrasenaLista extends StatelessWidget {
  const PantallaContrasenaLista({super.key});

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
            // Cabecera
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'RECUPERACIÓN / 3 DE 3',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),

            // Línea continua (como los otros pasos)
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: const LinearProgressIndicator(
                value: 1.0,
                minHeight: 4,
                backgroundColor: Color(0xFFD6E4FF),
                valueColor: AlwaysStoppedAnimation(Color(0xFF285FE8)),
              ),
            ),

            const Spacer(flex: 2),

            // Emblema escudo
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F9F0),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFD1FAE5),
                  width: 8,
                ),
              ),
              child: const Icon(
                Icons.verified_user_outlined,
                size: 44,
                color: Color(0xFF22C55E),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              '¡Todo listo!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Tu contraseña ha sido actualizada. Ahora puedes iniciar sesión con tu nueva contraseña.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF66758D),
                  height: 1.45,
                ),
              ),
            ),

            const Spacer(flex: 3),

            BotonPrimario(
              texto: 'Ir a iniciar sesión',
              alPresionar: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/iniciar-sesion',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
