import 'package:flutter/material.dart';

/// Puntito rojo de notificación (sin leer / pendiente).
class PuntoRojo extends StatelessWidget {
  final double size;
  final double? top;
  final double? right;

  const PuntoRojo({
    super.key,
    this.size = 8,
    this.top = 0,
    this.right = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}

/// Envuelve un icono y muestra el punto si [activo] es true.
class IconoConPunto extends StatelessWidget {
  final Widget child;
  final bool activo;
  final double size;
  final double top;
  final double right;

  const IconoConPunto({
    super.key,
    required this.child,
    required this.activo,
    this.size = 8,
    this.top = -2,
    this.right = -2,
  });

  @override
  Widget build(BuildContext context) {
    if (!activo) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        PuntoRojo(size: size, top: top, right: right),
      ],
    );
  }
}
