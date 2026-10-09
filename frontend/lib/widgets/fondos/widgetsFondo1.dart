import 'package:flutter/material.dart';
import 'widgetsFondoColor.dart';

class AppBackground extends StatelessWidget {
  final TipoFondo tipo;
  final Widget child;

  const AppBackground({
    super.key,
    required this.tipo,
    required this.child,
  });

  String _asset() {
    switch (tipo) {
      case TipoFondo.azul:
        return 'assets/backgrounds/fondo_azul.png';
      
      case TipoFondo.azul2:
        return 'assets/backgrounds/fondo_azul2.png';
      
      case TipoFondo.azulBlanco:
        return 'assets/backgrounds/fondo_azul_blanco.png';

      case TipoFondo.azulBlancoTotal:
        return 'assets/backgrounds/fondo_azul_blancoTotal.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          _asset(),
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        ),
        child,
      ],
    );
  }
}