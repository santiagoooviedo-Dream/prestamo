import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';
import '../widgets/comunes/emblema_circular.dart';
import 'pantalla_registro.dart';
import 'pantalla_inicio.dart';
import 'pantalla_recuperar_acceso.dart';

class PantallaIniciarSesion extends StatefulWidget {
  const PantallaIniciarSesion({super.key});

  @override
  State<PantallaIniciarSesion> createState() => _PantallaIniciarSesionState();
}

class _PantallaIniciarSesionState extends State<PantallaIniciarSesion> {
  final _cedulaCtrl = TextEditingController();
  final _claveCtrl = TextEditingController();
  bool _ocultar = true;

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    _claveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Stack(
        children: [
          // Blob decorativo
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
            padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16 + bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabecera
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BotonVolver(alPresionar: () => Navigator.pop(context)),
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

                // Título
                const Text(
                  'Qué bueno verte\nde nuevo',
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

                // Espacio + emblema más grande (como Figma)
                const Spacer(flex: 2),

                const Center(
                  child: EmblemaCircular(
                    icono: Icons.lock_outline_rounded,
                    tamano: 120,
                    tamanoIcono: 44,
                  ),
                ),

                const Spacer(flex: 2),

                // Campos
                CampoTexto(
                  etiqueta: 'Cédula',
                  pista: 'Ingresa tu cédula',
                  controlador: _cedulaCtrl,
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
                  controlador: _claveCtrl,
                  ocultarTexto: _ocultar,
                  iconoIzquierdo: const Icon(
                    Icons.lock_outline_rounded,
                    size: 20,
                    color: ColoresApp.textoSuave,
                  ),
                  iconoDerecho: IconButton(
                    onPressed: () => setState(() => _ocultar = !_ocultar),
                    icon: Icon(
                      _ocultar
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: ColoresApp.textoSuave,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaRecuperarAcceso()),
                  );
                  },
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
                  texto: 'Iniciar sesión',
                  alPresionar: () {
                    // Flujo autenticado → por ahora a solicitud enviada (placeholder)
                    Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PantallaInicio()),
                  (route) => false
                );
                  },
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
                    onTap: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaRegistro()),
                  );
                    },
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
