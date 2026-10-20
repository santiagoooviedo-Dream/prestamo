import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/comunes/boton_volver.dart';

class PantallaSoporte extends StatelessWidget {
  const PantallaSoporte({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BotonVolver(alPresionar: () => Navigator.pop(context)),
                      Text(
                        'SOPORTE',
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
                    'Asistente virtual',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Estamos aquí para ayudarte con tus préstamos y pagos.',
                    style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF3FF),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFD6E4FF), width: 6),
                      ),
                      child: const Icon(
                        Icons.support_agent_rounded,
                        size: 48,
                        color: Color(0xFF285FE8),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Próximamente podrás chatear con nuestro asistente.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF66758D)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const BarraNavegacion(actual: DestinoNav.soporte),
        ],
      ),
    );
  }
}
