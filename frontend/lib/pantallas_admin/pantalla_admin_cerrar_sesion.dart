import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_bienvenida.dart';
import 'pantalla_admin_menu.dart';

class PantallaAdminCerrarSesion extends StatelessWidget {
  const PantallaAdminCerrarSesion({super.key});

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
                  'SALIR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 112,
              height: 112,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 48,
                color: Color(0xFFBC4351),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '¿Cerrar sesión?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Podrás volver a ingresar cuando quieras con tus credenciales de administrador.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            _opcion(
              context,
              Icons.person_outline_rounded,
              'Seguir en la cuenta',
              'Volver al menú principal',
              () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PantallaAdminMenu(),
                  ),
                  (_) => false,
                );
              },
            ),
            const SizedBox(height: 12),
            _opcion(
              context,
              Icons.logout_rounded,
              'Cerrar sesión',
              'Salir del panel administrador',
              () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PantallaAdminBienvenida(),
                  ),
                  (_) => false,
                );
              },
              peligro: true,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _opcion(
    BuildContext context,
    IconData icono,
    String titulo,
    String sub,
    VoidCallback onTap, {
    bool peligro = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: peligro
                ? const Color(0xFFF0D5DB)
                : const Color(0xFFE1E8F3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: peligro
                    ? const Color(0xFFFFF0F2)
                    : const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icono,
                color: peligro
                    ? const Color(0xFFBC4351)
                    : const Color(0xFF285FE8),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: peligro
                          ? const Color(0xFFBC4351)
                          : const Color(0xFF17243C),
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF66758D),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF94A0B3)),
          ],
        ),
      ),
    );
  }
}
