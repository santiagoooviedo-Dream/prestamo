import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class LogoBienvenida extends StatelessWidget {
  const LogoBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: ColoresApp.fondoInicio,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/imagenes/logo_tp.png',
            width: 130,
            height: 110,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: ColoresApp.primario,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text(
                  'TP',
                  style: TextStyle(
                    color: ColoresApp.blanco,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'BIENVENIDO',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColoresApp.primario,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
