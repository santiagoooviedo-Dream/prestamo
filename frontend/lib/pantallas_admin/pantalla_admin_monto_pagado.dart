import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';

/// Figma: Monto pagado
class PantallaAdminMontoPagado extends StatelessWidget {
  final int monto;
  final String cuotaTexto;
  final String fechaPago;
  final String metodo;
  final String tipoPrestamo;

  const PantallaAdminMontoPagado({
    super.key,
    this.monto = 200000,
    this.cuotaTexto = 'Cuota 2 de 12',
    this.fechaPago = '20 abril 2026',
    this.metodo = 'Nequi **** 1234',
    this.tipoPrestamo = 'Préstamo personal',
  });

  static String _fmt(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(
                  alPresionar: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                ),
                const Text(
                  'ADMINISTRADOR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Monto pagado',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Revisa los detalles del pago antes de continuar.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 24),

            // Card azul
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF285FE8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Monto pagado',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFD6E4FF),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${_fmt(monto)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cuotaTexto,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFD6E4FF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Detalles del pago
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE1E8F3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalles del pago',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _fila('Fecha de pago', fechaPago),
                  _fila('Préstamo', tipoPrestamo),
                  _fila('Método de pago', metodo, ultimo: true),
                ],
              ),
            ),
            const Spacer(),
            BotonPrimario(
              texto: 'Confirmar',
              alPresionar: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(String k, String v, {bool ultimo = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: ultimo
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF0F3F8))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: const TextStyle(fontSize: 14, color: Color(0xFF66758D)),
            ),
          ),
          Text(
            v,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF17243C),
            ),
          ),
        ],
      ),
    );
  }
}
