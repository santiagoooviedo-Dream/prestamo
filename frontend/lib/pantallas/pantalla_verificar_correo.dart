import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_iniciar_sesion.dart';

class PantallaVerificarCorreo extends StatefulWidget {
  const PantallaVerificarCorreo({super.key});

  @override
  State<PantallaVerificarCorreo> createState() =>
      _PantallaVerificarCorreoState();
}

class _PantallaVerificarCorreoState extends State<PantallaVerificarCorreo> {
  final List<TextEditingController> _digitos =
      List.generate(6, (_) => TextEditingController());
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

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
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
              'Sigue las instrucciones del enlace para crear tu\ncuenta.',
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
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Text(
                    '¡Enlace enviado a:',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF66758D),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'correo@ejemplo.com',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF285FE8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Código de 6 dígitos',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 46,
                  height: 52,
                  child: TextField(
                    controller: _digitos[i],
                    focusNode: _focos[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFD5DFEF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFD5DFEF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF285FE8),
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5) {
                        _focos[i + 1].requestFocus();
                      }
                      if (v.isEmpty && i > 0) {
                        _focos[i - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, size: 18, color: Color(0xFF285FE8)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '¿No lo ves? Revisa tu carpeta de spam o espera unos minutos y vuelve a intentarlo.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5B7AA8),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  'Reenviar enlace',
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
              texto: 'Continuar',
              alPresionar: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PantallaIniciarSesion()),
                  (route) => route.isFirst,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
