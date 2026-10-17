import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_secundario.dart';
import '../widgets/comunes/boton_volver.dart';

class PantallaMetodoPago extends StatefulWidget {
  const PantallaMetodoPago({super.key});

  @override
  State<PantallaMetodoPago> createState() => _PantallaMetodoPagoState();
}

class _PantallaMetodoPagoState extends State<PantallaMetodoPago> {
  int _sel = 0; // 0 Nequi, 1 Efectivo

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 20 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'PAGOS / MÉTODO',
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
            const Text(
              'Método de pago',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona cómo quieres pagar tu cuota.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 28),
            _Opcion(
              icono: Icons.smartphone_outlined,
              titulo: 'Nequi',
              seleccionado: _sel == 0,
              onTap: () => setState(() => _sel = 0),
            ),
            const SizedBox(height: 12),
            _Opcion(
              icono: Icons.payments_outlined,
              titulo: 'Efectivo',
              seleccionado: _sel == 1,
              onTap: () => setState(() => _sel = 1),
            ),
            const SizedBox(height: 20),
            const AvisoSeguridad(
              texto: 'Tus datos de pago están protegidos.',
            ),
            const Spacer(),
            BotonPrimario(
              texto: 'Continuar',
              alPresionar: () {
                Navigator.pushNamed(
                  context,
                  '/confirmar-pago',
                  arguments: _sel == 0 ? 'Nequi' : 'Efectivo',
                );
              },
            ),
            const SizedBox(height: 12),
            BotonSecundario(
              texto: 'Cancelar',
              alPresionar: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool seleccionado;
  final VoidCallback onTap;

  const _Opcion({
    required this.icono,
    required this.titulo,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: seleccionado ? const Color(0xFFEDF3FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFFD5E3FF)
                : const Color(0xFFE1E8F3),
          ),
        ),
        child: Row(
          children: [
            Icon(icono, size: 24, color: const Color(0xFF285FE8)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(fontSize: 16, color: Color(0xFF17243C)),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: seleccionado
                      ? const Color(0xFF285FE8)
                      : const Color(0xFFCCD9F0),
                  width: 2,
                ),
                color: seleccionado ? const Color(0xFF285FE8) : Colors.white,
              ),
              child: seleccionado
                  ? const Icon(Icons.circle, size: 10, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
