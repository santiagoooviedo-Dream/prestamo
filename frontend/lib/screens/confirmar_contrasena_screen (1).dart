import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/confirmar_contrase%C3%B1a/confirmar_button.dart';
import 'package:front_prestamo/widgets/confirmar_contrase%C3%B1a/confirmar_field.dart';
import 'package:front_prestamo/widgets/confirmar_contrase%C3%B1a/confirmar_header.dart';
import 'package:front_prestamo/widgets/confirmar_contrase%C3%B1a/confirmar_status.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'contrasena_lista_screen.dart';
import '../widgets/fondos/widgetsFondo1.dart';


class ConfirmarContrasenaScreen extends StatefulWidget {
  final String correo;
  final String codigo;
  final String contrasena;

  const ConfirmarContrasenaScreen({
    super.key,
    required this.correo,
    required this.codigo,
    required this.contrasena,
  });

  @override
  State<ConfirmarContrasenaScreen> createState() =>
      _ConfirmarContrasenaScreenState();
}

class _ConfirmarContrasenaScreenState extends State<ConfirmarContrasenaScreen> {
  final _confirmacionController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool? _coinciden;

  @override
  void dispose() {
    _confirmacionController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    if (_confirmacionController.text != widget.contrasena) {
      setState(() => _coinciden = false);
      return;
    }

    setState(() {
      _coinciden = true;
      _isLoading = true;
    });
    try {
      await _authService.recuperarContrasena(
        correo: widget.correo,
        codigo: widget.codigo,
        contrasenaNueva: widget.contrasena,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => const ContrasenaListaScreen(),
        ),
        (route) => false,
      );
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                    ConfirmarHeader(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    ConfirmarField(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      controller: _confirmacionController,
                      onChanged: (value) {
                        setState(() {
                          _coinciden = value.isEmpty
                              ? null
                              : value == widget.contrasena;
                        });
                      },
                    ),
                    ConfirmarStatus(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      coinciden: _coinciden,
                    ),
                    ConfirmarButton(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onPressed: _confirmar,
                      isLoading: _isLoading,
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
