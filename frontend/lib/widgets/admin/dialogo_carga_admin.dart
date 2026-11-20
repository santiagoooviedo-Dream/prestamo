import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

Future<void> mostrarCargaAdmin(BuildContext context, String mensaje) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                mensaje,
                style: const TextStyle(fontSize: 14, color: ColoresApp.textoPrincipal),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
