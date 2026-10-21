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
                    ? const [Color(0xFF285FE8), Color(0xFF214EC4)]
                    : [
                        const Color(0xFF285FE8).withValues(alpha: 0.5),
                        const Color(0xFF214EC4).withValues(alpha: 0.5),
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: activo
                  ? const [
                      BoxShadow(
                        color: Color(0x29285FE8),
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
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      texto,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF), // SIEMPRE blanco
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}