import 'package:flutter/material.dart';
import '../../core/colores.dart';

class CrearFooter extends StatelessWidget {
  final double width;
  final double height;
  final bool aceptaTerminos;
  final ValueChanged<bool?> onAceptaTerminosChanged;
  final VoidCallback onCrearCuenta;
  final VoidCallback onIniciarSesion;
  final bool isLoading;

  const CrearFooter({
    super.key,
    required this.width,
    required this.height,
    required this.aceptaTerminos,
    required this.onAceptaTerminosChanged,
    required this.onCrearCuenta,
    required this.onIniciarSesion,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Checkbox + términos
        Positioned(
          left: width * 0.09,
          top: height * 0.72,
          child: Row(
            children: [
              Checkbox(
                value: aceptaTerminos,
                onChanged: onAceptaTerminosChanged,
                visualDensity: VisualDensity.compact,
                activeColor: Colores.azulSecundario,
              ),
              const Text(
                'Acepto los Terminos y condiciones',
                style: TextStyle(
                  fontFamily: "Poly_Regular",
                  color: Colores.negro,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        // Botón Crear cuenta
        Positioned(
          left: width * 0.07,
          right: width * 0.07,
          top: height * 0.78,
          height: height * 0.065,
          child: ElevatedButton(
            onPressed: isLoading ? null : onCrearCuenta,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colores.azulSecundario,
              foregroundColor: Colores.blanco,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colores.blanco,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Crear cuenta',
                    style: TextStyle(
                      fontFamily: "Poly_Regular",
                      fontSize: 16,
                    ),
                  ),
          ),
        ),

        // Ya tienes cuenta
        Positioned(
          left: 0,
          right: 0,
          top: height * 0.875,
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontFamily: "Poly_Regular",
                fontSize: 14,
                color: Colores.negro,
              ),
              children: [
                TextSpan(text: '¿Ya tienes cuenta? '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: onIniciarSesion,
                    child: const Text(
                      'Iniciar sesion',
                      style: TextStyle(
                        color: Colores.azul,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
