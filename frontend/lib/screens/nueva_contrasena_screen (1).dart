import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/nueva_contrasena/nueva_header.dart';
import '../widgets/nueva_contrasena/nueva_field.dart';
import '../widgets/nueva_contrasena/nueva_requisitos.dart';
import '../widgets/nueva_contrasena/nueva_button.dart';

class NuevaContrasenaScreen extends StatelessWidget {
  const NuevaContrasenaScreen({super.key});

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
                    ),
                    NuevaField(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    NuevaRequisitos(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    NuevaButton(
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
