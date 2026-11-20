import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class BotonPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback? alPresionar;
  final bool cargando;

  const BotonPrimario({
    super.key,
    required this.texto,
    this.alPresionar,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    final activo = alPresionar != null && !cargando;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: activo ? alPresionar : null,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: activo
                    ? const [ColoresApp.primario, ColoresApp.primarioMasOscuro]
                    : [
                        ColoresApp.primario.withValues(alpha: 0.5),
                        ColoresApp.primarioMasOscuro.withValues(alpha: 0.5),
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: activo
                  ? const [
                      BoxShadow(
                        color: ColoresApp.sombraBoton,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: cargando
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: ColoresApp.blanco,
                      ),
                    )
                  : Text(
                      texto,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ColoresApp.blanco, // SIEMPRE blanco
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
