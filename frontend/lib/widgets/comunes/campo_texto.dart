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
  final void Function(String)? alCambiar;
  final List<TextInputFormatter>? formateadores;

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
    this.alCambiar,
    this.formateadores,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (etiqueta != null) ...[
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
        TextFormField(
          controller: controlador,
          obscureText: ocultarTexto,
          keyboardType: tipoTeclado,
          validator: validador,
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
