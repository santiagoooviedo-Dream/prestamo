import 'package:flutter/material.dart';

import '../../models/contrasena_model.dart';
import '../../nucleo/colores_app.dart';
import '../comunes/campo_texto.dart';
import '../comunes/requisito_contrasena.dart';

class FormularioRegistro extends StatelessWidget {
  final TextEditingController cedula;
  final TextEditingController nombres;
  final TextEditingController apellidos;
  final TextEditingController correo;
  final TextEditingController telefono;
  final TextEditingController contrasena;
  final bool ocultar;
  final VoidCallback alAlternarVisibilidad;

  const FormularioRegistro({
    super.key,
    required this.cedula,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.telefono,
    required this.contrasena,
    required this.ocultar,
    required this.alAlternarVisibilidad,
  });

  @override
  Widget build(BuildContext context) {
    final clave = contrasena.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CampoTexto(
          etiqueta: 'Cédula',
          pista: 'Número de cédula',
          controlador: cedula,
          tipoTeclado: TextInputType.number,
          iconoIzquierdo: const Icon(
            Icons.badge_outlined,
            size: 20,
            color: ColoresApp.textoSuave,
          ),
        ),
        const SizedBox(height: 14),
        CampoTexto(
          etiqueta: 'Nombres',
          pista: 'Tus nombres',
          controlador: nombres,
          iconoIzquierdo: const Icon(
            Icons.person_outline_rounded,
            size: 20,
            color: ColoresApp.textoSuave,
          ),
        ),
        const SizedBox(height: 14),
        CampoTexto(
          etiqueta: 'Apellidos',
          pista: 'Tus apellidos',
          controlador: apellidos,
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
          controlador: correo,
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
          controlador: telefono,
          tipoTeclado: TextInputType.phone,
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
          controlador: contrasena,
          ocultarTexto: ocultar,
          iconoIzquierdo: const Icon(
            Icons.lock_outline_rounded,
            size: 20,
            color: ColoresApp.textoSuave,
          ),
          iconoDerecho: IconButton(
            onPressed: alAlternarVisibilidad,
            icon: Icon(
              ocultar
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
