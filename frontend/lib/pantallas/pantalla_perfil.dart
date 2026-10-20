import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_cerrar_sesion.dart';
import 'pantalla_cambiar_correo.dart';
import 'pantalla_notificaciones.dart';
import 'pantalla_cambiar_foto.dart';
import 'pantalla_cambiar_contrasena_perfil.dart';
import 'pantalla_estado_cuenta.dart';
import 'pantalla_inicio.dart';

class PantallaPerfil extends StatelessWidget {
  const PantallaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

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
                      alPresionar: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const PantallaInicio()),
                          (_) => false,
                        );
                      },
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
                    onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaCambiarFoto()),
                  ),
                    child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEDF3FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'JS',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF285FE8),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF285FE8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 14, color: Colors.white),
                      ),
                    ],
                  ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Nombre usuario',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'correo@ejemplo.com',
                    style: TextStyle(fontSize: 13, color: Color(0xFF66758D)),
                  ),
                  const SizedBox(height: 28),
                  _Opcion(
                    icono: Icons.lock_outline_rounded,
                    titulo: 'Cambiar contraseña',
                    onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaCambiarContrasenaPerfil()),
                  ),
                  ),
                  const SizedBox(height: 10),
                  _Opcion(
                    icono: Icons.mail_outline_rounded,
                    titulo: 'Cambiar correo',
                    onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaCambiarCorreo()),
                  ),
                  ),
                  const SizedBox(height: 10),
                  _Opcion(
                    icono: Icons.bar_chart_rounded,
                    titulo: 'Estado de cuenta',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaEstadoCuenta())),
                  ),
                  const SizedBox(height: 10),
                  _Opcion(
                    icono: Icons.notifications_none_rounded,
                    titulo: 'Notificaciones',
                    onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaNotificaciones()),
                  ),
                  ),
                  const SizedBox(height: 10),
                  _Opcion(
                    icono: Icons.logout_rounded,
                    titulo: 'Cerrar sesión',
                    peligro: true,
                    onTap: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaCerrarSesion()),
                  );
                    },
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
}

class _Opcion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool peligro;
  final VoidCallback onTap;

  const _Opcion({
    required this.icono,
    required this.titulo,
    required this.onTap,
    this.peligro = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = peligro ? const Color(0xFFBC4351) : const Color(0xFF17243C);
    final bg = peligro ? const Color(0xFFFFF0F2) : const Color(0xFFEDF3FF);
    final ic = peligro ? const Color(0xFFBC4351) : const Color(0xFF285FE8);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E8F3)),
          boxShadow: const [
            BoxShadow(color: Color(0x0D17243C), blurRadius: 16, offset: Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icono, size: 20, color: ic),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                titulo,
                style: TextStyle(fontSize: 14, color: color),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A0B3)),
          ],
        ),
      ),
    );
  }
}
