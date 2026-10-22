import 'package:flutter/material.dart';

import '../models/recuperacion_contrasena_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/emblema_circular.dart';
import '../widgets/recuperacion/campo_codigo_recuperacion.dart';
import '../widgets/recuperacion/tarjeta_correo_recuperacion.dart';
import 'pantalla_nueva_contrasena.dart';

class PantallaCodigoRecuperacion extends StatefulWidget {
  final String correo;

  const PantallaCodigoRecuperacion({super.key, required this.correo});

  @override
  State<PantallaCodigoRecuperacion> createState() =>
      _PantallaCodigoRecuperacionState();
}

class _PantallaCodigoRecuperacionState
    extends State<PantallaCodigoRecuperacion> {
  final _modelo = const RecuperacionContrasenaModel();
  final _ctrls = List.generate(6, (_) => TextEditingController());
  final _focus = List.generate(6, (_) => FocusNode());
  bool _procesando = false;

  String get _codigo => _ctrls.map((controlador) => controlador.text).join();

  @override
  void dispose() {
    for (final controlador in _ctrls) {
      controlador.dispose();
    }
    for (final foco in _focus) {
      foco.dispose();
    }
    super.dispose();
  }

  void _alCambiar(int indice, String valor) {
    if (valor.isNotEmpty && indice < 5) _focus[indice + 1].requestFocus();
    if (valor.isEmpty && indice > 0) _focus[indice - 1].requestFocus();
    setState(() {});
  }

  Future<void> _verificarCodigo() async {
    if (_codigo.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el código de 6 dígitos.')),
      );
      return;
    }

    setState(() => _procesando = true);
    try {
      await _modelo.verificarCodigo(widget.correo, _codigo);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PantallaNuevaContrasena(correo: widget.correo, codigo: _codigo),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _procesando = false);
    }
  }

  Future<void> _reenviarCodigo() async {
    setState(() => _procesando = true);
    try {
      await _modelo.solicitarCodigo(widget.correo);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enviamos un nuevo código a tu correo.')),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _procesando = false);
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
                  'VERIFICACIÓN',
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
              'Revisa tu correo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
                height: 1.18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingresa el código que enviamos para restablecer tu contraseña.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: EmblemaCircular(
                icono: Icons.mark_email_read_outlined,
                tamano: 100,
                tamanoIcono: 40,
              ),
            ),
            const SizedBox(height: 20),
            TarjetaCorreoRecuperacion(correo: widget.correo),
            const SizedBox(height: 20),
            CampoCodigoRecuperacion(
              controladores: _ctrls,
              focos: _focus,
              alCambiar: _alCambiar,
            ),
            const SizedBox(height: 16),
            const AvisoSeguridad(
              texto: '¿No lo ves? Revisa spam o espera unos minutos y vuelve a intentarlo.',
            ),
            TextButton(
              onPressed: _procesando ? null : _reenviarCodigo,
              child: const Text('Reenviar código'),
            ),
            const Spacer(),
            BotonPrimario(
              texto: _procesando ? 'Verificando…' : 'Continuar',
              alPresionar: _procesando ? null : _verificarCodigo,
            ),
          ],
        ),
      ),
    );
  }
}
