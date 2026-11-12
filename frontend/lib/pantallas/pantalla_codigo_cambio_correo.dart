import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/usuario_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_perfil.dart';

class PantallaCodigoCambioCorreo extends StatefulWidget {
  final String correo;
  final String correoEnmascarado;
  final String tokenVerificacion;

  const PantallaCodigoCambioCorreo({
    super.key,
    required this.correo,
    required this.correoEnmascarado,
    required this.tokenVerificacion,
  });

  @override
  State<PantallaCodigoCambioCorreo> createState() =>
      _PantallaCodigoCambioCorreoState();
}

class _PantallaCodigoCambioCorreoState
    extends State<PantallaCodigoCambioCorreo> {
  final _codigoCtrl = TextEditingController();
  final _usuarioModel = const UsuarioModel();
  bool _verificando = false;
  bool _actualizado = false;

  @override
  void dispose() {
    _codigoCtrl.dispose();
    super.dispose();
  }

  Future<void> _verificar() async {
    final codigo = _codigoCtrl.text.trim();
    if (!RegExp(r'^\d{8}$').hasMatch(codigo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el código de 8 dígitos.')),
      );
      return;
    }

    setState(() => _verificando = true);
    try {
      await _usuarioModel.verificarCambioCorreo(
        tokenVerificacion: widget.tokenVerificacion,
        codigo: codigo,
      );
      if (mounted) setState(() => _actualizado = true);
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _verificando = false);
    }
  }

  void _volverAlPerfil() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const PantallaPerfil()),
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
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                const Text(
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 36, bottom: 24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: _actualizado
                            ? const Color(0xFFE8F9F0)
                            : const Color(0xFFEDF3FF),
                        child: Icon(
                          _actualizado
                              ? Icons.mark_email_read_outlined
                              : Icons.mail_outline_rounded,
                          size: 48,
                          color: _actualizado
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF285FE8),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        _actualizado
                            ? 'Correo actualizado'
                            : 'Verifica tu correo',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17243C),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _actualizado
                            ? 'Tu cuenta ahora usa ${widget.correo}.'
                            : 'Enviamos un código a tu correo actual ${widget.correoEnmascarado}. Ingrésalo para confirmar el cambio a ${widget.correo}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF66758D),
                          height: 1.5,
                        ),
                      ),
                      if (!_actualizado) ...[
                        const SizedBox(height: 28),
                        TextField(
                          controller: _codigoCtrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 8,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                            fontSize: 22,
                            letterSpacing: 8,
                            color: ColoresApp.textoPrincipal,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Código de verificación',
                            counterText: '',
                            filled: true,
                            fillColor: ColoresApp.blanco,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: ColoresApp.bordeInput,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: ColoresApp.bordeInput,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: ColoresApp.primario,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            BotonPrimario(
              texto: _actualizado
                  ? 'Volver al perfil'
                  : _verificando
                  ? 'Verificando…'
                  : 'Confirmar cambio',
              alPresionar: _actualizado
                  ? _volverAlPerfil
                  : _verificando
                  ? null
                  : _verificar,
              cargando: _verificando,
            ),
          ],
        ),
      ),
    );
  }
}
