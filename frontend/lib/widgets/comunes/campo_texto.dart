import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../nucleo/colores_app.dart';

class CampoTexto extends StatelessWidget {
  final String? etiqueta;
  final String? pista;
  final TextEditingController? controlador;
  final bool ocultarTexto;
  final TextInputType tipoTeclado;
  final Widget? iconoIzquierdo;
  final Widget? iconoDerecho;
  final String? Function(String?)? validador;
  final String? mensajeError;
  final void Function(String)? alCambiar;
  final List<TextInputFormatter>? formateadores;
  final int maxLineas;

  const CampoTexto({
    super.key,
    this.etiqueta,
    this.pista,
    this.controlador,
    this.ocultarTexto = false,
    this.tipoTeclado = TextInputType.text,
    this.iconoIzquierdo,
    this.iconoDerecho,
    this.validador,
    this.mensajeError,
    this.alCambiar,
    this.formateadores,
    this.maxLineas = 1,
  });

  @override
  Widget build(BuildContext context) {
    final error = mensajeError;
    final tieneError = error != null && error.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (etiqueta != null && etiqueta!.isNotEmpty) ...[
          Text(
            etiqueta!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controlador,
          obscureText: ocultarTexto && maxLineas <= 1,
          keyboardType: maxLineas > 1 ? TextInputType.multiline : tipoTeclado,
          maxLines: ocultarTexto ? 1 : maxLineas,
          onChanged: alCambiar,
          inputFormatters: formateadores,
          style: const TextStyle(
            fontSize: 15,
            color: ColoresApp.textoPrincipal,
          ),
          decoration: InputDecoration(
            hintText: pista,
            hintStyle: const TextStyle(
              color: ColoresApp.textoSuave,
              fontSize: 15,
            ),
            prefixIcon: iconoIzquierdo,
            suffixIcon: iconoDerecho,
            errorText: tieneError ? error : null,
            filled: true,
            fillColor: ColoresApp.blanco,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: ColoresApp.bordeInput),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: ColoresApp.bordeInput),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: ColoresApp.primario,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: ColoresApp.error),
            ),
          ),
        ),
      ],
    );
  }
}
