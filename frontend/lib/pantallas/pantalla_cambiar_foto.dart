import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';

/// Figma: Cambiar foto (PERFIL / FOTO)
class PantallaCambiarFoto extends StatefulWidget {
  const PantallaCambiarFoto({super.key});

  @override
  State<PantallaCambiarFoto> createState() => _PantallaCambiarFotoState();
}

class _PantallaCambiarFotoState extends State<PantallaCambiarFoto> {
  final ImagePicker _selector = ImagePicker();
  XFile? _fotoSeleccionada;
  Uint8List? _vistaPrevia;
  bool _tomadaConCamara = false;
  bool _guardadaEnGaleria = false;
  bool _guardando = false;

  Future<void> _seleccionarFoto(ImageSource origen) async {
    try {
      final foto = await _selector.pickImage(
        source: origen,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (foto == null) return;

      final bytes = await foto.readAsBytes();
      if (!mounted) return;

      setState(() {
        _fotoSeleccionada = foto;
        _vistaPrevia = bytes;
        _tomadaConCamara = origen == ImageSource.camera;
        _guardadaEnGaleria = false;
      });
    } on PlatformException {
      _mostrarMensaje(
        origen == ImageSource.camera
            ? 'No se pudo abrir la cámara. Revisa los permisos del dispositivo.'
            : 'No se pudo abrir la galería. Revisa los permisos del dispositivo.',
      );
    }
  }

  Future<void> _confirmarFoto() async {
    final foto = _fotoSeleccionada;
    if (foto == null || _guardando) return;

    setState(() => _guardando = true);
    try {
      if (_tomadaConCamara &&
          !_guardadaEnGaleria &&
          !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)) {
        if (!await Gal.hasAccess(toAlbum: true)) {
          await Gal.requestAccess(toAlbum: true);
        }
        if (!await Gal.hasAccess(toAlbum: true)) {
          _mostrarMensaje(
            'Se necesita permiso para guardar la foto en la galería.',
          );
          return;
        }

        await Gal.putImage(foto.path, album: 'Prestamo Amigo');
        _guardadaEnGaleria = true;
      }

      await ApiService.cambiarFoto(foto);
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (error) {
      _mostrarMensaje(
        _guardadaEnGaleria
            ? '${error.mensaje} La foto sí quedó guardada en la galería.'
            : error.mensaje,
      );
    } on GalException catch (error) {
      _mostrarMensaje(error.type.message);
    } on PlatformException {
      _mostrarMensaje('No se pudo completar la operación con la foto.');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
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
                clipBehavior: Clip.antiAlias,
                child: _vistaPrevia == null
                    ? const Icon(
                        Icons.photo_camera_rounded,
                        size: 56,
                        color: Color(0xFF285FE8),
                      )
                    : Image.memory(_vistaPrevia!, fit: BoxFit.cover),
              ),
            ),
            if (_tomadaConCamara) ...[
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Al tomarla, guardaremos una copia en la galería del teléfono.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF66758D)),
                ),
              ),
            ],
            const Spacer(flex: 2),
            _OpcionFoto(
              icono: Icons.photo_camera_outlined,
              titulo: 'Tomar foto',
              subtitulo: 'Usar la cámara',
              onTap: _guardando
                  ? null
                  : () => _seleccionarFoto(ImageSource.camera),
            ),
            const SizedBox(height: 12),
            _OpcionFoto(
              icono: Icons.image_outlined,
              titulo: 'Seleccionar desde galería',
              subtitulo: 'Elegir una foto guardada',
              onTap: _guardando
                  ? null
                  : () => _seleccionarFoto(ImageSource.gallery),
            ),
            const Spacer(flex: 1),
            BotonPrimario(
              texto: _guardando ? 'Guardando...' : 'Confirmar',
              alPresionar: _fotoSeleccionada == null || _guardando
                  ? null
                  : _confirmarFoto,
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
  final VoidCallback? onTap;

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
      child: Opacity(
        opacity: onTap == null ? 0.55 : 1,
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
      ),
    );
  }
}
