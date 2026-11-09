import 'package:flutter/material.dart';

import '../../models/cuenta_model.dart';

class ListaActividadCuenta extends StatefulWidget {
  final List<MovimientoCuenta> movimientos;

  const ListaActividadCuenta({super.key, required this.movimientos});

  @override
  State<ListaActividadCuenta> createState() => _ListaActividadCuentaState();
}

class _ListaActividadCuentaState extends State<ListaActividadCuenta> {
  final _busqueda = TextEditingController();

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  List<MovimientoCuenta> get _filtrados {
    final q = _busqueda.text.trim().toLowerCase();
    final lista = List<MovimientoCuenta>.from(widget.movimientos);
    lista.sort((a, b) {
      if (a.fechaDate == null) return 1;
      if (b.fechaDate == null) return -1;
      return b.fechaDate!.compareTo(a.fechaDate!);
    });
    if (q.isEmpty) return lista;
    return lista.where((m) {
      return m.titulo.toLowerCase().contains(q) ||
          m.descripcion.toLowerCase().contains(q) ||
          m.fecha.toLowerCase().contains(q);
    }).toList();
  }

  Map<String, List<MovimientoCuenta>> get _agrupados {
    final map = <String, List<MovimientoCuenta>>{};
    for (final m in _filtrados) {
      final key = m.fechaDate != null
          ? nombreMesAnio(m.fechaDate!)
          : 'Sin fecha';
      map.putIfAbsent(key, () => []).add(m);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grupos = _agrupados;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Buscar movimientos',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF17243C),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _busqueda,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Movimientos o referencias',
            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A0B3)),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF94A0B3)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE1E8F3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE1E8F3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF285FE8)),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: grupos.isEmpty
              ? const Center(
                  child: Text(
                    'No hay movimientos para mostrar.',
                    style: TextStyle(color: Color(0xFF66758D)),
                  ),
                )
              : ListView.builder(
                  itemCount: grupos.length,
                  itemBuilder: (context, i) {
                    final mes = grupos.keys.elementAt(i);
                    final items = grupos[mes]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  mes,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF17243C),
                                  ),
                                ),
                              ),
                              Text(
                                '${items.length} movimiento${items.length == 1 ? '' : 's'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF94A0B3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...items.map((m) => _TarjetaMovimiento(movimiento: m)),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _TarjetaMovimiento extends StatelessWidget {
  final MovimientoCuenta movimiento;

  const _TarjetaMovimiento({required this.movimiento});

  @override
  Widget build(BuildContext context) {
    final colorMonto = movimiento.positivo
        ? const Color(0xFF168261)
        : const Color(0xFFC47A00);
    final signo = movimiento.positivo ? '+' : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconoMovimiento(movimiento.tipoIcono),
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
                const SizedBox(height: 2),
                Text(
                  movimiento.descripcion,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF66758D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatoFechaHoraCuenta(movimiento.fechaDate),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A0B3),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$signo\$${formatoMontoCuenta(movimiento.monto)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colorMonto,
            ),
          ),
        ],
      ),
    );
  }
}

IconData iconoMovimiento(String tipoIcono) {
  switch (tipoIcono) {
    case 'pago':
      return Icons.calendar_today_outlined;
    case 'interes':
      return Icons.percent_rounded;
    case 'desembolso':
      return Icons.south_west_rounded;
    default:
      return Icons.receipt_long_outlined;
  }
}

