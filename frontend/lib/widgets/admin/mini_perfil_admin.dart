import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class MiniPerfilAdmin extends StatelessWidget {
  final String nombre;
  final String apellidos;

  const MiniPerfilAdmin({
    super.key,
    required this.nombre,
    required this.apellidos,
  });

  String get _iniciales {
    final a = nombre.isNotEmpty ? nombre[0] : '';
    final b = apellidos.isNotEmpty ? apellidos[0] : '';
    return ('$a$b').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColoresApp.bordeTarjeta),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: ColoresApp.fondoSeleccionado,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _iniciales,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ColoresApp.primario,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
                Text(
                  apellidos,
                  style: const TextStyle(fontSize: 13, color: ColoresApp.textoSecundario),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
