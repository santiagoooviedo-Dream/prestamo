import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class TarjetaCorreoRecuperacion extends StatelessWidget {
  final String correo;

  const TarjetaCorreoRecuperacion({super.key, required this.correo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ColoresApp.blobSuave, ColoresApp.fondoAzulClaro2],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColoresApp.bordeAviso),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enviamos un código a:',
            style: TextStyle(fontSize: 13, color: ColoresApp.textoAzulado),
          ),
          const SizedBox(height: 8),
          Text(
            correo,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ColoresApp.primario,
            ),
          ),
        ],
      ),
    );
  }
}
