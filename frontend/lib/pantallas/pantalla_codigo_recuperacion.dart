import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/emblema_circular.dart';
import 'pantalla_nueva_contrasena.dart';

/// Figma: Código de recuperación (1:2195)
/// Flujo: Recuperar acceso → esta → Nueva contraseña
class PantallaCodigoRecuperacion extends StatefulWidget {
  final String correo;
  const PantallaCodigoRecuperacion({super.key, this.correo = 'correo@ejemplo.com'});

  @override
  State<PantallaCodigoRecuperacion> createState() =>
      _PantallaCodigoRecuperacionState();
}

class _PantallaCodigoRecuperacionState extends State<PantallaCodigoRecuperacion> {
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focus = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int i, String v) {
    if (v.isNotEmpty && i < 5) {
      _focus[i + 1].requestFocus();
    }
    if (v.isEmpty && i > 0) {
      _focus[i - 1].requestFocus();
    }
    setState(() {});
  }

  bool get _completo => _ctrls.every((c) => c.text.isNotEmpty);

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
              'Sigue las instrucciones del enlace para restablecer tu contraseña.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D), height: 1.5),
            ),
            const SizedBox(height: 28),
            const Center(
              child: EmblemaCircular(
                icono: Icons.mark_email_read_outlined,
                tamano: 112,
                tamanoIcono: 44,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEAF1FF), Color(0xFFF2F6FF)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD9E5FA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¡Enlace enviado a:',
                    style: TextStyle(fontSize: 13, color: Color(0xFF536887)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.correo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF285FE8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Código de 6 dígitos',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(6, (i) {
                final filled = _ctrls[i].text.isNotEmpty;
                final focused = _focus[i].hasFocus;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < 5 ? 8 : 0),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: focused || filled
                            ? const Color(0xFF285FE8)
                            : const Color(0xFFE3E9F2),
                        width: focused ? 2 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _ctrls[i],
                      focusNode: _focus[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xFF285FE8),
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: '–',
                        hintStyle: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF94A0B3),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) => _onChanged(i, v),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            const AvisoSeguridad(
              texto:
                  '¿No lo ves? Revisa tu carpeta de spam o espera unos minutos y vuelve a intentarlo.',
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Reenviar enlace',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF285FE8),
                ),
              ),
            ),
            const Spacer(),
            BotonPrimario(
              texto: 'Continuar',
              alPresionar: _completo
                  ? () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaNuevaContrasena()),
                  )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
