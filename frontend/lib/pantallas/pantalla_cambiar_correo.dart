import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';
import 'pantalla_codigo_cambio_correo.dart';

/// Figma: Cambiar correo (PERFIL / CORREO)
/// Secuencia: esta pantalla → código al correo nuevo
class PantallaCambiarCorreo extends StatefulWidget {
  const PantallaCambiarCorreo({super.key});

  @override
  State<PantallaCambiarCorreo> createState() => _PantallaCambiarCorreoState();
}

class _PantallaCambiarCorreoState extends State<PantallaCambiarCorreo> {
  final _actualCtrl = TextEditingController();
  final _nuevoCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();

  @override
  void dispose() {
    _actualCtrl.dispose();
    _nuevoCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  void _continuar() {
    final nuevo = _nuevoCtrl.text.trim();
    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PantallaCodigoCambioCorreo(correo: nuevo.isEmpty ? 'correo@ejemplo.com' : nuevo)),
                );
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
                height: 1.18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingresa tu nuevo correo electrónico.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CampoTexto(
                      etiqueta: 'Correo anterior',
                      pista: 'Tu correo actual',
                      controlador: _actualCtrl,
                      tipoTeclado: TextInputType.emailAddress,
                      iconoIzquierdo: const Icon(
                        Icons.mail_outline_rounded,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 20),
                    const AvisoSeguridad(
                      texto:
                          'Te enviaremos un código a tu nuevo correo para verificarlo.',
                    ),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: 'Confirmar',
              alPresionar: _continuar,
            ),
          ],
        ),
      ),
    );
  }
}
