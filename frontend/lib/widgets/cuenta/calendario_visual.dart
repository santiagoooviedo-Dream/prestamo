import 'package:flutter/material.dart';

List<Widget> semanasCalendario() {
  final filas = [
    [null, null, 1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10, 11, 12],
    [13, 14, 15, 16, 17, 18, 19],
    [20, 21, 22, 23, 24, 25, 26],
    [27, 28, 29, 30, null, null, null],
  ];
  return filas.map((fila) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: fila.map((dia) {
          if (dia == null) return const SizedBox(width: 32, height: 32);
          final esProximo = dia == 20;
          final esPagado = dia == 10;
          final fondo = esProximo
              ? const Color(0xFF285FE8)
              : esPagado
              ? const Color(0xFFDCFCE7)
              : null;
          final colorTexto = esProximo
              ? Colors.white
              : esPagado
              ? const Color(0xFF168261)
              : const Color(0xFF17243C);
          return Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: fondo, shape: BoxShape.circle),
            child: Text(
              '$dia',
              style: TextStyle(
                fontSize: 13,
                fontWeight: esProximo || esPagado
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: colorTexto,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }).toList();
}

class LeyendaCalendario extends StatelessWidget {
  final Color color;
  final String texto;

  const LeyendaCalendario({
    super.key,
    required this.color,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          texto,
          style: const TextStyle(fontSize: 10, color: Color(0xFF66758D)),
        ),
      ],
    );
  }
}

class DetalleCalendario extends StatelessWidget {
  final String label;
  final String valor;

  const DetalleCalendario({
    super.key,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF66758D)),
          ),
          Text(
            valor,
            style: const TextStyle(fontSize: 13, color: Color(0xFF17243C)),
          ),
        ],
      ),
    );
  }
}
