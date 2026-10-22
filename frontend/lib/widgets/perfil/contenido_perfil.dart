import 'package:flutter/material.dart';

import '../../nucleo/colores_app.dart';
import '../../widgets/comunes/barra_navegacion.dart';
import '../../widgets/comunes/boton_volver.dart';
import '../../pantallas/pantalla_cambiar_contrasena_perfil.dart';
import '../../pantallas/pantalla_cambiar_correo.dart';
import '../../pantallas/pantalla_cambiar_foto.dart';
import '../../pantallas/pantalla_cerrar_sesion.dart';
import '../../pantallas/pantalla_estado_cuenta.dart';
import '../../pantallas/pantalla_inicio.dart';
import '../../pantallas/pantalla_notificaciones.dart';

class ContenidoPerfil extends StatelessWidget {
  final Map<String, dynamic> usuario;

  const ContenidoPerfil({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final nombre = [
      usuario['nombre'],
      usuario['apellido'],
    ].whereType<String>().where((parte) => parte.isNotEmpty).join(' ');
    final correo = usuario['correo']?.toString() ?? '';
    final iniciales = nombre
        .split(' ')
        .where((parte) => parte.isNotEmpty)
        .take(2)
        .map((parte) => parte[0].toUpperCase())
        .join();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BotonVolver(
                        alPresionar: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PantallaInicio(),
                          ),
                          (_) => false,
                        ),
                      ),
                      Text(
                        'MI PERFIL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: ColoresApp.textoContexto,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => _abrir(context, const PantallaCambiarFoto()),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: const Color(0xFFEDF3FF),
                      child: Text(
                        iniciales.isEmpty ? 'U' : iniciales,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF285FE8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    nombre.isEmpty ? 'Mi cuenta' : nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    correo,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF66758D),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _OpcionPerfil(
                    icono: Icons.lock_outline_rounded,
                    titulo: 'Cambiar contraseña',
                    alPresionar: () => _abrir(
                      context,
                      const PantallaCambiarContrasenaPerfil(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _OpcionPerfil(
                    icono: Icons.mail_outline_rounded,
                    titulo: 'Cambiar correo',
                    alPresionar: () =>
                        _abrir(context, const PantallaCambiarCorreo()),
                  ),
                  const SizedBox(height: 10),
                  _OpcionPerfil(
                    icono: Icons.bar_chart_rounded,
                    titulo: 'Estado de cuenta',
                    alPresionar: () =>
                        _abrir(context, const PantallaEstadoCuenta()),
                  ),
                  const SizedBox(height: 10),
                  _OpcionPerfil(
                    icono: Icons.notifications_none_rounded,
                    titulo: 'Notificaciones',
                    alPresionar: () =>
                        _abrir(context, const PantallaNotificaciones()),
                  ),
                  const SizedBox(height: 10),
                  _OpcionPerfil(
                    icono: Icons.logout_rounded,
                    titulo: 'Cerrar sesión',
                    peligro: true,
                    alPresionar: () =>
                        _abrir(context, const PantallaCerrarSesion()),
                  ),
                ],
              ),
            ),
          ),
          const BarraNavegacion(actual: DestinoNav.perfil),
        ],
      ),
    );
  }

  void _abrir(BuildContext context, Widget pantalla) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));
  }
}

class _OpcionPerfil extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool peligro;
  final VoidCallback alPresionar;

  const _OpcionPerfil({
    required this.icono,
    required this.titulo,
    required this.alPresionar,
    this.peligro = false,
  });

  @override
  Widget build(BuildContext context) {
    final texto = peligro ? const Color(0xFFBC4351) : const Color(0xFF17243C);
    final fondo = peligro ? const Color(0xFFFFF0F2) : const Color(0xFFEDF3FF);
    final acento = peligro ? const Color(0xFFBC4351) : const Color(0xFF285FE8);
    return GestureDetector(
      onTap: alPresionar,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E8F3)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: fondo,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icono, size: 20, color: acento),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(titulo, style: TextStyle(fontSize: 14, color: texto)),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A0B3)),
          ],
        ),
      ),
    );
  }
}
