import 'package:flutter/material.dart';

import '../../models/notificacion_model.dart';
import '../../pantallas/pantalla_inicio.dart';
import '../../pantallas/pantalla_mis_prestamos.dart';
import '../../pantallas/pantalla_asistente_virtual.dart';
import '../../pantallas/pantalla_perfil.dart';
import '../../nucleo/colores_app.dart';

enum DestinoNav { inicio, prestamos, soporte, perfil }

class BarraNavegacion extends StatefulWidget {
  final DestinoNav actual;

  const BarraNavegacion({super.key, required this.actual});

  @override
  State<BarraNavegacion> createState() => _BarraNavegacionState();
}

class _BarraNavegacionState extends State<BarraNavegacion> {
  @override
  void initState() {
    super.initState();
    _cargarNotif();
  }

  Future<void> _cargarNotif() async {
    try {
      await EstadoNotificacionesUsuario.cargar();
    } catch (error) {
      debugPrint('No se pudo consultar el estado de notificaciones: $error');
    }
  }

  void _ir(BuildContext context, DestinoNav destino, Widget pantalla) {
    if (destino == widget.actual) return;
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => pantalla,
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        8,
        10,
        8,
        10 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: ColoresApp.blanco,
        border: Border(top: BorderSide(color: ColoresApp.bordeTarjeta)),
      ),
      child: Row(
        children: [
          _Item(
            icono: Icons.home_rounded,
            etiqueta: 'Inicio',
            activo: widget.actual == DestinoNav.inicio,
            onTap: () =>
                _ir(context, DestinoNav.inicio, const PantallaInicio()),
          ),
          _Item(
            icono: Icons.account_balance_wallet_outlined,
            etiqueta: 'Préstamos',
            activo: widget.actual == DestinoNav.prestamos,
            onTap: () => _ir(
              context,
              DestinoNav.prestamos,
              const PantallaMisPrestamos(),
            ),
          ),
          _Item(
            icono: Icons.chat_bubble_outline_rounded,
            etiqueta: 'Soporte',
            activo: widget.actual == DestinoNav.soporte,
            onTap: () => _ir(
              context,
              DestinoNav.soporte,
              const PantallaAsistenteVirtual(),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: EstadoNotificacionesUsuario.hayNoLeidas,
            builder: (context, hayNoLeidas, _) => _Item(
              icono: Icons.person_outline_rounded,
              etiqueta: 'Perfil',
              activo: widget.actual == DestinoNav.perfil,
              mostrarPunto: hayNoLeidas,
              onTap: () =>
                  _ir(context, DestinoNav.perfil, const PantallaPerfil()),
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final bool activo;
  final bool mostrarPunto;
  final VoidCallback onTap;

  const _Item({
    required this.icono,
    required this.etiqueta,
    required this.activo,
    required this.onTap,
    this.mostrarPunto = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = activo ? ColoresApp.primario : ColoresApp.textoSecundario;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 28,
              decoration: BoxDecoration(
                gradient: activo
                    ? const LinearGradient(
                        colors: [ColoresApp.decoracionAzul, ColoresApp.fondoInicio],
                      )
                    : null,
                borderRadius: BorderRadius.circular(14),
                border: activo
                    ? Border.all(color: ColoresApp.chipAzul4)
                    : null,
              ),
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Icon(icono, size: 22, color: color),
                      if (mostrarPunto)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: ColoresApp.errorFuerte,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              etiqueta,
              style: TextStyle(
                fontSize: 11,
                fontWeight: activo ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
