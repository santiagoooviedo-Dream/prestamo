import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';

class PantallaPagoExitoso extends StatelessWidget {
  final String monto;

  const PantallaPagoExitoso({
    super.key,
    this.monto = '\$200.000',
  });

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
                  '¡Pago realizado\ncon éxito!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: ColoresApp.textoPrincipal,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Se procesó el pago de $monto\ncorrectamente.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: ColoresApp.textoSecundario,
                    height: 1.45,
                  ),
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
