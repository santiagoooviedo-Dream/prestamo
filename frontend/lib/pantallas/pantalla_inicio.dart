import 'package:flutter/material.dart';

import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/inicio/tarjeta_acceso.dart';
import 'pantalla_asistente_virtual.dart';
import 'pantalla_perfil.dart';
import 'pantalla_mis_prestamos.dart';
import 'pantalla_solicitar_prestamo.dart';

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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TP / Préstamos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF285FE8),
                        ),
                      ),
                      Text(
                        'INICIO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF41618E),
                          letterSpacing: 0.4,
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
                        colors: [Color(0xFFE1EBFF), Color(0xFFF0F5FF)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD5E3FF)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Bienvenido!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF17243C),
                            height: 1.18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '¿Qué te gustaría hacer hoy?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF66758D),
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
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TarjetaAcceso(
                          icono: Icons.history_rounded,
                          titulo: 'Historial',
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
