import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_confirmar_pago.dart';

class PantallaCalendarioPagos extends StatelessWidget {
  const PantallaCalendarioPagos({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'MI CUENTA / CALENDARIO',
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
              'Calendario de pagos',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Consulta tus fechas de pago y mantente al día con tus cuotas.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Mini calendario visual
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE1E8F3)),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.chevron_left, color: Color(0xFF66758D)),
                              Text(
                                'Abril 2026',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF17243C),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Color(0xFF66758D)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Lun', style: _diaStyle),
                              Text('Mar', style: _diaStyle),
                              Text('Mié', style: _diaStyle),
                              Text('Jue', style: _diaStyle),
                              Text('Vie', style: _diaStyle),
                              Text('Sáb', style: _diaStyle),
                              Text('Dom', style: _diaStyle),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Semanas simplificadas
                          ..._semanas(),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _Leyenda(color: Color(0xFF22C55E), texto: 'Pagado'),
                              SizedBox(width: 16),
                              _Leyenda(color: Color(0xFF285FE8), texto: 'Próximo pago'),
                              SizedBox(width: 16),
                              _Leyenda(color: Color(0xFFF59E0B), texto: 'Vencido'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Detalle próximo pago
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE1E8F3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Lunes, 20 de abril',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF17243C),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDF3FF),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Text(
                                  'Próximo pago',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF285FE8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const _Detalle(label: 'Cuota', valor: '3 de 12'),
                          const _Detalle(label: 'Monto a pagar', valor: '\$200.000'),
                          const _Detalle(
                              label: 'Fecha límite de pago', valor: '20 abril 2026'),
                          const _Detalle(label: 'Estado', valor: 'Pendiente'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const AvisoSeguridad(
                      texto: 'Paga a tiempo y evita cargos extras.',
                    ),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: 'Pagar ahora',
              alPresionar: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaConfirmarPago()),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }

  static const _diaStyle = TextStyle(fontSize: 11, color: Color(0xFF94A0B3));

  static List<Widget> _semanas() {
    // Abril 2026 empieza miércoles (simplificado visual)
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
          children: fila.map((d) {
            if (d == null) {
              return const SizedBox(width: 32, height: 32);
            }
            final esProximo = d == 20;
            final esPagado = d == 10;
            Color? bg;
            Color fg = const Color(0xFF17243C);
            if (esProximo) {
              bg = const Color(0xFF285FE8);
              fg = Colors.white;
            } else if (esPagado) {
              bg = const Color(0xFFDCFCE7);
              fg = const Color(0xFF168261);
            }
            return Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$d',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: esProximo || esPagado
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: fg,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }).toList();
  }
}

class _Leyenda extends StatelessWidget {
  final Color color;
  final String texto;
  const _Leyenda({required this.color, required this.texto});

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
        Text(texto, style: const TextStyle(fontSize: 10, color: Color(0xFF66758D))),
      ],
    );
  }
}

class _Detalle extends StatelessWidget {
  final String label;
  final String valor;
  const _Detalle({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF66758D))),
          Text(valor,
              style: const TextStyle(fontSize: 13, color: Color(0xFF17243C))),
        ],
      ),
    );
  }
}
