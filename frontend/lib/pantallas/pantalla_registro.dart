import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';
import 'pantalla_iniciar_sesion.dart';
import 'pantalla_verificar_correo.dart';

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

  bool get _min8 => _contrasena.text.length >= 8;
  bool get _tieneNumero => RegExp(r'[0-9]').hasMatch(_contrasena.text);
  bool get _tieneMayuscula => RegExp(r'[A-Z]').hasMatch(_contrasena.text);
  bool get _tieneSimbolo =>
      RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\;/]').hasMatch(_contrasena.text);

  @override
  void initState() {
    super.initState();
    _contrasena.addListener(() => setState(() {}));
  }

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
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(
                  alPresionar: () {
                    // Figma: Crear cuenta ← → Iniciar sesión (evita pantalla blanca)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PantallaIniciarSesion(),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                ),
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
                    const SizedBox(height: 12),
                    _Requisito(texto: 'Mínimo 8 caracteres', ok: _min8),
                    _Requisito(texto: 'Incluye un número', ok: _tieneNumero),
                    _Requisito(texto: 'Incluye una mayúscula', ok: _tieneMayuscula),
                    _Requisito(texto: 'Incluye un símbolo', ok: _tieneSimbolo),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: 'Crear cuenta',
              alPresionar: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaVerificarCorreo()),
                  );
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaIniciarSesion()),
                  );
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

class _Requisito extends StatelessWidget {
  final String texto;
  final bool ok;

  const _Requisito({required this.texto, required this.ok});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: ok ? const Color(0xFF22C55E) : const Color(0xFF94A0B3),
          ),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(
              fontSize: 13,
              color: ok ? const Color(0xFF17243C) : const Color(0xFF66758D),
            ),
          ),
        ],
      ),
    );
  }
}
