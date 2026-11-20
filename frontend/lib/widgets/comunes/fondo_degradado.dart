import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

/// Degradado azul suave de fondo para toda la app.
class FondoDegradado {
  FondoDegradado._();

  static const decoracion = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColoresApp.chipAzul, // azul un poco más presente arriba
        ColoresApp.fondoSeleccionado,
        ColoresApp.fondoAzulClaro,
        ColoresApp.fondoSuave2,
        ColoresApp.fondoAlt,
      ],
      stops: [0.0, 0.2, 0.45, 0.75, 1.0],
    ),
  );
}
