import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';

/// Figma: Cambiar contraseña (PERFIL / SEGURIDAD) — pantalla dedicada
class PantallaCambiarContrasenaPerfil extends StatefulWidget {
  const PantallaCambiarContrasenaPerfil({super.key});

  @override
  State<PantallaCambiarContrasenaPerfil> createState() =>
      _PantallaCambiarContrasenaPerfilState();
}

class _PantallaCambiarContrasenaPerfilState
    extends State<PantallaCambiarContrasenaPerfil> {
  final _actualCtrl = TextEditingController();
  final _nuevaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  bool _ocultarActual = true;
  bool _ocultarNueva = true;
  bool _ocultarConfirmar = true;

  @override
  void dispose() {
    _actualCtrl.dispose();
    _nuevaCtrl.dispose();
    _confirmarCtrl.dispose();
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
                Text(
                  'PERFIL / SEGURIDAD',
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
              'Cambiar contraseña',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
                height: 1.18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Por tu seguridad, elige una contraseña fuerte que no hayas usado antes.',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CampoTexto(
                      etiqueta: 'Contraseña actual',
                      pista: 'Tu contraseña actual',
                      controlador: _actualCtrl,
                      ocultarTexto: _ocultarActual,
                      iconoIzquierdo: const Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                      iconoDerecho: IconButton(
                        onPressed: () =>
                            setState(() => _ocultarActual = !_ocultarActual),
                        icon: Icon(
                          _ocultarActual
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: ColoresApp.textoSuave,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CampoTexto(
                      etiqueta: 'Contraseña nueva',
                      pista: 'Crea una contraseña',
                      controlador: _nuevaCtrl,
                      ocultarTexto: _ocultarNueva,
                      iconoIzquierdo: const Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                      iconoDerecho: IconButton(
                        onPressed: () =>
                            setState(() => _ocultarNueva = !_ocultarNueva),
                        icon: Icon(
                          _ocultarNueva
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: ColoresApp.textoSuave,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CampoTexto(
                      etiqueta: 'Confirmar contraseña',
                      pista: 'Repite la nueva contraseña',
                      controlador: _confirmarCtrl,
                      ocultarTexto: _ocultarConfirmar,
                      iconoIzquierdo: const Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: Color(0xFF22C55E),
                      ),
                      iconoDerecho: IconButton(
                        onPressed: () => setState(
                            () => _ocultarConfirmar = !_ocultarConfirmar),
                        icon: Icon(
                          _ocultarConfirmar
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: ColoresApp.textoSuave,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Requisitos
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF3FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD6E4FF)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tu contraseña debe tener:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF17243C),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '• Mínimo 8 caracteres  • Mayúsculas y números\n• Un símbolo especial',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF66758D),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
