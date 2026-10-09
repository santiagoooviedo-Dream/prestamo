import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import 'confirmar_contrasena_screen%20(1).dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/nueva_contrasena/nueva_header.dart';
import '../widgets/nueva_contrasena/nueva_field.dart';
import '../widgets/nueva_contrasena/nueva_requisitos.dart';
import '../widgets/nueva_contrasena/nueva_button.dart';

class NuevaContrasenaScreen extends StatefulWidget {
  final String correo;
  final String codigo;

  const NuevaContrasenaScreen({
    super.key,
    required this.correo,
    required this.codigo,
  });

  @override
  State<NuevaContrasenaScreen> createState() => _NuevaContrasenaScreenState();
}

class _NuevaContrasenaScreenState extends State<NuevaContrasenaScreen> {
  final _contrasenaController = TextEditingController();

  @override
  void dispose() {
    _contrasenaController.dispose();
    super.dispose();
  }

  void _continuar() {
    final contrasena = _contrasenaController.text;
    if (contrasena.length < 8 ||
        !RegExp(r'\d').hasMatch(contrasena) ||
        !RegExp(r'[A-Z]').hasMatch(contrasena) ||
        !RegExp(r'[^A-Za-z0-9]').hasMatch(contrasena)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'La contraseña debe tener 8 caracteres, una mayúscula, un número y un símbolo.',
            ),
          ),
        );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ConfirmarContrasenaScreen(
          correo: widget.correo,
          codigo: widget.codigo,
          contrasena: contrasena,
        ),
      ),
    );
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
                    NuevaHeader(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    NuevaField(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      controller: _contrasenaController,
                      onChanged: (_) => setState(() {}),
                    ),
                    NuevaRequisitos(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      contrasena: _contrasenaController.text,
                    ),
                    NuevaButton(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onPressed: _continuar,
                      isLoading: false,
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
