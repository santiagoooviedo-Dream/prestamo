import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_bienvenida.dart';

/// Figma: Cerrar sesión (MI CUENTA / SALIR)
class PantallaCerrarSesion extends StatelessWidget {
  const PantallaCerrarSesion({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 24 + bottom),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'MI CUENTA / SALIR',
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
              child: const Icon(
                Icons.logout_rounded,
                size: 44,
                color: Color(0xFF285FE8),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              '¿Quieres cerrar sesión?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Por tu seguridad, te recomendamos cerrar sesión en este dispositivo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF66758D),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _Opcion(
              icono: Icons.person_outline_rounded,
              titulo: 'No, volver',
              subtitulo: 'Quedarme en la cuenta',
              peligro: false,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
            _Opcion(
              icono: Icons.logout_rounded,
              titulo: 'Sí, salir',
              subtitulo: 'Cerrar mi sesión',
              peligro: true,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PantallaBienvenida()),
                  (_) => false,
                );
              },
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final bool peligro;
  final VoidCallback onTap;

  const _Opcion({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.peligro,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = peligro ? const Color(0xFFBC4351) : const Color(0xFF17243C);
    final bg = peligro ? const Color(0xFFFFF0F2) : const Color(0xFFEDF3FF);
    final ic = peligro ? const Color(0xFFBC4351) : const Color(0xFF285FE8);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE1E8F3)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, size: 22, color: ic),
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
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF66758D),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
