import 'package:flutter/material.dart';
import '../../core/colores.dart';

class NuevaRequisitos extends StatelessWidget {
  final double width;
  final double height;

  const NuevaRequisitos({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      'Minimo 8 caracteres',
      'Incluye un numero',
      'Incluye una mayuscula',
      'Incluye un simbolo',
    ];

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
                  Icons.check_circle,
                  color: Colores.verde,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  items[i],
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
                Icons.check_circle,
                color: Colores.verde,
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
                'Fuerte',
                style: TextStyle(
                  fontFamily: "Poly_Regular",
                  color: Colores.verde,
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
              color: Colores.verdeClaro.withOpacity(0.4),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.82,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colores.verde,
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
