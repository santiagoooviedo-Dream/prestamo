import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import 'pantalla_pago_exitoso.dart';

/// Procesa el pago real contra POST /pagos
class PantallaProcesandoPago extends StatefulWidget {
  final int? idPrestamo;
  final int? idCuota;
  final num? monto;
  final String metodoPago;

  const PantallaProcesandoPago({
    super.key,
    this.idPrestamo,
    this.idCuota,
    this.monto,
    this.metodoPago = 'nequi',
  });

  @override
  State<PantallaProcesandoPago> createState() => _PantallaProcesandoPagoState();
}

class _PantallaProcesandoPagoState extends State<PantallaProcesandoPago> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _procesar();
  }

  Future<void> _procesar() async {
    final idP = widget.idPrestamo;
    final idC = widget.idCuota;
    final monto = widget.monto;

    if (idP == null || idC == null || monto == null) {
      setState(() {
        _error =
            'Faltan datos del préstamo o la cuota. Vuelve e inténtalo de nuevo.';
      });
      return;
    }

    try {
      await ApiService.registrarPago(
        idPrestamo: idP,
        idCuota: idC,
        monto: monto,
        metodoPago: widget.metodoPago.toLowerCase().contains('nequi')
            ? 'nequi'
            : widget.metodoPago.toLowerCase().contains('efectivo')
                ? 'efectivo'
                : widget.metodoPago,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PantallaPagoExitoso()),
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.mensaje);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'No se pudo registrar el pago. Intenta de nuevo.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 24 + bottom),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TP / Préstamos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF285FE8),
                  ),
                ),
                Text(
                  'PAGOS / VALIDACIÓN',
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
            if (_error == null)
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF3FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD6E4FF), width: 6),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28),
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5,
                    color: Color(0xFF285FE8),
                  ),
                ),
              )
            else
              const Icon(Icons.error_outline, size: 72, color: Color(0xFFEF4444)),
            const SizedBox(height: 28),
            Text(
              _error == null ? 'Procesando pago...' : 'No se pudo completar',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _error ?? 'Estamos validando tu transacción.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            if (_error != null) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _error = null);
                  _procesar();
                },
                child: const Text('Reintentar'),
              ),
            ],
            const Spacer(flex: 3),
            const AvisoSeguridad(texto: 'Por favor, no cierres la aplicación.'),
          ],
        ),
      ),
    );
  }
}
