import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/contrase%C3%B1a_lista/lista_content.dart';
import 'package:front_prestamo/widgets/contrase%C3%B1a_lista/lista_header.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';

import 'loginScreens.dart';
import '../widgets/fondos/widgetsFondo1.dart';

class ContrasenaListaScreen extends StatelessWidget {
  const ContrasenaListaScreen({super.key});

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
                    ListaHeader(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onBack: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    ListaContent(
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
