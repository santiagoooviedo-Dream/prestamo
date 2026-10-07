import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';
import '../../../widgets/fondos/widgetsFondo1.dart';

import 'Bienvenido_card.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        tipo: TipoFondo.azul,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.10,
                  ),

                  Image.asset(
                    'assets/images/logo_prestamos.png',
                    width: 200,
                    height: 200,
                  ),

                  SizedBox(
                    height: constraints.maxHeight * 0.06,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.16,
                    ),
                    child: const BienvenidaCard(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}