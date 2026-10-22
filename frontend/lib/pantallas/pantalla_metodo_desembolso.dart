import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_secundario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/opcion_metodo.dart';
import '../models/solicitud_prestamo_model.dart';
import 'pantalla_validando_solicitud.dart';

class PantallaMetodoDesembolso extends StatefulWidget {
  final int monto;
  final int cuotas;
  final String motivo;

  const PantallaMetodoDesembolso({
    super.key,
    required this.monto,
    required this.cuotas,
    required this.motivo,
  });

  @override
  State<PantallaMetodoDesembolso> createState() =>
      _PantallaMetodoDesembolsoState();
}

class _PantallaMetodoDesembolsoState extends State<PantallaMetodoDesembolso> {
  int _sel = 0; // 0 Efectivo, 1 Nequi
  final _telefonoNequiCtrl = TextEditingController();

  @override
  void dispose() {
    _telefonoNequiCtrl.dispose();
    super.dispose();
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
                  'SOLICITUD / DESEMBOLSO',
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
              'Recibe tu dinero',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona cómo quieres recibir tu préstamo.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 28),
            OpcionMetodo(
              icono: Icons.payments_outlined,
              titulo: 'Efectivo',
              seleccionado: _sel == 0,
              onTap: () => setState(() => _sel = 0),
            ),
            if (_sel == 1) ...[
              const SizedBox(height: 16),
              const Text(
                'Número de celular asociado a Nequi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF17243C),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _telefonoNequiCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  hintText: '3001234567',
                  prefixText: '+57 ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE1E8F3)),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            OpcionMetodo(
              icono: Icons.smartphone_outlined,
              titulo: 'Nequi',
              seleccionado: _sel == 1,
              onTap: () => setState(() => _sel = 1),
            ),
            const SizedBox(height: 20),
            const AvisoSeguridad(
              texto: 'Tus datos de desembolso están protegidos.',
            ),
            const Spacer(),
            BotonPrimario(
              texto: 'Continuar',
              alPresionar: () {
                final telefono = _telefonoNequiCtrl.text.trim();
                if (_sel == 1 &&
                    !SolicitudPrestamoModel.esTelefonoNequiValido(telefono)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Ingresa un celular colombiano de 10 dígitos que tenga Nequi.',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PantallaValidandoSolicitud(
                      monto: widget.monto,
                      cuotas: widget.cuotas,
                      motivo: widget.motivo,
                      metodoDesembolso: _sel == 0 ? 'efectivo' : 'nequi',
                      telefonoNequi: _sel == 1 ? telefono : null,
                    ),
                  ),
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
