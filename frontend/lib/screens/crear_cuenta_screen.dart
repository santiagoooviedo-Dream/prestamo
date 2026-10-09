import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/crear_cuenta/crear_header.dart';
import '../widgets/crear_cuenta/crear_fields.dart';
import '../widgets/crear_cuenta/crear_footer.dart';

class CrearCuentaScreen extends StatelessWidget {
  const CrearCuentaScreen({super.key});

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
                    ),
                    CrearFooter(
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
