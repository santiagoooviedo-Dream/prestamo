import 'package:flutter/material.dart';

import '../models/usuario_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';
import 'pantalla_codigo_cambio_correo.dart';

class PantallaCambiarCorreo extends StatefulWidget {
  const PantallaCambiarCorreo({super.key});

  @override
  State<PantallaCambiarCorreo> createState() => _PantallaCambiarCorreoState();
}

class _PantallaCambiarCorreoState extends State<PantallaCambiarCorreo> {
  final _nuevoCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  final _usuarioModel = const UsuarioModel();
  bool _guardando = false;

  @override
  void dispose() {
    _nuevoCtrl.dispose();
    _confirmarCtrl.dispose();
    _contrasenaCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final nuevoCorreo = _nuevoCtrl.text.trim();
    if (nuevoCorreo.isEmpty ||
        nuevoCorreo != _confirmarCtrl.text.trim() ||
        _contrasenaCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Confirma el nuevo correo e ingresa tu contraseña actual.',
          ),
        ),
      );
      return;
    }

    setState(() => _guardando = true);
    try {
      await _usuarioModel.cambiarCorreo(
        nuevoCorreo: nuevoCorreo,
        contrasena: _contrasenaCtrl.text,
      );
      if (!mounted) return;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PantallaCodigoCambioCorreo(correo: nuevoCorreo),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
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
            const SizedBox(height: 24),
            const Text(
              'Cambiar correo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Confirma el nuevo correo con tu contraseña actual.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CampoTexto(
                      etiqueta: 'Correo nuevo',
                      pista: 'Tu nuevo correo',
                      controlador: _nuevoCtrl,
                      tipoTeclado: TextInputType.emailAddress,
                      iconoIzquierdo: const Icon(
                        Icons.mail_outline_rounded,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CampoTexto(
                      etiqueta: 'Confirmar nuevo correo',
                      pista: 'Repite tu nuevo correo',
                      controlador: _confirmarCtrl,
                      tipoTeclado: TextInputType.emailAddress,
                      iconoIzquierdo: const Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CampoTexto(
                      etiqueta: 'Contraseña actual',
                      pista: 'Contraseña actual',
                      controlador: _contrasenaCtrl,
                      ocultarTexto: true,
                      iconoIzquierdo: const Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const AvisoSeguridad(
                      texto: 'El backend actualizará tu correo después de validar tu contraseña.',
                    ),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: _guardando ? 'Actualizando…' : 'Guardar correo',
              alPresionar: _guardando ? null : _guardar,
            ),
          ],
        ),
      ),
    );
  }
}
