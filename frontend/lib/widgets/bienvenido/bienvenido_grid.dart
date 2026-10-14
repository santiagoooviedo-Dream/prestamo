import 'package:flutter/material.dart';
import '../../core/colores.dart';

class BienvenidoGrid extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onSolicitar;
  final VoidCallback onSoporte;
  final VoidCallback onHistorial;
  final VoidCallback onPerfil;

  const BienvenidoGrid({
    super.key,
    required this.width,
    required this.height,
    required this.onSolicitar,
    required this.onSoporte,
    required this.onHistorial,
    required this.onPerfil,
  });

  @override
  Widget build(BuildContext context) {
    final cardW = width * 0.385;
    final cardH = height * 0.215;
    final gapX = width * 0.07;
    final left = width * 0.09;
    final top = height * 0.205;
    final gapY = height * 0.033;

    return Stack(
      children: [
        Positioned(
          left: left,
          top: top,
          width: cardW,
          height: cardH,
          child: _MenuCard(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Solicitar\nprestamo',
            onTap: onSolicitar,
          ),
        ),
        Positioned(
          left: left + cardW + gapX,
          top: top,
          width: cardW,
          height: cardH,
          child: _MenuCard(
            icon: Icons.headset_mic_rounded,
            label: 'Soporte',
            onTap: onSoporte,
          ),
        ),
        Positioned(
          left: left,
          top: top + cardH + gapY,
          width: cardW,
          height: cardH,
          child: _MenuCard(
            icon: Icons.access_time_rounded,
            label: 'Historial',
            onTap: onHistorial,
          ),
        ),
        Positioned(
          left: left + cardW + gapX,
          top: top + cardH + gapY,
          width: cardW,
          height: cardH,
          child: _MenuCard(
            icon: Icons.person_rounded,
            label: 'Mi perfil',
            onTap: onPerfil,
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colores.blanco,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colores.azul.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: Colores.azul,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poly_Regular',
                  color: Colores.negro,
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
