import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';

class PantallaActividadCuenta extends StatelessWidget {
  const PantallaActividadCuenta({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    final grupos = {
      'Abril 2026': [
        _Item('Desembolso', 'Préstamo personal', '10 abril 2026 · 10:30 a. m.',
            '+\$1.000.000', true, Icons.south_west_rounded),
        _Item('Pago de cuota', 'Cuota #2 de tu préstamo',
            '10 abril 2026 · 9:30 a. m.', '+\$1.000.000', true,
            Icons.calendar_today_outlined),
        _Item('Interés aplicado', 'Interés mensual',
            '10 abril 2026 · 9:30 a. m.', '-\$1.000.000', false,
            Icons.percent_rounded),
      ],
      'Marzo 2026': [
        _Item('Desembolso', 'Préstamo personal', '10 marzo 2026 · 10:30 a. m.',
            '+\$1.000.000', true, Icons.south_west_rounded),
        _Item('Pago de cuota', 'Cuota #2 de tu préstamo',
            '10 marzo 2026 · 9:30 a. m.', '+\$1.000.000', true,
            Icons.calendar_today_outlined),
        _Item('Interés aplicado', 'Interés mensual',
            '10 marzo 2026 · 9:30 a. m.', '-\$1.000.000', false,
            Icons.percent_rounded),
      ],
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'MI CUENTA / ACTIVIDAD',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Actividad de cuenta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Consulta todos los movimientos de tu cuenta.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 16),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE1E8F3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 20, color: Color(0xFF94A0B3)),
                  SizedBox(width: 10),
                  Text(
                    'Movimientos o referencias',
                    style: TextStyle(fontSize: 14, color: Color(0xFF94A0B3)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: grupos.entries.expand((e) {
                  return [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF17243C))),
                          Text('${e.value.length} movimientos',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF66758D))),
                        ],
                      ),
                    ),
                    ...e.value.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _TarjetaMov(m),
                        )),
                  ];
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item {
  final String titulo, sub, fecha, monto;
  final bool positivo;
  final IconData icono;
  _Item(this.titulo, this.sub, this.fecha, this.monto, this.positivo, this.icono);
}

class _TarjetaMov extends StatelessWidget {
  final _Item m;
  const _TarjetaMov(this.m);

  @override
  Widget build(BuildContext context) {
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
            child: Icon(m.icono, size: 20, color: const Color(0xFF285FE8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.titulo,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C))),
                Text(m.sub,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF66758D))),
                Text(m.fecha,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF94A0B3))),
              ],
            ),
          ),
          Text(
            m.monto,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: m.positivo
                  ? const Color(0xFF168261)
                  : const Color(0xFFD97706),
            ),
          ),
        ],
      ),
    );
  }
}
