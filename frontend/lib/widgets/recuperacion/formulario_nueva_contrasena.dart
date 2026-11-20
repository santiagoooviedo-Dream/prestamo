import 'package:flutter/material.dart';

import '../../models/contrasena_model.dart';
import '../../nucleo/colores_app.dart';
import '../comunes/campo_texto.dart';
import '../comunes/requisito_contrasena.dart';

class FormularioNuevaContrasena extends StatelessWidget {
  final TextEditingController claveCtrl;
  final TextEditingController confirmarCtrl;
  final bool ocultar;
  final bool ocultarConfirmar;
  final bool coinciden;
  final int puntos;
  final VoidCallback alAlternarClave;
  final VoidCallback alAlternarConfirmacion;

  const FormularioNuevaContrasena({
    super.key,
    required this.claveCtrl,
    required this.confirmarCtrl,
    required this.ocultar,
    required this.ocultarConfirmar,
    required this.coinciden,
    required this.puntos,
    required this.alAlternarClave,
    required this.alAlternarConfirmacion,
  });

  @override
  Widget build(BuildContext context) {
    final clave = claveCtrl.text;
    final color = switch (puntos) {
      0 || 1 => ColoresApp.error,
      2 => ColoresApp.advertencia,
      3 => ColoresApp.primarioAlt,
      _ => ColoresApp.exito,
    };
    final nivel = switch (puntos) {
      0 || 1 => 'Débil',
      2 => 'Media',
      3 => 'Buena',
      _ => 'Fuerte',
    };
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Una nueva contraseña',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: ColoresApp.textoPrincipal,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crea una contraseña segura para proteger tu cuenta.',
            style: TextStyle(
              fontSize: 15,
              color: ColoresApp.textoSecundario,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.5,
              minHeight: 4,
              backgroundColor: ColoresApp.bordeSuave,
              valueColor: AlwaysStoppedAnimation(ColoresApp.primario),
            ),
          ),
          const SizedBox(height: 24),
          CampoTexto(
            etiqueta: 'Nueva contraseña',
            pista: 'Crea una contraseña',
            controlador: claveCtrl,
            ocultarTexto: ocultar,
            iconoIzquierdo: const Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: ColoresApp.textoSuave,
            ),
            iconoDerecho: IconButton(
              onPressed: alAlternarClave,
              icon: Icon(
                ocultar
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: ColoresApp.textoSuave,
              ),
            ),
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 10),
          Text(
            'Seguridad: $nivel',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: puntos / 4,
              minHeight: 4,
              backgroundColor: ColoresApp.bordeSuave,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Confirma tu contraseña',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 14),
          CampoTexto(
            etiqueta: null,
            pista: 'Repite la contraseña',
            controlador: confirmarCtrl,
            ocultarTexto: ocultarConfirmar,
            iconoIzquierdo: const Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: ColoresApp.textoSuave,
            ),
            iconoDerecho: IconButton(
              onPressed: alAlternarConfirmacion,
              icon: Icon(
                ocultarConfirmar
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: ColoresApp.textoSuave,
              ),
            ),
          ),
          if (confirmarCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  coinciden ? Icons.check_circle : Icons.error_outline,
                  size: 18,
                  color: coinciden
                      ? ColoresApp.exito
                      : ColoresApp.error,
                ),
                const SizedBox(width: 8),
                Text(
                  coinciden
                      ? 'Las contraseñas coinciden'
                      : 'Las contraseñas no coinciden',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: coinciden
                        ? ColoresApp.exitoOscuro
                        : ColoresApp.errorOscuro,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
