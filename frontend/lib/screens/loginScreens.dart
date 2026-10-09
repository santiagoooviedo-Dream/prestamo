import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'recuperar_screen.dart';
import 'crear_cuenta_screen.dart';
import '../widgets/Inicio/InicioScreens.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/login/login_header.dart';
import '../widgets/login/login_fields.dart';
import '../widgets/login/login_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _cedulaController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _cedulaController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    final cedula = _cedulaController.text.trim();
    final contrasena = _contrasenaController.text;
    if (cedula.isEmpty || contrasena.isEmpty) {
      _mostrarMensaje('Ingresa tu cédula y contraseña.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final sesion = await _authService.iniciarSesion(
        cedula: cedula,
        contrasena: contrasena,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => InicioScreen(
            sesion: sesion,
          ),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) _mostrarMensaje(error.message);
    } on FormatException catch (error) {
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
                    LoginHeader(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),

                    LoginFields(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      cedulaController: _cedulaController,
                      contrasenaController: _contrasenaController,
                      onLogin: _iniciarSesion,
                      isLoading: _isLoading,
                      onRecovery: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const RecuperarScreen(),
                          ),
                        );
                      },
                    ),

                    LoginFooter(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onRegister: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const CrearCuentaScreen(),
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