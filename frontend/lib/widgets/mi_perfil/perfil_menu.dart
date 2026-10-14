import 'package:flutter/material.dart';
import '../../core/colores.dart';

class PerfilMenu extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onCambiarContrasena;
  final VoidCallback onCambiarCorreo;
  final VoidCallback onEstadoCuenta;
  final VoidCallback onNotificaciones;
  final VoidCallback onCerrarSesion;

  const PerfilMenu({
    super.key,
    required this.width,
    required this.height,
    required this.onCambiarContrasena,
    required this.onCambiarCorreo,
    required this.onEstadoCuenta,
    required this.onNotificaciones,
    required this.onCerrarSesion,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _Item(Icons.person_outline_rounded, 'Cambio de contraseña',
          onCambiarContrasena, false),
      _Item(Icons.mail_outline_rounded, 'Cambio de correo', onCambiarCorreo,
          false),
      _Item(Icons.verified_user_outlined, 'Estado de la cuenta', onEstadoCuenta,
          false),
      _Item(Icons.notifications_none_rounded, 'Notificaciones',
          onNotificaciones, false),
      _Item(Icons.logout_rounded, 'Cerrar sesion', onCerrarSesion, true),
    ];

    return Positioned(
      left: width * 0.07,
      right: width * 0.07,
      top: height * 0.40,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i == items.length - 1) SizedBox(height: height * 0.035),
            _MenuTile(item: items[i]),
            if (i < items.length - 1) SizedBox(height: height * 0.012),
          ],
        ],
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLogout;
  const _Item(this.icon, this.label, this.onTap, this.isLogout);
}

class _MenuTile extends StatelessWidget {
  final _Item item;

  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: item.isLogout
              ? const Color(0xFFF5E8E8)
              : const Color(0xFFE8ECF0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 20,
              color: item.isLogout ? const Color(0xFFE85A5A) : Colores.azul,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontFamily: "Poly_Regular",
                  color: item.isLogout ? const Color(0xFFE85A5A) : Colores.negro,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
