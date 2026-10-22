import 'package:flutter/material.dart';
import '../../models/cuenta_model.dart';

class ListaActividadCuenta extends StatelessWidget {
  final List<MovimientoCuenta> movimientos;

  const ListaActividadCuenta({super.key, required this.movimientos});

  @override
  Widget build(BuildContext context) {
    final grupos = <String, List<MovimientoCuenta>>{};
    for (final movimiento in movimientos) {
      final fecha = DateTime.tryParse(movimiento.fecha);
      final grupo = fecha == null ? 'Otros movimientos' : _mes(fecha);
      grupos.putIfAbsent(grupo, () => []).add(movimiento);
    }
    if (grupos.isEmpty) {
      return const Center(child: Text('Todavía no hay movimientos.'));
    }
    return ListView(
      children: grupos.entries.expand((grupo) {
        return [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  grupo.key,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF17243C),
                  ),
                ),
                Text(
                  '${grupo.value.length} movimientos',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF66758D),
                  ),
                ),
              ],
            ),
          ),
          ...grupo.value.map(
            (movimiento) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TarjetaMovimiento(movimiento: movimiento),
            ),
          ),
        ];
      }).toList(),
    );
  }

  String _mes(DateTime fecha) {
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${meses[fecha.month - 1]} ${fecha.year}';
  }
}

class _TarjetaMovimiento extends StatelessWidget {
  final MovimientoCuenta movimiento;

  const _TarjetaMovimiento({required this.movimiento});

  @override
  Widget build(BuildContext context) {
    final fecha = DateTime.tryParse(movimiento.fecha);
    final fechaTexto = fecha == null
        ? 'Fecha no disponible'
        : '${fecha.day} ${fecha.month}/${fecha.year}';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              movimiento.icono,
              size: 20,
              color: const Color(0xFF285FE8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movimiento.titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF17243C),
                  ),
                ),
                Text(
                  movimiento.descripcion,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF66758D),
                  ),
                ),
                Text(
                  fechaTexto,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A0B3),
                  ),
                ),
              ],
            ),
          ),
          Text(
            _monto(movimiento.monto),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: movimiento.positivo
                  ? const Color(0xFF168261)
                  : const Color(0xFFD97706),
            ),
          ),
        ],
      ),
    );
  }

  String _monto(double monto) {
    final texto = monto.abs().toInt().toString();
    final salida = StringBuffer();
    for (var i = 0; i < texto.length; i++) {
      if (i > 0 && (texto.length - i) % 3 == 0) salida.write('.');
      salida.write(texto[i]);
    }
    return '${movimiento.positivo ? '+' : '-'}\$$salida';
  }
}
