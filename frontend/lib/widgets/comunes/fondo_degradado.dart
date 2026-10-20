import 'package:flutter/material.dart';

/// Degradado azul suave de fondo para toda la app.
class FondoDegradado {
  FondoDegradado._();

  static const decoracion = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFD6E4FF), // azul un poco más presente arriba
        Color(0xFFE8F0FE),
        Color(0xFFF0F5FF),
        Color(0xFFF5F8FD),
        Color(0xFFFAFBFD),
      ],
      stops: [0.0, 0.2, 0.45, 0.75, 1.0],
    ),
  );
}
