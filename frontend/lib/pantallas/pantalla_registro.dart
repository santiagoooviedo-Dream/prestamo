import 'package:flutter/material.dart';

import '../models/registro_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/registro/formulario_registro.dart';
import 'pantalla_iniciar_sesion.dart';
import 'pantalla_verificar_correo.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _modelo = const RegistroModel();
  final _cedula = TextEditingController();
  final _nombreCompleto = TextEditingController();
  final _correo = TextEditingController();
  final _telefono = TextEditingController();
  final _contrasena = TextEditingController();
  bool _ocultar = true;
  bool _registrando = false;
  bool _aceptoTerminos = false;
  bool _errorTerminos = false;
  Map<String, String> _errores = {};

  @override
  void initState() {
    super.initState();
    _contrasena.addListener(_actualizar);
  }

  void _actualizar() => setState(() {});

  void _limpiarError(String campo) {
    if (!_errores.containsKey(campo)) return;
    setState(() => _errores = Map.of(_errores)..remove(campo));
  }

  void _mostrarErrorApi(String mensaje) {
    final texto = mensaje.toLowerCase();
    final errores = <String, String>{};

    if (texto.contains('correo')) {
      errores['correo'] = mensaje;
    }
    if (texto.contains('cédula') || texto.contains('cedula')) {
      errores['cedula'] = mensaje;
    }
    if (texto.contains('teléfono') || texto.contains('telefono')) {
      errores['telefono'] = mensaje;
    }
    if (texto.contains('contraseña') || texto.contains('contrasena')) {
      errores['contrasena'] = mensaje;
    }
    if (texto.contains('nombre')) {
      errores['nombre'] = mensaje;
    }

    if (errores.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
      return;
    }

    setState(() => _errores = errores);
  }

  @override
  void dispose() {
    _cedula.dispose();
    _nombreCompleto.dispose();
    _correo.dispose();
    _telefono.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    final correo = _correo.text.trim().toLowerCase();
    final completo = _nombreCompleto.text.trim();
    final cedula = _cedula.text.trim();
    final telefono = _telefono.text.trim();
    final errores = <String, String>{};

    if (completo.isEmpty) {
      errores['nombre'] = 'Ingresa tu nombre y apellido.';
    } else if (completo.length > 65) {
      errores['nombre'] = 'No puede superar 65 caracteres.';
    }

    if (cedula.isEmpty) {
      errores['cedula'] = 'Ingresa tu número de cédula.';
    } else if (!RegExp(r'^\d{1,12}$').hasMatch(cedula)) {
      errores['cedula'] = 'Debe tener entre 1 y 12 dígitos.';
    }

    if (correo.isEmpty) {
      errores['correo'] = 'Ingresa tu correo electrónico.';
    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(correo)) {
      errores['correo'] = 'Ingresa un correo electrónico válido.';
    }

    if (telefono.isEmpty) {
      errores['telefono'] = 'Ingresa tu número de teléfono.';
    } else if (!RegExp(r'^\d{10}$').hasMatch(telefono)) {
      errores['telefono'] = 'Debe tener exactamente 10 dígitos.';
    }

    if (!RegistroModel.contrasenaValida(_contrasena.text)) {
      errores['contrasena'] =
          'Cumple todos los requisitos indicados para la contraseña.';
    }

    setState(() {
      _errores = errores;
      _errorTerminos = !_aceptoTerminos;
    });

    if (errores.isNotEmpty || !_aceptoTerminos) {
      return;
    }

    setState(() => _registrando = true);
    try {
      final partes = completo.split(RegExp(r'\s+'));
      final nombre = partes.isNotEmpty ? partes.first : completo;
      final apellido = partes.length > 1 ? partes.sublist(1).join(' ') : nombre;
      await _modelo.registrar(
        cedula: cedula,
        nombres: nombre,
        apellidos: apellido,
        correo: correo,
        telefono: telefono,
        contrasena: _contrasena.text,
      );
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PantallaVerificarCorreo(correo: correo),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      _mostrarErrorApi(error.mensaje);
    } finally {
      if (mounted) setState(() => _registrando = false);
    }
  }

  Future<void> _mostrarTerminos() {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y condiciones'),
        content: const SingleChildScrollView(
          child: Text(
            'Al aceptar los términos y condiciones, usted autoriza el '
            'tratamiento de sus datos personales (nombre, documento, correo '
            'electrónico y fecha de nacimiento) conforme a la Ley 1581 de '
            '2012 y el Decreto 1377 de 2013, con la finalidad de gestionar '
            'su registro, acceso y uso de la aplicación. Sus datos serán '
            'almacenados de forma segura y no serán compartidos con terceros '
            'sin su consentimiento, salvo obligación legal. Puede ejercer '
            'sus derechos de acceso, rectificación, cancelación y oposición '
            'en cualquier momento.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
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
                BotonVolver(
                  alPresionar: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PantallaIniciarSesion(),
                    ),
                    (route) => route.isFirst,
                  ),
                ),
                const Text(
                  'REGISTRO',
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
            const Text(
              'Crear cuenta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: ColoresApp.textoPrincipal,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Completa tus datos para crear tu cuenta.',
              style: TextStyle(
                fontSize: 15,
                color: ColoresApp.textoSecundario,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormularioRegistro(
                      cedula: _cedula,
                      nombreCompleto: _nombreCompleto,
                      correo: _correo,
                      telefono: _telefono,
                      contrasena: _contrasena,
                      ocultar: _ocultar,
                      alAlternarVisibilidad: () =>
                          setState(() => _ocultar = !_ocultar),
                      errorCedula: _errores['cedula'],
                      errorNombre: _errores['nombre'],
                      errorCorreo: _errores['correo'],
                      errorTelefono: _errores['telefono'],
                      errorContrasena: _errores['contrasena'],
                      alCambiarCedula: (_) => _limpiarError('cedula'),
                      alCambiarNombre: (_) => _limpiarError('nombre'),
                      alCambiarCorreo: (_) => _limpiarError('correo'),
                      alCambiarTelefono: (_) => _limpiarError('telefono'),
                      alCambiarContrasena: (_) => _limpiarError('contrasena'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _aceptoTerminos,
                          activeColor: ColoresApp.primario,
                          onChanged: (aceptado) => setState(() {
                            _aceptoTerminos = aceptado ?? false;
                            if (_aceptoTerminos) _errorTerminos = false;
                          }),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: _mostrarTerminos,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Acepto los ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: ColoresApp.textoSecundario,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'términos y condiciones',
                                      style: TextStyle(
                                        color: ColoresApp.primario,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_errorTerminos)
                      const Padding(
                        padding: EdgeInsets.only(left: 12, top: 2),
                        child: Text(
                          'Debes aceptar los términos y condiciones.',
                          style: TextStyle(
                            color: ColoresApp.errorMaterial,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: _registrando ? 'Enviando…' : 'Crear cuenta',
              alPresionar: _registrando ? null : _registrar,
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PantallaIniciarSesion(),
                  ),
                ),
                child: const Text.rich(
                  TextSpan(
                    text: '¿Ya tienes cuenta? ',
                    style: TextStyle(fontSize: 13, color: ColoresApp.textoSecundario),
                    children: [
                      TextSpan(
                        text: 'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ColoresApp.primario,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
