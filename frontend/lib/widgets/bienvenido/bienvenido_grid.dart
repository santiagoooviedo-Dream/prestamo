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
    final cardH = height * 0.175;
    final gapX = width * 0.035;
    final left = (width - cardW * 2 - gapX) / 2;
    final top1 = height * 0.195;
    final top2 = top1 + cardH + height * 0.022;

    return Stack(
      children: [
        Positioned(
          left: left,
          top: top1,
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
          top: top1,
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
          top: top2,
          width: cardW,
          height: cardH,
          child: _MenuCard(
            icon: Icons.access_time_filled_rounded,
            label: 'Historial',
            onTap: onHistorial,
          ),
        ),
        Positioned(
          left: left + cardW + gapX,
          top: top2,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colores.blanco,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF045CFF).withOpacity(0.10),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colores.azul),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Poly_Regular",
                color: Colores.negro,
                fontSize: 13,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
