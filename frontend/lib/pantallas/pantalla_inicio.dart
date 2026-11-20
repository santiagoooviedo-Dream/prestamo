import 'package:flutter/material.dart';

import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/inicio/tarjeta_acceso.dart';
import 'pantalla_asistente_virtual.dart';
import 'pantalla_perfil.dart';
import 'pantalla_mis_prestamos.dart';
import 'pantalla_solicitar_prestamo.dart';
import 'pantalla_notificaciones.dart';
import '../models/notificacion_model.dart';
import '../widgets/comunes/punto_rojo.dart';
import '../nucleo/colores_app.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top + 10, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabecera
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Préstamos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ColoresApp.primario,
                        ),
                      ),
                      // Icono de notificaciones (mismo que en perfil)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PantallaNotificaciones(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ValueListenableBuilder<bool>(
                              valueListenable:
                                  EstadoNotificacionesUsuario.hayNoLeidas,
                              builder: (context, hayNoLeidas, _) {
                                return IconoConPunto(
                                  activo: hayNoLeidas,
                                  child: const Icon(
                                    Icons.notifications_none_rounded,
                                    size: 26,
                                    color: ColoresApp.textoContexto,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Banner bienvenida
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ColoresApp.chipAzul3, ColoresApp.fondoAzulClaro],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ColoresApp.chipAzul2),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Bienvenido!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: ColoresApp.textoPrincipal,
                            height: 1.18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '¿Qué te gustaría hacer hoy?',
                          style: TextStyle(
                            fontSize: 15,
                            color: ColoresApp.textoSecundario,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Grid 2x2
                  Row(
                    children: [
                      Expanded(
                        child: TarjetaAcceso(
                          icono: Icons.account_balance_wallet_rounded,
                          titulo: 'Solicitar\npréstamo',
                          subtitulo: 'Comienza una solicitud',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PantallaSolicitarPrestamo(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TarjetaAcceso(
                          icono: Icons.person_rounded,
                          titulo: 'Mi perfil',
                          subtitulo: 'Administra tu cuenta',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PantallaPerfil(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TarjetaAcceso(
                          icono: Icons.history_rounded,
                          titulo: 'Prestamos',
                          subtitulo: 'Consulta tus préstamos',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PantallaMisPrestamos(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TarjetaAcceso(
                          icono: Icons.headset_mic_rounded,
                          titulo: 'Comunicate con nosotros',
                          subtitulo: 'Estamos para ayudarte',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PantallaAsistenteVirtual(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const AvisoSeguridad(
                    texto: 'Tu seguridad es importante para nosotros. Cuidamos tu información en cada paso.',
                  ),
                ],
              ),
            ),
          ),
          const BarraNavegacion(actual: DestinoNav.inicio),
        ],
      ),
    );
  }
}
