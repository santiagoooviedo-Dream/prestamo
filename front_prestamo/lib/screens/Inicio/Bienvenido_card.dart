import 'package:flutter/material.dart';
import '../../../core/colores.dart';

class BienvenidaCard extends StatelessWidget {
  const BienvenidaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECEE),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'BIENVENIDO',
            style: TextStyle(
              fontFamily: "Poly",
              color: Colores.negro,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Accede a tus préstamos de forma\n'
            'rápida y segura',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 85),
          _LoginContainer(),
        ],
      ),
    );
  }
}

class _LoginContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 45),
      decoration: BoxDecoration(
        color: const Color(0xFFC7D0E6),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          Container(
            height: 41,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF778AD0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(
              fontFamily: "Poly_Regular",
                color: Colores.negro,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '¿No tienes cuenta?crear',
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.azul,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}