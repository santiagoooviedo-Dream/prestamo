import 'package:flutter/material.dart';
import '../../core/colores.dart';

class NuevaRequisitos extends StatelessWidget {
  final double width;
  final double height;
  final String contrasena;

  const NuevaRequisitos({
    super.key,
    required this.width,
    required this.height,
    required this.contrasena,
  });

  @override
  Widget build(BuildContext context) {
    final items = <(String, bool)>[
      ('Minimo 8 caracteres', contrasena.length >= 8),
      ('Incluye un numero', RegExp(r'\d').hasMatch(contrasena)),
      ('Incluye una mayuscula', RegExp(r'[A-Z]').hasMatch(contrasena)),
      ('Incluye un simbolo', RegExp(r'[^A-Za-z0-9]').hasMatch(contrasena)),
    ];
    final cumplidos = items.where((item) => item.$2).length;
    final colorSeguridad = cumplidos == 4
        ? Colores.verde
        : cumplidos >= 2
            ? Colores.azul
            : Colores.grisOscuro;
    final nivelSeguridad = cumplidos == 4
        ? 'Fuerte'
        : cumplidos >= 2
            ? 'Media'
            : 'Débil';

    return Stack(
      children: [
        // Lista de requisitos
        ...List.generate(items.length, (i) {
          return Positioned(
            left: width * 0.10,
            top: height * (0.470 + i * 0.037),
            child: Row(
              children: [
                Icon(
                  items[i].$2 ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: items[i].$2 ? Colores.verde : Colores.grisOscuro,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  items[i].$1,
                  style: const TextStyle(
                    fontFamily: "Poly_Regular",
                    color: Colores.negro,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }),

        // Seguridad
        Positioned(
          left: width * 0.10,
          top: height * 0.635,
          child: Row(
            children: [
              Icon(
                cumplidos == 4 ? Icons.check_circle : Icons.shield_outlined,
                color: colorSeguridad,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Seguridad: ',
                style: TextStyle(
                  fontFamily: "Poly_Regular",
                  color: Colores.negro,
                  fontSize: 15,
                ),
              ),
              Text(
                nivelSeguridad,
                style: TextStyle(
                  fontFamily: "Poly_Regular",
                  color: colorSeguridad,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        // Barra de fuerza
        Positioned(
          left: width * 0.11,
          right: width * 0.11,
          top: height * 0.715,
          height: 6,
          child: Container(
            decoration: BoxDecoration(
              color: Colores.verdeClaro.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor:
                    (cumplidos / items.length).clamp(0.08, 1.0).toDouble(),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorSeguridad,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
