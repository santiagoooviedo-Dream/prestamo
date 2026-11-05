import 'package:flutter/material.dart';

import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_secundario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/opcion_metodo.dart';
import 'pantalla_chat_pago_personal.dart';
import 'pantalla_procesando_pago.dart';

class PantallaMetodoPago extends StatefulWidget {
  final int? idPrestamo;
  final int? idCuota;
  final num? monto;

  const PantallaMetodoPago({
    super.key,
    this.idPrestamo,
    this.idCuota,
    this.monto,
  });

  @override
  State<PantallaMetodoPago> createState() => _PantallaMetodoPagoState();
}

class _PantallaMetodoPagoState extends State<PantallaMetodoPago> {
  /// 0 = Nequi, 1 = Pago personal
  int _sel = 0;

  void _continuar() {
    if (_sel == 1) {
      // Pago personal → chat con administrador
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PantallaChatPagoPersonal(
            idPrestamo: widget.idPrestamo,
            idCuota: widget.idCuota,
            monto: widget.monto,
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaProcesandoPago(
          idPrestamo: widget.idPrestamo,
          idCuota: widget.idCuota,
          monto: widget.monto,
          metodoPago: 'nequi',
        ),
      ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'PAGOS / MÉTODO',
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
              'Método de pago',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona cómo quieres pagar tu cuota.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 28),
            OpcionMetodo(
              icono: Icons.smartphone_outlined,
              titulo: 'Nequi',
              seleccionado: _sel == 0,
              onTap: () => setState(() => _sel = 0),
            ),
            const SizedBox(height: 12),
            OpcionMetodo(
              icono: Icons.person_outline_rounded,
              titulo: 'Pago personal',
              seleccionado: _sel == 1,
              onTap: () => setState(() => _sel = 1),
            ),
            if (_sel == 1) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD9E5FA)),
                ),
                child: const Text(
                  'Al elegir pago personal se abrirá un chat con un administrador para acordar cuándo puedes realizar el pago. Él validará el abono cuando lo confirmes.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF41618E),
                    height: 1.4,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            const AvisoSeguridad(texto: 'Tus datos de pago están protegidos.'),
            const Spacer(),
            BotonPrimario(
              texto: _sel == 1 ? 'Chatear con administrador' : 'Continuar',
              alPresionar: _continuar,
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
