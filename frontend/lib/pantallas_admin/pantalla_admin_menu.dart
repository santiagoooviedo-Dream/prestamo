import 'package:flutter/material.dart';

import '../utilidades/abrir_manual.dart';

import '../nucleo/colores_app.dart';
import '../nucleo/indicadores_admin.dart';
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
  IndicadoresAdminResult? _indicadores;

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

  Future<void> _cargarIndicadores() async {
    try {
      final indicadores = await IndicadoresAdmin.cargar();
      if (mounted) setState(() => _indicadores = indicadores);
    } catch (error) {
      debugPrint(
        'No se pudieron cargar los pendientes del administrador: $error',
      );
    }
  }

  Future<void> _abrir(Widget destino) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => destino));
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
                color: ColoresApp.textoPrincipal,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Gestiona la aplicación desde aquí',
              style: TextStyle(fontSize: 15, color: ColoresApp.textoSecundario),
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
                            colorIcono: ColoresApp.primarioClaro,
                            fondoIcono: ColoresApp.fondoSeleccionado,
                            titulo: 'Usuarios',
                            sub: 'Ver y gestionar usuarios',
                            mostrarPunto: _indicadores?.usuarios == true,
                            onTap: () => _abrir(const PantallaAdminUsuarios()),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _TarjetaMenu(
                            icono: Icons.account_balance_wallet_outlined,
                            colorIcono: ColoresApp.exitoMedio,
                            fondoIcono: ColoresApp.exitoClaro4,
                            titulo: 'Préstamos',
                            sub: 'Aprobar o revisar solicitudes',
                            mostrarPunto: _indicadores?.prestamos == true,
                            onTap: () =>
                                _abrir(const PantallaAdminSolicitudes()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _TarjetaMenu(
                      icono: Icons.notifications_none_rounded,
                      colorIcono: ColoresApp.lila,
                      fondoIcono: ColoresApp.fondoLila,
                      titulo: 'Notificaciones',
                      sub: 'Enviar mensajes a usuarios',
                      anchoCompleto: true,
                      onTap: () => _abrir(const PantallaAdminNotificaciones()),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  abrirManualPdf(
                    context,
                    assetPath: 'assets/manuales/manual_administrador.pdf',
                    titulo: 'Manual de administrador',
                  );
                },
                icon: const Icon(Icons.menu_book_outlined, size: 20),
                label: const Text('Manual de administrador'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: ColoresApp.fondoAzulMuyClaro,
                  side: const BorderSide(color: ColoresApp.bordeSuave3),
                  foregroundColor: ColoresApp.primarioProfundo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
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
                  foregroundColor: ColoresApp.errorRosado,
                  side: const BorderSide(color: ColoresApp.errorBorde2),
                  backgroundColor: ColoresApp.errorFondo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
          color: ColoresApp.blanco,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColoresApp.bordeTarjeta),
          boxShadow: const [
            BoxShadow(
              color: ColoresApp.sombraMuySuave,
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
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 11,
                      color: ColoresApp.textoSecundario,
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
                    color: ColoresApp.errorFuerte,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColoresApp.blanco, width: 2),
                    boxShadow: const [
                      BoxShadow(color: ColoresApp.sombraError, blurRadius: 6),
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
