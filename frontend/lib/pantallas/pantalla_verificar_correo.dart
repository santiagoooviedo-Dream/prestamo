import 'package:flutter/material.dart';

import '../nucleo/colores_app.dart';
import '../models/registro_model.dart';
import '../nucleo/api_service.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/acceso/seccion_verificacion_registro.dart';
import 'pantalla_iniciar_sesion.dart';

class PantallaVerificarCorreo extends StatefulWidget {
  final String correo;

  const PantallaVerificarCorreo({super.key, required this.correo});

  @override
  State<PantallaVerificarCorreo> createState() =>
      _PantallaVerificarCorreoState();
}

class _PantallaVerificarCorreoState extends State<PantallaVerificarCorreo> {
  final _registroModel = const RegistroModel();
  bool _verificando = false;
  bool _reenviando = false;
  final List<TextEditingController> _digitos = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focos = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _digitos) {
      c.dispose();
    }
    for (final f in _focos) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _verificar() async {
    final codigo = _digitos.map((digito) => digito.text).join();
    if (codigo.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el código de 6 dígitos.')),
      );
      return;
    }
    setState(() => _verificando = true);
    try {
      await _registroModel.verificar(widget.correo, codigo);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta verificada. Ya puedes iniciar sesión.'),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PantallaIniciarSesion()),
        (route) => route.isFirst,
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _verificando = false);
    }
  }

  Future<void> _reenviarCodigo() async {
    setState(() => _reenviando = true);
    try {
      await _registroModel.reenviarCodigo(widget.correo);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enviamos un nuevo código a tu correo.')),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _reenviando = false);
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
                const Text(
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
            const SizedBox(height: 28),
            const Text(
              'Revisa tu correo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingresa el código que enviamos a tu correo para verificar tu cuenta.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 36),
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F0FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mail_outline_rounded,
                  size: 40,
                  color: Color(0xFF285FE8),
                ),
              ),
            ),
            SeccionVerificacionRegistro(
              correo: widget.correo,
              digitos: _digitos,
              focos: _focos,
            ),
            const Spacer(),
            Center(
              child: GestureDetector(
                onTap: _reenviando ? null : _reenviarCodigo,
                child: const Text(
                  'Reenviar código',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF285FE8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            BotonPrimario(
              texto: _verificando ? 'Verificando…' : 'Verificar cuenta',
              alPresionar: _verificando ? () {} : _verificar,
            ),
          ],
        ),
      ),
    );
  }
}
