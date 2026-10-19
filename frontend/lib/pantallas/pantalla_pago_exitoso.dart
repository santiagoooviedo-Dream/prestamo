import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_inicio.dart';

class PantallaPagoExitoso extends StatelessWidget {
  const PantallaPagoExitoso({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 20 + bottom),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(
                  alPresionar: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const PantallaInicio()),
                      (_) => false,
                    );
                  },
                ),
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
              child: const Column(
                children: [
                  Text(
                    'Monto pagado',
                    style: TextStyle(fontSize: 13, color: Color(0xFF66758D)),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '\$200.000',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Color(0xFFE3E9F2)),
                  SizedBox(height: 8),
                  _Fila(label: 'Fecha de pago', valor: '20 abril 2026 · 09:15 a. m.'),
                  _Fila(label: 'Método de pago', valor: 'Nequi'),
                ],
              ),
            ),
            const Spacer(flex: 3),
            BotonPrimario(
              texto: 'Volver al inicio',
              alPresionar: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PantallaInicio()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  final String label;
  final String valor;
  const _Fila({required this.label, required this.valor});

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
