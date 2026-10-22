import 'package:flutter/material.dart';

import '../models/solicitud_prestamo_model.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/prestamos/formulario_solicitud_prestamo.dart';
import 'pantalla_metodo_desembolso.dart';

class PantallaSolicitarPrestamo extends StatefulWidget {
  const PantallaSolicitarPrestamo({super.key});

  @override
  State<PantallaSolicitarPrestamo> createState() =>
      _PantallaSolicitarPrestamoState();
}

class _PantallaSolicitarPrestamoState extends State<PantallaSolicitarPrestamo> {
  final _montoCtrl = TextEditingController(text: '1000000');
  final _motivoCtrl = TextEditingController();
  int? _cuotas;
  bool _menuAbierto = false;

  int get _monto {
    final texto = _montoCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(texto) ?? 0;
  }

  bool get _mostrarResumen =>
      _cuotas != null && SolicitudPrestamoModel.esMontoValido(_monto);

  @override
  void initState() {
    super.initState();
    _montoCtrl.addListener(_actualizar);
  }

  void _actualizar() => setState(() {});

  @override
  void dispose() {
    _montoCtrl.dispose();
    _motivoCtrl.dispose();
    super.dispose();
  }

  void _continuar() {
    if (!_mostrarResumen ||
        _cuotas == null ||
        !SolicitudPrestamoModel.sonCuotasValidas(_cuotas!) ||
        _motivoCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Verifica el monto, las cuotas y el motivo del préstamo.',
          ),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaMetodoDesembolso(
          monto: _monto,
          cuotas: _cuotas!,
          motivo: _motivoCtrl.text.trim(),
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
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  _cuotas == null ? 'SOLICITUD / DATOS' : 'SOLICITUD / CUOTAS',
                  style: const TextStyle(
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
              'Solicita tu préstamo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Completa la información para continuar.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: FormularioSolicitudPrestamo(
                  montoCtrl: _montoCtrl,
                  motivoCtrl: _motivoCtrl,
                  monto: _monto,
                  cuotas: _cuotas,
                  menuAbierto: _menuAbierto,
                  mostrarResumen: _mostrarResumen,
                  alCambiarMonto: _actualizar,
                  alAlternarMenu: () =>
                      setState(() => _menuAbierto = !_menuAbierto),
                  alSeleccionarCuotas: (valor) => setState(() {
                    _cuotas = valor;
                    _menuAbierto = false;
                  }),
                ),
              ),
            ),
            BotonPrimario(texto: 'Continuar', alPresionar: _continuar),
          ],
        ),
      ),
    );
  }
}
