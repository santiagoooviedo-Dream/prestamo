import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _cedula = TextEditingController();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _correo = TextEditingController();
  final _telefono = TextEditingController();
  final _contrasena = TextEditingController();
  bool _ocultar = true;

  @override
  void dispose() {
    _cedula.dispose();
    _nombres.dispose();
    _apellidos.dispose();
    _correo.dispose();
    _telefono.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                const Text(
                  'REGISTRO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Empecemos por ti',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
                height: 1.15,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Completa tus datos para crear tu cuenta.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CampoTexto(
                      etiqueta: 'Cédula',
                      pista: 'Número de cédula',
                      controlador: _cedula,
                      tipoTeclado: TextInputType.number,
                      iconoIzquierdo: const Icon(
                        Icons.badge_outlined,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                    ),
                    const SizedBox(height: 14),
                    CampoTexto(
                      etiqueta: 'Nombres',
                      pista: 'Tus nombres',
                      controlador: _nombres,
                      iconoIzquierdo: const Icon(
                        Icons.person_outline_rounded,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                    ),
                    const SizedBox(height: 14),
                    CampoTexto(
                      etiqueta: 'Apellidos',
                      pista: 'Tus apellidos',
                      controlador: _apellidos,
                      iconoIzquierdo: const Icon(
                        Icons.person_outline_rounded,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                    ),
                    const SizedBox(height: 14),
                    CampoTexto(
                      etiqueta: 'Correo electrónico',
                      pista: 'correo@ejemplo.com',
                      controlador: _correo,
                      tipoTeclado: TextInputType.emailAddress,
                      iconoIzquierdo: const Icon(
                        Icons.mail_outline_rounded,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                    ),
                    const SizedBox(height: 14),
                    CampoTexto(
                      etiqueta: 'Teléfono',
                      pista: 'Número de teléfono',
                      controlador: _telefono,
                      tipoTeclado: TextInputType.phone,
                      iconoIzquierdo: const Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                    ),
                    const SizedBox(height: 14),
                    CampoTexto(
                      etiqueta: 'Contraseña',
                      pista: 'Crea tu contraseña',
                      controlador: _contrasena,
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
                    const SizedBox(height: 6),
                    const Text(
                      'Mínimo 8 caracteres',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9AA6B8),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: 'Crear cuenta',
              alPresionar: () {
                Navigator.pushNamed(context, '/verificar-correo');
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/iniciar-sesion');
                },
                child: const Text.rich(
                  TextSpan(
                    text: '¿Ya tienes cuenta? ',
                    style: TextStyle(fontSize: 13, color: Color(0xFF66758D)),
                    children: [
                      TextSpan(
                        text: 'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF285FE8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
