import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import 'pantalla_admin_usuarios.dart';
import 'pantalla_admin_solicitudes.dart';
import 'pantalla_admin_notificaciones.dart';
import 'pantalla_admin_cerrar_sesion.dart';

class PantallaAdminMenu extends StatefulWidget {
  const PantallaAdminMenu({super.key});

  @override
  State<PantallaAdminMenu> createState() => _PantallaAdminMenuState();
}

class _PantallaAdminMenuState extends State<PantallaAdminMenu>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cargarIndicadores();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cargarIndicadores();
    }
  }

  Future<void> _cargarIndicadores() async {}

  Future<void> _abrir(Widget destino) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destino),
    );
    if (mounted) await _cargarIndicadores();
  }

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
            const SizedBox(height: 18),
            const Text(
              'Hola, administrador',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
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
                          child: _TarjetaMenu(
                            icono: Icons.people_outline_rounded,
                            colorIcono: const Color(0xFF5B8DEF),
                            fondoIcono: const Color(0xFFE8F0FE),
                            titulo: 'Usuarios',
                            sub: 'Ver y gestionar usuarios',
                            mostrarPunto: false,
                            onTap: () => _abrir(const PantallaAdminUsuarios()),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _TarjetaMenu(
                            icono: Icons.account_balance_wallet_outlined,
                            colorIcono: const Color(0xFF3CB371),
                            fondoIcono: const Color(0xFFE8F8EF),
                            titulo: 'Préstamos',
                            sub: 'Aprobar o revisar solicitudes',
                            mostrarPunto: false,
                            onTap: () =>
                                _abrir(const PantallaAdminSolicitudes()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _TarjetaMenu(
                      icono: Icons.notifications_none_rounded,
                      colorIcono: const Color(0xFF8B7CF6),
                      fondoIcono: const Color(0xFFF0EDFF),
                      titulo: 'Notificaciones',
                      sub: 'Enviar mensajes a usuarios',
                      anchoCompleto: true,
                      onTap: () =>
                          _abrir(const PantallaAdminNotificaciones()),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PantallaAdminCerrarSesion(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFBC4351),
                  side: const BorderSide(color: Color(0xFFF0C7CC)),
                  backgroundColor: const Color(0xFFFFF0F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaMenu extends StatelessWidget {
  final IconData icono;
  final Color colorIcono;
  final Color fondoIcono;
  final String titulo;
  final String sub;
  final VoidCallback onTap;
  final bool mostrarPunto;
  final bool anchoCompleto;

  const _TarjetaMenu({
    required this.icono,
    required this.colorIcono,
    required this.fondoIcono,
    required this.titulo,
    required this.sub,
    required this.onTap,
    this.mostrarPunto = false,
    this.anchoCompleto = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: anchoCompleto ? double.infinity : null,
        height: 174,
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
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
            if (mostrarPunto)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x55E53935),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
