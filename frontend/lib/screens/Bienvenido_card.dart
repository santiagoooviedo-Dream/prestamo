import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../core/colores.dart';

class BienvenidaCard extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback onLogout;

  const BienvenidaCard({
    super.key,
    required this.usuario,
    required this.onLogout,
  });

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
          Text(
            'BIENVENIDO${usuario.nombre.isEmpty ? '' : ', ${usuario.nombre.toUpperCase()}'}',
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
          _LogoutContainer(onLogout: onLogout),
        ],
      ),
    );
  }
}

class _LogoutContainer extends StatelessWidget {
  final VoidCallback onLogout;

  const _LogoutContainer({required this.onLogout});

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
            child: TextButton(
              onPressed: onLogout,
              style: TextButton.styleFrom(
                foregroundColor: Colores.negro,
                minimumSize: const Size.fromHeight(41),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontFamily: "Poly_Regular",
                  color: Colores.negro,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}