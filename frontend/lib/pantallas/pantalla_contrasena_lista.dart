import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_iniciar_sesion.dart';

class PantallaContrasenaLista extends StatelessWidget {
  const PantallaContrasenaLista({super.key});

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
                  'RECUPERACIÓN / 2 DE 2',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Barra completa
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 1,
                minHeight: 4,
                backgroundColor: ColoresApp.bordeSuave,
                valueColor: AlwaysStoppedAnimation(ColoresApp.primario),
              ),
            ),
            const Spacer(flex: 2),
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: ColoresApp.exitoClaro,
                shape: BoxShape.circle,
                border: Border.all(color: ColoresApp.exitoFondo, width: 8),
              ),
              child: const Icon(
                Icons.verified_user_outlined,
                size: 44,
                color: ColoresApp.exito,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              '¡Todo listo!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: ColoresApp.textoPrincipal,
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
                  color: ColoresApp.textoSecundario,
                  height: 1.45,
                ),
              ),
            ),
            const Spacer(flex: 3),
            BotonPrimario(
              texto: 'Ir a iniciar sesión',
              alPresionar: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PantallaIniciarSesion(),
                  ),
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
