import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/aviso_seguridad.dart';

class PantallaSolicitudEnviada extends StatelessWidget {
  const PantallaSolicitudEnviada({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColoresApp.fondoInicio, ColoresApp.fondoFin],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TP / Préstamos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ColoresApp.primario,
                      ),
                    ),
                    Text(
                      'SOLICITUD ENVIADA',
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
                  decoration: const BoxDecoration(
                    color: ColoresApp.exitoClaro,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 52,
                    color: ColoresApp.exito,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  '¡Solicitud enviada!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tu solicitud de préstamo está siendo\nevaluada. Te notificaremos pronto.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: ColoresApp.textoSecundario,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                const AvisoSeguridad(
                  texto:
                      'Recibirás una notificación cuando tu solicitud sea procesada.',
                ),
                const Spacer(flex: 3),
                BotonPrimario(
                  texto: 'Volver al inicio',
                  alPresionar: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/bienvenida',
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
