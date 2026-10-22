import 'package:flutter/material.dart';

import '../models/contrasena_model.dart';
import '../models/recuperacion_contrasena_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/recuperacion/formulario_nueva_contrasena.dart';
import 'pantalla_contrasena_lista.dart';

class PantallaNuevaContrasena extends StatefulWidget {
  final String correo;
  final String codigo;

  const PantallaNuevaContrasena({
    super.key,
    required this.correo,
    required this.codigo,
  });

  @override
  State<PantallaNuevaContrasena> createState() =>
      _PantallaNuevaContrasenaState();
}

class _PantallaNuevaContrasenaState extends State<PantallaNuevaContrasena> {
  final _modelo = const RecuperacionContrasenaModel();
  final _claveCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  bool _ocultar = true;
  bool _ocultarConfirmar = true;
  bool _guardando = false;

  int get _puntos {
    return ContrasenaModel.puntaje(_claveCtrl.text);
  }

  bool get _coinciden =>
      _claveCtrl.text.isNotEmpty && _claveCtrl.text == _confirmarCtrl.text;
  bool get _valido => ContrasenaModel.esValida(_claveCtrl.text) && _coinciden;

  @override
  void initState() {
    super.initState();
    _claveCtrl.addListener(_actualizar);
    _confirmarCtrl.addListener(_actualizar);
  }

  void _actualizar() => setState(() {});

  @override
  void dispose() {
    _claveCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarContrasena() async {
    setState(() => _guardando = true);
    try {
      await _modelo.actualizarContrasena(
        correo: widget.correo,
        codigo: widget.codigo,
        contrasenaNueva: _claveCtrl.text,
      );
      if (!mounted) return;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PantallaContrasenaLista()),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
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
                  'RECUPERACIÓN / 1 DE 2',
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
            Expanded(
              child: FormularioNuevaContrasena(
                claveCtrl: _claveCtrl,
                confirmarCtrl: _confirmarCtrl,
                ocultar: _ocultar,
                ocultarConfirmar: _ocultarConfirmar,
                coinciden: _coinciden,
                puntos: _puntos,
                alAlternarClave: () => setState(() => _ocultar = !_ocultar),
                alAlternarConfirmacion: () =>
                    setState(() => _ocultarConfirmar = !_ocultarConfirmar),
              ),
            ),
            BotonPrimario(
              texto: _guardando ? 'Actualizando…' : 'Continuar',
              alPresionar: _valido && !_guardando ? _guardarContrasena : null,
            ),
          ],
        ),
      ),
    );
  }
}
