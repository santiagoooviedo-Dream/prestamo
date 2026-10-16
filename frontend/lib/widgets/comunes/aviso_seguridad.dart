import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class AvisoSeguridad extends StatelessWidget {
  final String texto;

  const AvisoSeguridad({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF1FF), Color(0xFFF2F6FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColoresApp.bordeAviso),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 20,
            color: ColoresApp.primario,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 13,
                color: ColoresApp.textoSecundario,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
