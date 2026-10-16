import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, top + 8, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'TP / Préstamos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF285FE8),
                  ),
                ),
                Text(
                  'INICIO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
                height: 1.15,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '¿Qué te gustaría hacer hoy?',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
              ),
            ),
            const SizedBox(height: 28),

            // Grid 2x2
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.05,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _TarjetaAccion(
                    icono: Icons.account_balance_wallet_rounded,
                    titulo: 'Solicitar\npréstamo',
                    subtitulo: 'Comienza una solicitud',
                    onTap: () {},
                  ),
                  _TarjetaAccion(
                    icono: Icons.headset_mic_rounded,
                    titulo: 'Soporte',
                    subtitulo: 'Estamos para ayudarte',
                    onTap: () {},
                  ),
                  _TarjetaAccion(
                    icono: Icons.history_rounded,
                    titulo: 'Historial',
                    subtitulo: 'Consulta tus préstamos',
                    onTap: () {},
                  ),
                  _TarjetaAccion(
                    icono: Icons.person_rounded,
                    titulo: 'Mi perfil',
                    subtitulo: 'Administra tu cuenta',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Aviso seguridad
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, size: 18, color: Color(0xFF285FE8)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tu seguridad es importante para nosotros. Cuidamos tu información en cada paso.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5B7AA8),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
        ),
        padding: EdgeInsets.only(bottom: bottom > 0 ? bottom : 8, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icono: Icons.home_rounded,
              etiqueta: 'Inicio',
              activo: _indice == 0,
              onTap: () => setState(() => _indice = 0),
            ),
            _NavItem(
              icono: Icons.account_balance_wallet_outlined,
              etiqueta: 'Préstamos',
              activo: _indice == 1,
              onTap: () => setState(() => _indice = 1),
            ),
            _NavItem(
              icono: Icons.chat_bubble_outline_rounded,
              etiqueta: 'Soporte',
              activo: _indice == 2,
              onTap: () => setState(() => _indice = 2),
            ),
            _NavItem(
              icono: Icons.person_outline_rounded,
              etiqueta: 'Perfil',
              activo: _indice == 3,
              onTap: () => setState(() => _indice = 3),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaAccion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _TarjetaAccion({
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8EEF8)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A17243C),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, size: 24, color: const Color(0xFF285FE8)),
            ),
            const Spacer(),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitulo,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF66758D),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final bool activo;
  final VoidCallback onTap;

  const _NavItem({
    required this.icono,
    required this.etiqueta,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = activo ? const Color(0xFF285FE8) : const Color(0xFF9AA6B8);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 24, color: color),
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