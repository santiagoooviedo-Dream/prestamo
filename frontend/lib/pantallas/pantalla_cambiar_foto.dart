import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';

/// Figma: Cambiar foto (PERFIL / FOTO)
class PantallaCambiarFoto extends StatelessWidget {
  const PantallaCambiarFoto({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 20 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'PERFIL / FOTO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              'Tu foto de perfil',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
                height: 1.18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Elige cómo quieres agregar tu foto.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.5,
              ),
            ),
            const Spacer(flex: 2),
            // Cámara grande centrada
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF3FF),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD6E4FF),
                    width: 3,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  size: 56,
                  color: Color(0xFF285FE8),
                ),
              ),
            ),
            const Spacer(flex: 2),
            _OpcionFoto(
              icono: Icons.photo_camera_outlined,
              titulo: 'Tomar foto',
              subtitulo: 'Usar la cámara',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _OpcionFoto(
              icono: Icons.image_outlined,
              titulo: 'Seleccionar desde galería',
              subtitulo: 'Elegir una foto guardada',
              onTap: () {},
            ),
            const Spacer(flex: 1),
            BotonPrimario(
              texto: 'Confirmar',
              alPresionar: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcionFoto extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _OpcionFoto({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE1E8F3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D17243C),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, color: const Color(0xFF285FE8), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
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
            const Icon(Icons.chevron_right, color: Color(0xFF94A0B3)),
          ],
        ),
      ),
    );
  }
}
