import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../services/notificaciones_push_service.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_bienvenida.dart';

class PantallaEliminarCuenta extends StatefulWidget {
  const PantallaEliminarCuenta({super.key});

  @override
  State<PantallaEliminarCuenta> createState() => _PantallaEliminarCuentaState();
}

class _PantallaEliminarCuentaState extends State<PantallaEliminarCuenta> {
  bool _eliminando = false;
  String? _bloqueoEliminacion;

  Future<void> _eliminarCuenta() async {
    setState(() => _eliminando = true);
    try {
      await ApiService.eliminarCuenta();
      await NotificacionesPushService.detener();
      await ApiService.cerrarSesion();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PantallaBienvenida()),
        (_) => false,
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _eliminando = false;
        if (error.statusCode == 409) {
          _bloqueoEliminacion = error.mensaje;
        }
      });
      if (error.statusCode != 409) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.mensaje)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return PopScope(
      canPop: !_eliminando,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.fromLTRB(24, top + 6, 24, 24 + bottom),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BotonVolver(
                    alPresionar: () {
                      if (!_eliminando) Navigator.pop(context);
                    },
                  ),
                  Text(
                    'MI CUENTA / ELIMINAR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoContexto,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F2),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF4C9CE), width: 6),
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  size: 48,
                  color: Color(0xFFBC4351),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                '¿Eliminar tu cuenta?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF17243C),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Esta acción es permanente. Si confirmas, se eliminará tu cuenta y volverás a la pantalla de bienvenida.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF66758D),
                    height: 1.5,
                  ),
                ),
              ),
              if (_bloqueoEliminacion != null) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF4C9CE)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFFBC4351),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _bloqueoEliminacion!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8F303B),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              _OpcionConfirmacion(
                icono: Icons.person_outline_rounded,
                titulo: 'No, volver',
                subtitulo: 'Conservar mi cuenta',
                alPresionar: _eliminando ? null : () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              _OpcionConfirmacion(
                icono: Icons.delete_forever_rounded,
                titulo: _bloqueoEliminacion == null
                    ? 'Sí, eliminar mi cuenta'
                    : 'No se puede eliminar ahora',
                subtitulo: _bloqueoEliminacion == null
                    ? 'Esta acción no se puede deshacer'
                    : 'Contacta con soporte para resolverlo',
                peligro: _bloqueoEliminacion == null,
                bloqueado: _bloqueoEliminacion != null,
                cargando: _eliminando,
                alPresionar: _eliminando || _bloqueoEliminacion != null
                    ? null
                    : _eliminarCuenta,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _OpcionConfirmacion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final bool peligro;
  final bool bloqueado;
  final bool cargando;
  final VoidCallback? alPresionar;

  const _OpcionConfirmacion({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.alPresionar,
    this.peligro = false,
    this.bloqueado = false,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = bloqueado
        ? const Color(0xFF66758D)
        : peligro
        ? const Color(0xFFBC4351)
        : const Color(0xFF17243C);
    final fondo = bloqueado
        ? const Color(0xFFF1F4F8)
        : peligro
        ? const Color(0xFFFFF0F2)
        : const Color(0xFFEDF3FF);
    final acento = bloqueado
        ? const Color(0xFF8190A5)
        : peligro
        ? const Color(0xFFBC4351)
        : const Color(0xFF285FE8);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: alPresionar,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1E8F3)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: fondo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: cargando
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: acento,
                        ),
                      )
                    : Icon(icono, size: 22, color: acento),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitulo,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF66758D),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                bloqueado ? Icons.lock_outline_rounded : Icons.chevron_right,
                color: color.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
