import 'package:flutter/material.dart';

import '../models/registro_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/registro/formulario_registro.dart';
import 'pantalla_iniciar_sesion.dart';
import 'pantalla_verificar_correo.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _modelo = const RegistroModel();
  final _cedula = TextEditingController();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _correo = TextEditingController();
  final _telefono = TextEditingController();
  final _contrasena = TextEditingController();
  bool _ocultar = true;
  bool _registrando = false;

  @override
  void initState() {
    super.initState();
    _contrasena.addListener(_actualizar);
  }

  void _actualizar() => setState(() {});

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

  Future<void> _registrar() async {
    final correo = _correo.text.trim();
    if (_cedula.text.trim().isEmpty ||
        _nombres.text.trim().isEmpty ||
        _apellidos.text.trim().isEmpty ||
        correo.isEmpty ||
        _telefono.text.trim().isEmpty ||
        !RegistroModel.contrasenaValida(_contrasena.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa todos los datos y cumple los requisitos de la contraseña.',
          ),
        ),
      );
      return;
    }

    setState(() => _registrando = true);
    try {
      await _modelo.registrar(
        cedula: _cedula.text.trim(),
        nombres: _nombres.text.trim(),
        apellidos: _apellidos.text.trim(),
        correo: correo,
        telefono: _telefono.text.trim(),
        contrasena: _contrasena.text,
      );
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PantallaVerificarCorreo(correo: correo),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _registrando = false);
    }
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
                  alPresionar: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PantallaIniciarSesion(),
                    ),
                    (route) => route.isFirst,
                  ),
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
              'Crear cuenta',
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
                child: FormularioRegistro(
                  cedula: _cedula,
                  nombres: _nombres,
                  apellidos: _apellidos,
                  correo: _correo,
                  telefono: _telefono,
                  contrasena: _contrasena,
                  ocultar: _ocultar,
                  alAlternarVisibilidad: () =>
                      setState(() => _ocultar = !_ocultar),
                ),
              ),
            ),
            BotonPrimario(
              texto: _registrando ? 'Enviando…' : 'Crear cuenta',
              alPresionar: _registrando ? null : _registrar,
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PantallaIniciarSesion(),
                  ),
                ),
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