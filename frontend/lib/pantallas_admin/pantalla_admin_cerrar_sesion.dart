import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../pantallas/pantalla_bienvenida.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_menu.dart';

class PantallaAdminCerrarSesion extends StatelessWidget {
  const PantallaAdminCerrarSesion({super.key});

  Future<void> _cerrar(BuildContext context) async {
    try {
      await ApiService.cerrarSesion();
    } catch (_) {}
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const PantallaBienvenida()),
      (_) => false,
    );
  }

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
                BotonVolver(
                  alPresionar: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
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
            const Spacer(flex: 2),
            const Icon(Icons.logout_rounded, size: 64, color: Color(0xFF285FE8)),
            const SizedBox(height: 20),
            const Text(
              'Cerrar sesión',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '¿Seguro que deseas salir del panel de administrador?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const Spacer(flex: 2),
            BotonPrimario(
              texto: 'Cerrar sesión',
              alPresionar: () => _cerrar(context),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaAdminMenu()),
                    (_) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF285FE8),
                  side: const BorderSide(color: Color(0xFFD0DBF0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Seguir en la cuenta',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
