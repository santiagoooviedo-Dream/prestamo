import 'package:flutter/material.dart';

import '../../nucleo/colores_app.dart';

class BotonSecundario extends StatelessWidget {
  final String texto;
  final VoidCallback? alPresionar;

  const BotonSecundario({super.key, required this.texto, this.alPresionar});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: alPresionar,
        style: OutlinedButton.styleFrom(
          foregroundColor: ColoresApp.textoPrincipal,
          backgroundColor: ColoresApp.blanco,
          side: const BorderSide(color: ColoresApp.bordeBoton),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
