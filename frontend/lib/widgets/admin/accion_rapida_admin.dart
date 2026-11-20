import 'package:flutter/material.dart';

import '../comunes/punto_rojo.dart';
import '../../nucleo/colores_app.dart';

class AccionRapidaAdmin extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final VoidCallback onTap;
  final bool mostrarPunto;

  const AccionRapidaAdmin({
    super.key,
    required this.icono,
    required this.titulo,
    required this.onTap,
    this.mostrarPunto = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ColoresApp.blanco,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ColoresApp.bordeTarjeta),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ColoresApp.fondoSeleccionado,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Icon(icono, color: ColoresApp.primario, size: 22),
                    ),
                    if (mostrarPunto)
                      Positioned(
                        top: 2,
                        left: 2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: ColoresApp.errorFuerte,
                            shape: BoxShape.circle,
                            border: Border.all(color: ColoresApp.blanco, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: ColoresApp.textoSuave),
            ],
          ),
        ),
      ),
    );
  }
}
