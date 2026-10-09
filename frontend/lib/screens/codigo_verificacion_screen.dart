import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/codigo_verificacion/verif_header.dart';
import '../widgets/codigo_verificacion/verif_inputs.dart';
import '../widgets/codigo_verificacion/verif_button.dart';
import '../widgets/codigo_verificacion/verif_info.dart';

class CodigoVerificacionScreen extends StatelessWidget {
  const CodigoVerificacionScreen({super.key});

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
                    ),
                    VerifButton(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    VerifInfo(
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
