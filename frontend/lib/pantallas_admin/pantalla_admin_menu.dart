import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import 'pantalla_admin_usuarios.dart';
import 'pantalla_admin_solicitudes.dart';
import 'pantalla_admin_notificaciones.dart';
import 'pantalla_admin_bienvenida.dart';

/// Figma: Menu principal administrador
class PantallaAdminMenu extends StatelessWidget {
  const PantallaAdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 8, 24, 20 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'ADMIN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ColoresApp.textoContexto,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hola, administrador',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
                height: 1.18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Gestiona la aplicación desde aquí',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _tarjeta(
                            context,
                            icono: Icons.people_outline_rounded,
                            colorIcono: const Color(0xFF5B8DEF),
                            fondoIcono: const Color(0xFFE8F0FE),
                            titulo: 'Usuarios',
                            sub: 'Ver y gestionar usuarios',
                            destino: const PantallaAdminUsuarios(),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _tarjeta(
                            context,
                            icono: Icons.account_balance_wallet_outlined,
                            colorIcono: const Color(0xFF3CB371),
                            fondoIcono: const Color(0xFFE8F8EF),
                            titulo: 'Préstamos',
                            sub: 'Aprobar o revisar solicitudes',
                            destino: const PantallaAdminSolicitudes(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _tarjeta(
                      context,
                      icono: Icons.notifications_none_rounded,
                      colorIcono: const Color(0xFF8B7CF6),
                      fondoIcono: const Color(0xFFF0EDFF),
                      titulo: 'Notificaciones',
                      sub: 'Enviar mensajes a usuarios',
                      destino: const PantallaAdminNotificaciones(),
                      anchoCompleto: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PantallaAdminBienvenida(),
                    ),
                    (_) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF0F2),
                  side: const BorderSide(color: Color(0xFFF0D5DB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBC4351),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjeta(
    BuildContext context, {
    required IconData icono,
    required Color colorIcono,
    required Color fondoIcono,
    required String titulo,
    required String sub,
    required Widget destino,
    bool anchoCompleto = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destino),
        );
      },
      child: Container(
        width: anchoCompleto ? double.infinity : null,
        height: 174,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE1E8F3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A17243C),
              blurRadius: 16,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: fondoIcono,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icono, color: colorIcono, size: 26),
            ),
            const Spacer(),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF66758D),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
