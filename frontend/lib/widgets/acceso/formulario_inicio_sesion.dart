
import 'package:flutter/material.dart';

import '../../nucleo/colores_app.dart';
import '../comunes/boton_primario.dart';
import '../comunes/boton_volver.dart';
import '../comunes/campo_texto.dart';
import '../comunes/emblema_circular.dart';

class FormularioInicioSesion extends StatelessWidget {
  final TextEditingController cedulaCtrl;
  final TextEditingController claveCtrl;
  final bool ocultar;
  final bool cargando;
  final VoidCallback alAlternarVisibilidad;
  final VoidCallback alIniciar;
  final VoidCallback alRecuperar;
  final VoidCallback alRegistrar;

  const FormularioInicioSesion({
    super.key,
    required this.cedulaCtrl,
    required this.claveCtrl,
    required this.ocultar,
    required this.cargando,
    required this.alAlternarVisibilidad,
    required this.alIniciar,
    required this.alRecuperar,
    required this.alRegistrar,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: top - 20,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFE4EDFF)
                    .withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              24,
              top + 6,
              24,
              24 + bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BotonVolver(
                      alPresionar: () => Navigator.pop(context),
                    ),
                    Text(
                      'ACCESO',
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
                  'Inicia sesion',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17243C),
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa tu cédula y contraseña para iniciar sesión.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF66758D),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: EmblemaCircular(
                    icono: Icons.lock_outline_rounded,
                    tamano: 140,
                    tamanoIcono: 44,
                  ),
                ),
                const SizedBox(height: 24),
                CampoTexto(
                  etiqueta: 'Cédula',
                  pista: 'Ingresa tu cédula',
                  controlador: cedulaCtrl,
                  tipoTeclado: TextInputType.number,
                  iconoIzquierdo: const Icon(
                    Icons.badge_outlined,
                    size: 20,
                    color: ColoresApp.textoSuave,
                  ),
                ),
                const SizedBox(height: 14),
                CampoTexto(
                  etiqueta: 'Contraseña',
                  pista: 'Ingresa tu contraseña',
                  controlador: claveCtrl,
                  ocultarTexto: ocultar,
                  iconoIzquierdo: const Icon(
                    Icons.lock_outline_rounded,
                    size: 20,
                    color: ColoresApp.textoSuave,
                  ),
                  iconoDerecho: IconButton(
                    onPressed: alAlternarVisibilidad,
                    icon: Icon(
                      ocultar
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: ColoresApp.textoSuave,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: alRecuperar,
                  child: const Text(
                    'Recuperar contraseña',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF285FE8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BotonPrimario(
                  texto: cargando
                      ? 'Conectando…'
                      : 'Iniciar sesión',
                  alPresionar: cargando ? null : alIniciar,
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF66758D),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Center(
                  child: GestureDetector(
                    onTap: alRegistrar,
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF285FE8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
