import 'package:flutter/material.dart';
import 'package:front_prestamo/screens/Bienvenido_card.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';

import '../fondos/widgetsFondo1.dart';
import '../../models/usuario.dart';
import '../../screens/loginScreens.dart';

class InicioScreen extends StatelessWidget {
  final Sesion sesion;

  const InicioScreen({super.key, required this.sesion});

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
                  SizedBox(height: constraints.maxHeight * 0.10),

                  Image.asset(
                    'assets/images/logo_prestamos.png',
                    width: 200,
                    height: 200,
                  ),

                  SizedBox(height: constraints.maxHeight * 0.06),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.16,
                    ),
                    child: BienvenidaCard(
                      usuario: sesion.usuario,
                      onLogout: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
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
