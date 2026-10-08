import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/fondos/widgetsFondoColor.dart';

import '../../widgets/fondos/widgetsFondo1.dart';
import 'login_header.dart';
import 'login_fields.dart';
import 'login_footer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    LoginHeader(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),

                    LoginFields(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),

                    LoginFooter(
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