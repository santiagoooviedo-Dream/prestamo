import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'codigo_verificacion_screen.dart';
import 'loginScreens.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/crear_cuenta/crear_header.dart';
import '../widgets/crear_cuenta/crear_fields.dart';
import '../widgets/crear_cuenta/crear_footer.dart';

class CrearCuentaScreen extends StatefulWidget {
  const CrearCuentaScreen({super.key});

  @override
  State<CrearCuentaScreen> createState() => _CrearCuentaScreenState();
}

class _CrearCuentaScreenState extends State<CrearCuentaScreen> {
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _authService = AuthService();
  bool _aceptaTerminos = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _crearCuenta() async {
    final cedula = _cedulaController.text.trim();
    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final correo = _correoController.text.trim();
    final telefono = _telefonoController.text.trim();
    final contrasena = _contrasenaController.text;

    if ([cedula, nombre, apellido, correo, telefono, contrasena]
        .any((value) => value.isEmpty)) {
      _mostrarMensaje('Completa todos los campos.');
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(correo)) {
      _mostrarMensaje('Ingresa un correo electrónico válido.');
      return;
    }
    if (contrasena.length < 8) {
      _mostrarMensaje('La contraseña debe tener al menos 8 caracteres.');
      return;
    }
    if (!_aceptaTerminos) {
      _mostrarMensaje('Debes aceptar los términos y condiciones.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.registrar(
        cedula: cedula,
        nombre: nombre,
        apellido: apellido,
        correo: correo,
        telefono: telefono,
        contrasena: contrasena,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => CodigoVerificacionScreen(correo: correo),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) _mostrarMensaje(error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        tipo: TipoFondo.azul2,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  children: [
                    CrearHeader(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    CrearFields(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      cedulaController: _cedulaController,
                      nombreController: _nombreController,
                      apellidoController: _apellidoController,
                      correoController: _correoController,
                      telefonoController: _telefonoController,
                      contrasenaController: _contrasenaController,
                    ),
                    CrearFooter(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      aceptaTerminos: _aceptaTerminos,
                      onAceptaTerminosChanged: (value) {
                        setState(() => _aceptaTerminos = value ?? false);
                      },
                      onCrearCuenta: _crearCuenta,
                      isLoading: _isLoading,
                      onIniciarSesion: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
