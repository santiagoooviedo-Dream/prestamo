import 'package:flutter/material.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/barra_navegacion.dart';
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
                        child: _TarjetaAcceso(
                          icono: Icons.account_balance_wallet_rounded,
                          titulo: 'Solicitar\npréstamo',
                          subtitulo: 'Comienza una solicitud',
                          onTap: () =>
                              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaSolicitarPrestamo()),
                  ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _TarjetaAcceso(
                          icono: Icons.headset_mic_rounded,
                          titulo: 'Comunicate \ncon nosotros',
                          subtitulo: 'Estamos para ayudarte',
                          onTap: () =>
                              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaAsistenteVirtual()),
                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _TarjetaAcceso(
                          icono: Icons.history_rounded,
                          titulo: 'Historial',
                          subtitulo: 'Consulta tus préstamos',
                          onTap: () =>
                              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaMisPrestamos()),
                  ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _TarjetaAcceso(
                          icono: Icons.person_rounded,
                          titulo: 'Mi perfil',
                          subtitulo: 'Administra tu cuenta',
                          onTap: () =>
                              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaPerfil()),
                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const AvisoSeguridad(
                    texto:
                        'Tu seguridad es importante para nosotros. Cuidamos tu información en cada paso.',
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

class _TarjetaAcceso extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _TarjetaAcceso({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 174,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE1E8F3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D17243C),
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
                color: const Color(0xFFEDF3FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icono, color: const Color(0xFF285FE8), size: 28),
            ),
            const Spacer(),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitulo,
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
