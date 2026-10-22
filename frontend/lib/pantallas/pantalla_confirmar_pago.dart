import 'package:flutter/material.dart';

import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_secundario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_metodo_pago.dart';

class PantallaConfirmarPago extends StatelessWidget {
  final String metodo;

  const PantallaConfirmarPago({super.key, this.metodo = 'Nequi'});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final args = ModalRoute.of(context)?.settings.arguments;
    final metodoPago = args is String ? args : metodo;

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
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'PAGOS / CONFIRMACIÓN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Confirma tu pago',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Revisa los detalles antes de continuar.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF214EC4), Color(0xFF2865D8)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text(
                    'Monto a pagar',
                    style: TextStyle(fontSize: 13, color: Color(0xFFE4EDFF)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$200.000',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cuota 3 de 12',
                    style: TextStyle(fontSize: 14, color: Color(0xFFE4EDFF)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                  const Text(
                    'Detalles del pago',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _Fila(label: 'Fecha de pago', valor: '20 abril 2026'),
                  const _Fila(label: 'Préstamo', valor: 'Préstamo personal'),
                  _Fila(label: 'Método de pago', valor: metodoPago),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PantallaMetodoPago(),
                      ),
                    ),
                    child: const Text(
                      'Cambiar método de pago',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF285FE8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            BotonPrimario(
              texto: 'Confirmar pago',
              alPresionar: () {
                // Figma: Confirmar pago → Seleccionar método de pago
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PantallaMetodoPago()),
                );
              },
            ),
            const SizedBox(height: 12),
            BotonSecundario(
              texto: 'Cancelar',
              alPresionar: () => Navigator.pop(context),
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
