import 'package:flutter/material.dart';

import '../../models/contrasena_model.dart';
import '../comunes/campo_texto.dart';
import '../comunes/requisito_contrasena.dart';

class FormularioCambioContrasena extends StatelessWidget {
  final TextEditingController actualCtrl;
  final TextEditingController nuevaCtrl;
  final TextEditingController confirmarCtrl;
  final bool ocultarActual;
  final bool ocultarNueva;
  final bool ocultarConfirmar;
  final VoidCallback alternarActual;
  final VoidCallback alternarNueva;
  final VoidCallback alternarConfirmar;

  const FormularioCambioContrasena({
    super.key,
    required this.actualCtrl,
    required this.nuevaCtrl,
    required this.confirmarCtrl,
    required this.ocultarActual,
    required this.ocultarNueva,
    required this.ocultarConfirmar,
    required this.alternarActual,
    required this.alternarNueva,
    required this.alternarConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    final clave = nuevaCtrl.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _campo(
          etiqueta: 'Contraseña actual',
          pista: 'Tu contraseña actual',
          controlador: actualCtrl,
          ocultar: ocultarActual,
          alternar: alternarActual,
        ),
        const SizedBox(height: 16),
        _campo(
          etiqueta: 'Contraseña nueva',
          pista: 'Crea una contraseña',
          controlador: nuevaCtrl,
          ocultar: ocultarNueva,
          alternar: alternarNueva,
        ),
        const SizedBox(height: 16),
        _campo(
          etiqueta: 'Confirmar contraseña',
          pista: 'Repite la nueva contraseña',
          controlador: confirmarCtrl,
          ocultar: ocultarConfirmar,
          alternar: alternarConfirmar,
        ),
        const SizedBox(height: 20),
        RequisitoContrasena(
          texto: 'Mínimo 8 caracteres',
          ok: ContrasenaModel.tieneLongitudMinima(clave),
        ),
        RequisitoContrasena(
          texto: 'Incluye una mayúscula y un número',
          ok:
              ContrasenaModel.tieneMayuscula(clave) &&
              ContrasenaModel.tieneNumero(clave),
        ),
        RequisitoContrasena(
          texto: 'Incluye un símbolo especial',
          ok: ContrasenaModel.tieneSimbolo(clave),
        ),
        RequisitoContrasena(
          texto: 'Las contraseñas coinciden',
          ok: clave.isNotEmpty && clave == confirmarCtrl.text,
        ),
      ],
    );
  }

  Widget _campo({
    required String etiqueta,
    required String pista,
    required TextEditingController controlador,
    required bool ocultar,
    required VoidCallback alternar,
  }) {
    return CampoTexto(
      etiqueta: etiqueta,
      pista: pista,
      controlador: controlador,
      ocultarTexto: ocultar,
      iconoIzquierdo: const Icon(Icons.lock_outline_rounded, size: 20),
      iconoDerecho: IconButton(
        onPressed: alternar,
        icon: Icon(
          ocultar ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
        ),
      ),
    );
  }
}
