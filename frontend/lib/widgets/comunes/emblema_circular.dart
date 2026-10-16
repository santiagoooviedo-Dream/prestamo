import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class EmblemaCircular extends StatelessWidget {
  final IconData icono;
  final double tamano;
  final double tamanoIcono;

  const EmblemaCircular({
    super.key,
    required this.icono,
    this.tamano = 112,
    this.tamanoIcono = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDCE8FF), Color(0xFFEDF3FF)],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xA6EDF3FF),
          width: 6,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D17243C),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        icono,
        size: tamanoIcono,
        color: ColoresApp.primario,
      ),
    );
  }
}
