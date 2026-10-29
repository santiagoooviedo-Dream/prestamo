import 'package:flutter/material.dart';

import '../models/contrasena_model.dart';
import '../models/usuario_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/perfil/formulario_cambio_contrasena.dart';

class PantallaCambiarContrasenaPerfil extends StatefulWidget {
  const PantallaCambiarContrasenaPerfil({super.key});

  @override
  State<PantallaCambiarContrasenaPerfil> createState() =>
      _PantallaCambiarContrasenaPerfilState();
}

class _PantallaCambiarContrasenaPerfilState
    extends State<PantallaCambiarContrasenaPerfil> {
  final _actualCtrl = TextEditingController();
  final _nuevaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  final _usuarioModel = const UsuarioModel();
  bool _ocultarActual = true;
  bool _ocultarNueva = true;
  bool _ocultarConfirmar = true;
  bool _guardando = false;

  bool get _valido =>
      _actualCtrl.text.isNotEmpty &&
      ContrasenaModel.esValida(_nuevaCtrl.text) &&
      _nuevaCtrl.text == _confirmarCtrl.text;

  @override
  void initState() {
    super.initState();
    _actualCtrl.addListener(_actualizar);
    _nuevaCtrl.addListener(_actualizar);
    _confirmarCtrl.addListener(_actualizar);
  }

  void _actualizar() => setState(() {});

  @override
  void dispose() {
    _actualCtrl.dispose();
    _nuevaCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    try {
      await _usuarioModel.cambiarContrasena(
        contrasenaActual: _actualCtrl.text,
        contrasenaNueva: _nuevaCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada correctamente.')),
      );
      Navigator.pop(context);
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
                  'PERFIL / SEGURIDAD',
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
              'Cambiar contraseña',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Por tu seguridad, elige una contraseña Segura.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                child: FormularioCambioContrasena(
                  actualCtrl: _actualCtrl,
                  nuevaCtrl: _nuevaCtrl,
                  confirmarCtrl: _confirmarCtrl,
                  ocultarActual: _ocultarActual,
                  ocultarNueva: _ocultarNueva,
                  ocultarConfirmar: _ocultarConfirmar,
                  alternarActual: () =>
                      setState(() => _ocultarActual = !_ocultarActual),
                  alternarNueva: () =>
                      setState(() => _ocultarNueva = !_ocultarNueva),
                  alternarConfirmar: () =>
                      setState(() => _ocultarConfirmar = !_ocultarConfirmar),
                ),
              ),
            ),
            BotonPrimario(
              texto: _guardando ? 'Actualizando…' : 'Confirmar',
              alPresionar: _valido && !_guardando ? _guardar : null,
            ),
          ],
        ),
      ),
    );
  }
}
