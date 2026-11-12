import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/contrasena_model.dart';
import '../../nucleo/colores_app.dart';
import '../comunes/campo_texto.dart';
import '../comunes/requisito_contrasena.dart';

class FormularioRegistro extends StatefulWidget {
  final TextEditingController cedula;
  final TextEditingController nombreCompleto;
  final TextEditingController correo;
  final TextEditingController telefono;
  final TextEditingController contrasena;
  final bool ocultar;
  final VoidCallback alAlternarVisibilidad;

  const FormularioRegistro({
    super.key,
    required this.cedula,
    required this.nombreCompleto,
    required this.correo,
    required this.telefono,
    required this.contrasena,
    required this.ocultar,
    required this.alAlternarVisibilidad,
  });

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  String? _errorCedula;
  String? _errorTelefono;

  List<TextInputFormatter> _formateadoresNumericos({
    required int maximo,
    required void Function(String) alRechazar,
  }) {
    return [
      TextInputFormatter.withFunction((anterior, nuevo) {
        if (!RegExp(r'^\d*$').hasMatch(nuevo.text)) {
          alRechazar('Solo se permiten números.');
          return anterior;
        }
        if (nuevo.text.length > maximo) {
          alRechazar('No puede superar los $maximo dígitos.');
          return anterior;
        }
        return nuevo;
      }),
    ];
  }

  void _limpiarErrorCedula(String _) {
    if (_errorCedula != null) setState(() => _errorCedula = null);
  }

  void _limpiarErrorTelefono(String _) {
    if (_errorTelefono != null) setState(() => _errorTelefono = null);
  }

  @override
  Widget build(BuildContext context) {
    final clave = widget.contrasena.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CampoTexto(
          etiqueta: 'Cédula',
          pista: 'Número de cédula',
          controlador: widget.cedula,
          tipoTeclado: TextInputType.number,
          formateadores: _formateadoresNumericos(
            maximo: 12,
            alRechazar: (mensaje) => setState(() => _errorCedula = mensaje),
          ),
          mensajeError: _errorCedula,
          alCambiar: _limpiarErrorCedula,
          iconoIzquierdo: const Icon(
            Icons.badge_outlined,
            size: 20,
            color: ColoresApp.textoSuave,
          ),
        ),
        const SizedBox(height: 14),
        CampoTexto(
          etiqueta: 'Nombre y apellido',
          pista: 'Nombre y apellido',
          controlador: widget.nombreCompleto,
          formateadores: [LengthLimitingTextInputFormatter(65)],
          iconoIzquierdo: const Icon(
            Icons.person_outline_rounded,
            size: 20,
            color: ColoresApp.textoSuave,
          ),
        ),
        const SizedBox(height: 14),
        CampoTexto(
          etiqueta: 'Correo electrónico',
          pista: 'correo@ejemplo.com',
          controlador: widget.correo,
          tipoTeclado: TextInputType.emailAddress,
          iconoIzquierdo: const Icon(
            Icons.mail_outline_rounded,
            size: 20,
            color: ColoresApp.textoSuave,
          ),
        ),
        const SizedBox(height: 14),
        CampoTexto(
          etiqueta: 'Teléfono',
          pista: 'Número de teléfono',
          controlador: widget.telefono,
          tipoTeclado: TextInputType.phone,
          formateadores: _formateadoresNumericos(
            maximo: 10,
            alRechazar: (mensaje) => setState(() => _errorTelefono = mensaje),
          ),
          mensajeError: _errorTelefono,
          alCambiar: _limpiarErrorTelefono,
          iconoIzquierdo: const Icon(
            Icons.phone_outlined,
            size: 20,
            color: ColoresApp.textoSuave,
          ),
        ),
        const SizedBox(height: 14),
        CampoTexto(
          etiqueta: 'Contraseña',
          pista: 'Crea tu contraseña',
          controlador: widget.contrasena,
          ocultarTexto: widget.ocultar,
          iconoIzquierdo: const Icon(
            Icons.lock_outline_rounded,
            size: 20,
            color: ColoresApp.textoSuave,
          ),
          iconoDerecho: IconButton(
            onPressed: widget.alAlternarVisibilidad,
            icon: Icon(
              widget.ocultar
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: ColoresApp.textoSuave,
            ),
          ),
        ),
        const SizedBox(height: 12),
        RequisitoContrasena(
          texto: 'Mínimo 8 caracteres',
          ok: ContrasenaModel.tieneLongitudMinima(clave),
        ),
        RequisitoContrasena(
          texto: 'Incluye un número',
          ok: ContrasenaModel.tieneNumero(clave),
        ),
        RequisitoContrasena(
          texto: 'Incluye una mayúscula',
          ok: ContrasenaModel.tieneMayuscula(clave),
        ),
        RequisitoContrasena(
          texto: 'Incluye un símbolo',
          ok: ContrasenaModel.tieneSimbolo(clave),
        ),
      ],
    );
  }
}
