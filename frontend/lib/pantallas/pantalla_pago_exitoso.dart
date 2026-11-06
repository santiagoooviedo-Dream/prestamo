import 'package:flutter/material.dart';

import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_inicio.dart';

class PantallaPagoExitoso extends StatelessWidget {
  final num? monto;
  final String metodoPago;
  final DateTime? fechaPago;

  const PantallaPagoExitoso({
    super.key,
    this.monto,
    this.metodoPago = 'nequi',
    this.fechaPago,
  });

  String get _montoTexto {
    final valor = (monto ?? 0).round();
    final s = valor.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '\$$buf';
  }

  String get _metodoTexto {
    final m = metodoPago.toLowerCase();
    if (m.contains('nequi')) return 'Nequi';
    if (m.contains('efectivo') || m.contains('personal')) {
      return 'Pago personal';
    }
    if (metodoPago.trim().isEmpty) return '—';
    return metodoPago[0].toUpperCase() + metodoPago.substring(1);
  }

  String get _fechaTexto {
    final f = fechaPago ?? DateTime.now();
    const meses = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    final h = f.hour % 12 == 0 ? 12 : f.hour % 12;
    final min = f.minute.toString().padLeft(2, '0');
    final ampm = f.hour >= 12 ? 'p.m.' : 'a.m.';
    // Formato corto para que no se parta en dos líneas
    return '${f.day} ${meses[f.month - 1]} ${f.year} · $h:$min $ampm';
  }

  void _irInicio(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const PantallaInicio()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 20 + bottom),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => _irInicio(context)),
                Text(
                  'PAGOS / COMPLETADO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F9F0),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD1FAE5), width: 8),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 48,
                color: Color(0xFF22C55E),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Pago realizado con éxito!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu cuota ha sido pagada con éxito.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE1E8F3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Monto pagado',
                    style: TextStyle(fontSize: 13, color: Color(0xFF66758D)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _montoTexto,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE8EEF6), height: 1),
                  const SizedBox(height: 16),
                  _Detalle(label: 'Fecha de pago', valor: _fechaTexto),
                  const SizedBox(height: 14),
                  _Detalle(label: 'Método de pago', valor: _metodoTexto),
                ],
              ),
            ),
            const Spacer(flex: 3),
            BotonPrimario(
              texto: 'Volver',
              alPresionar: () => _irInicio(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _Detalle extends StatelessWidget {
  final String label;
  final String valor;

  const _Detalle({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF66758D)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            valor,
            textAlign: TextAlign.right,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF17243C),
            ),
          ),
        ),
      ],
    );
  }
}
