import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class FilaDetallePrestamo extends StatelessWidget {
  final String label;
  final String valor;

  const FilaDetallePrestamo({
    super.key,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: ColoresApp.textoSecundario),
          ),
          Text(
            valor,
            style: const TextStyle(fontSize: 13, color: ColoresApp.textoPrincipal),
          ),
        ],
      ),
    );
  }
}
