import 'package:flutter/material.dart';

import '../../nucleo/api_service.dart';
import '../../pantallas/pantalla_inicio.dart';
import '../../pantallas/pantalla_mis_prestamos.dart';
import '../../pantallas/pantalla_asistente_virtual.dart';
import '../../pantallas/pantalla_perfil.dart';

enum DestinoNav { inicio, prestamos, soporte, perfil }

class BarraNavegacion extends StatefulWidget {
  final DestinoNav actual;

  const BarraNavegacion({super.key, required this.actual});

  @override
  State<BarraNavegacion> createState() => _BarraNavegacionState();
}

class _BarraNavegacionState extends State<BarraNavegacion> {
  bool _notifPendientes = false;

  @override
  void initState() {
    super.initState();
    _cargarNotif();
  }

  Future<void> _cargarNotif() async {
    try {
      final lista = await ApiService.obtenerNotificaciones();
      final hay = lista.any((n) {
        final leida = n['leida'];
        return leida != true && leida != 'true' && leida != 1;
      });
      if (mounted) setState(() => _notifPendientes = hay);
    } catch (_) {
      // Silencioso: si falla no mostramos punto
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
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE1E8F3))),
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
          _Item(
            icono: Icons.person_outline_rounded,
            etiqueta: 'Perfil',
            activo: widget.actual == DestinoNav.perfil,
            mostrarPunto: _notifPendientes,
            onTap: () =>
                _ir(context, DestinoNav.perfil, const PantallaPerfil()),
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
    final color = activo ? const Color(0xFF285FE8) : const Color(0xFF66758D);
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
                        colors: [Color(0xFFDCE8FF), Color(0xFFEDF3FF)],
                      )
                    : null,
                borderRadius: BorderRadius.circular(14),
                border: activo
                    ? Border.all(color: const Color(0xFFC5D8FF))
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
                              color: Color(0xFFE53935),
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
