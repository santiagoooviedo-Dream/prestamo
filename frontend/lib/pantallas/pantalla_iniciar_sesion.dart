import 'package:flutter/material.dart';

import '../models/usuario_model.dart';
import '../nucleo/api_service.dart';
import '../widgets/acceso/formulario_inicio_sesion.dart';
import '../pantallas_admin/pantalla_admin_menu.dart';
import 'pantalla_inicio.dart';
import 'pantalla_recuperar_acceso.dart';
import 'pantalla_registro.dart';

class PantallaIniciarSesion extends StatefulWidget {
  const PantallaIniciarSesion({super.key});

  @override
  State<PantallaIniciarSesion> createState() => _PantallaIniciarSesionState();
}

class _PantallaIniciarSesionState extends State<PantallaIniciarSesion> {
  final _modelo = const UsuarioModel();
  final _cedulaCtrl = TextEditingController();
  final _claveCtrl = TextEditingController();
  bool _ocultar = true;
  bool _cargando = false;

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    _claveCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (_cedulaCtrl.text.trim().isEmpty || _claveCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu cédula y contraseña.')),
      );
      return;
    }
    setState(() => _cargando = true);
    try {
      final usuario =
          await _modelo.iniciarSesion(_cedulaCtrl.text.trim(), _claveCtrl.text);
      if (!mounted) return;

      final rol = (usuario['rol'] ?? '').toString().toLowerCase().trim();
      final esAdmin = rol == 'admin' || rol == 'administrador';

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              esAdmin ? const PantallaAdminMenu() : const PantallaInicio(),
        ),
        (route) => false,
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormularioInicioSesion(
      cedulaCtrl: _cedulaCtrl,
      claveCtrl: _claveCtrl,
      ocultar: _ocultar,
      cargando: _cargando,
      alAlternarVisibilidad: () => setState(() => _ocultar = !_ocultar),
      alIniciar: _iniciarSesion,
      alRecuperar: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PantallaRecuperarAcceso()),
      ),
      alRegistrar: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PantallaRegistro()),
      ),
    );
  }
}
