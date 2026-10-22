import 'package:flutter/material.dart';

import '../models/recuperacion_contrasena_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';
import '../widgets/comunes/emblema_circular.dart';
import 'pantalla_codigo_recuperacion.dart';

class PantallaRecuperarAcceso extends StatefulWidget {
  const PantallaRecuperarAcceso({super.key});

  @override
  State<PantallaRecuperarAcceso> createState() =>
      _PantallaRecuperarAccesoState();
}

class _PantallaRecuperarAccesoState extends State<PantallaRecuperarAcceso> {
  final _correoCtrl = TextEditingController();
  final _modelo = const RecuperacionContrasenaModel();
  bool _enviando = false;

  @override
  void dispose() {
    _correoCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviarCodigo() async {
    final correo = _correoCtrl.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(correo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un correo electrónico válido.')),
      );
      return;
    }

    setState(() => _enviando = true);
    try {
      await _modelo.solicitarCodigo(correo);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PantallaCodigoRecuperacion(correo: correo),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: top - 20,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFE4EDFF).withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, top + 6, 24, 20 + bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BotonVolver(alPresionar: () => Navigator.pop(context)),
                    Text(
                      'RECUPERACIÓN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ColoresApp.textoContexto,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recupera tu acceso',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17243C),
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa tu correo y te enviaremos un código para restablecer tu contraseña.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF66758D),
                    height: 1.4,
                  ),
                ),
                const Spacer(flex: 2),
                const Center(
                  child: EmblemaCircular(
                    icono: Icons.key_rounded,
                    tamano: 120,
                    tamanoIcono: 44,
                  ),
                ),
                const Spacer(flex: 2),
                CampoTexto(
                  etiqueta: 'Correo electrónico',
                  pista: 'correo@ejemplo.com',
                  controlador: _correoCtrl,
                  tipoTeclado: TextInputType.emailAddress,
                  iconoIzquierdo: const Icon(
                    Icons.mail_outline_rounded,
                    size: 20,
                    color: ColoresApp.textoSuave,
                  ),
                ),
                const SizedBox(height: 16),
                const AvisoSeguridad(
                  texto: 'Revisa la bandeja de entrada del correo asociado a tu cuenta.',
                ),
                const Spacer(flex: 3),
                BotonPrimario(
                  texto: _enviando ? 'Enviando…' : 'Enviar código',
                  alPresionar: _enviando ? null : _enviarCodigo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
