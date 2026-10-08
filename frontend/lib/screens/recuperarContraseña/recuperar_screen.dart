import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';

import '../../widgets/fondos/widgetsFondo1.dart';
import 'recuperar_header.dart';
import 'recuperar_form.dart';
import 'recuperar_info.dart';

class RecuperarScreen extends StatelessWidget {
  const RecuperarScreen({super.key});

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