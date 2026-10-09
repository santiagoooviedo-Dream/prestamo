import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/confirmar_contrase%C3%B1a/confirmar_button.dart';
import 'package:front_prestamo/widgets/confirmar_contrase%C3%B1a/confirmar_field.dart';
import 'package:front_prestamo/widgets/confirmar_contrase%C3%B1a/confirmar_header.dart';
import 'package:front_prestamo/widgets/confirmar_contrase%C3%B1a/confirmar_status.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../widgets/fondos/widgetsFondo1.dart';


class ConfirmarContrasenaScreen extends StatelessWidget {
  const ConfirmarContrasenaScreen({super.key});

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
                    ),
                    ConfirmarField(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    ConfirmarStatus(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    ConfirmarButton(
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
