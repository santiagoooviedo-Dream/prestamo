import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'loginScreens.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/codigo_verificacion/verif_header.dart';
import '../widgets/codigo_verificacion/verif_inputs.dart';
import '../widgets/codigo_verificacion/verif_button.dart';
import '../widgets/codigo_verificacion/verif_info.dart';

class CodigoVerificacionScreen extends StatefulWidget {
  final String correo;

  const CodigoVerificacionScreen({super.key, required this.correo});

  @override
  State<CodigoVerificacionScreen> createState() =>
      _CodigoVerificacionScreenState();
}

class _CodigoVerificacionScreenState extends State<CodigoVerificacionScreen> {
  final _authService = AuthService();
  String _codigo = '';
  bool _isLoading = false;

  Future<void> _verificar() async {
    if (_codigo.length != 6) {
      _mostrarMensaje('Ingresa el código de 6 dígitos.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.verificarRegistro(
        correo: widget.correo,
        codigo: _codigo,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Cuenta verificada'),
          content: const Text('Ya puedes iniciar sesión con tu cédula y contraseña.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } on ApiException catch (error) {
      if (mounted) _mostrarMensaje(error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _reenviarCodigo() async {
    setState(() => _isLoading = true);
    try {
      await _authService.reenviarCodigoRegistro(widget.correo);
      _mostrarMensaje('Te enviamos un nuevo código de verificación.');
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
                    VerifHeader(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    VerifInputs(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onChanged: (codigo) => _codigo = codigo,
                    ),
                    VerifButton(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onPressed: _verificar,
                      isLoading: _isLoading,
                    ),
                    VerifInfo(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onResend: _reenviarCodigo,
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
