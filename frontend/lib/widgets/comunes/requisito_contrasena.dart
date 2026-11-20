import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class RequisitoContrasena extends StatelessWidget {
  final String texto;
  final bool ok;

  const RequisitoContrasena({super.key, required this.texto, required this.ok});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: ok ? ColoresApp.exito : ColoresApp.textoSuave,
          ),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(
              fontSize: 13,
              color: ok ? ColoresApp.textoPrincipal : ColoresApp.textoSecundario,
            ),
          ),
        ],
      ),
    );
  }
}
