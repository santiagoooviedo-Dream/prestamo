import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'codigo_recuperacion_screen.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/recuperarContrasena/recuperar_header.dart';
import '../widgets/recuperarContrasena/recuperar_form.dart';
import '../widgets/recuperarContrasena/recuperar_info.dart';

class RecuperarScreen extends StatefulWidget {
  const RecuperarScreen({super.key});

  @override
  State<RecuperarScreen> createState() => _RecuperarScreenState();
}

class _RecuperarScreenState extends State<RecuperarScreen> {
  final _correoController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _correoController.dispose();
    super.dispose();
  }

  Future<void> _solicitarCodigo() async {
    final correo = _correoController.text.trim();
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(correo)) {
      _mostrarMensaje('Ingresa un correo electrónico válido.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.solicitarCodigoRecuperacion(correo);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CodigoRecuperacionScreen(correo: correo),
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
                    RecuperarHeader(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    RecuperarForm(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      correoController: _correoController,
                      onSubmit: _solicitarCodigo,
                      isLoading: _isLoading,
                    ),
                    RecuperarInfo(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
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