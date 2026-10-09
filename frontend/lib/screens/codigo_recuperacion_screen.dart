import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/codigo_recuperacion/codigo_button.dart';
import '../widgets/codigo_recuperacion/codigo_header.dart';
import '../widgets/codigo_recuperacion/codigo_inputs.dart';
import '../widgets/codigo_recuperacion/codigo_info.dart';

class CodigoRecuperacionScreen extends StatelessWidget {
  const CodigoRecuperacionScreen({super.key});

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
                    ),
                    CodigoButton(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    CodigoInfo(
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
