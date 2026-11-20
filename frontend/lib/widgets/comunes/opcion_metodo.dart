import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class OpcionMetodo extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool seleccionado;
  final VoidCallback onTap;

  const OpcionMetodo({
    super.key,
    required this.icono,
    required this.titulo,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: seleccionado ? ColoresApp.fondoInicio : ColoresApp.blanco,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seleccionado
                ? ColoresApp.chipAzul2
                : ColoresApp.bordeTarjeta,
          ),
        ),
        child: Row(
          children: [
            Icon(icono, size: 24, color: ColoresApp.primario),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(fontSize: 16, color: ColoresApp.textoPrincipal),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: seleccionado
                      ? ColoresApp.primario
                      : ColoresApp.bordeBoton,
                  width: 2,
                ),
                color: seleccionado ? ColoresApp.primario : ColoresApp.blanco,
              ),
              child: seleccionado
                  ? const Icon(Icons.circle, size: 10, color: ColoresApp.blanco)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
