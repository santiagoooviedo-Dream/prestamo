import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'nueva_contrasena_screen.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/codigo_recuperacion/codigo_button.dart';
import '../widgets/codigo_recuperacion/codigo_header.dart';
import '../widgets/codigo_recuperacion/codigo_inputs.dart';
import '../widgets/codigo_recuperacion/codigo_info.dart';

class CodigoRecuperacionScreen extends StatefulWidget {
  final String correo;

  const CodigoRecuperacionScreen({super.key, required this.correo});

  @override
  State<CodigoRecuperacionScreen> createState() =>
      _CodigoRecuperacionScreenState();
}

class _CodigoRecuperacionScreenState extends State<CodigoRecuperacionScreen> {
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
      await _authService.verificarCodigoRecuperacion(
        correo: widget.correo,
        codigo: _codigo,
      );
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => NuevaContrasenaScreen(
            correo: widget.correo,
            codigo: _codigo,
          ),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) _mostrarMensaje(error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _reenviarCodigo() async {
    setState(() => _isLoading = true);
    try {
      await _authService.solicitarCodigoRecuperacion(widget.correo);
      _mostrarMensaje('Te enviamos un nuevo código de recuperación.');
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
                    CodigoHeader(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    CodigoInputs(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onChanged: (codigo) => _codigo = codigo,
                    ),
                    CodigoButton(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onPressed: _verificar,
                      isLoading: _isLoading,
                    ),
                    CodigoInfo(
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
