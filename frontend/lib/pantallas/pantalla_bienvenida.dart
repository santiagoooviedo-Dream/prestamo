import 'package:flutter/material.dart';

import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_secundario.dart';
import '../widgets/acceso/logo_bienvenida.dart';
import 'pantalla_registro.dart';
import 'pantalla_iniciar_sesion.dart';
import '../nucleo/colores_app.dart';

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: top,
            left: -70,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: ColoresApp.fondoAzulMedio.withValues(alpha: 0.65),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: ColoresApp.blobSuave.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, top + 10, 24, 20 + bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabecera
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Préstamos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ColoresApp.primario,
                      ),
                    ),
                    Text(
                      'BIENVENIDO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ColoresApp.textoContexto,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const LogoBienvenida(),
                const Spacer(flex: 2),
                const Text(
                  'Tus préstamos, sin complicaciones.',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: ColoresApp.textoPrincipal,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Accede a tus préstamos de forma rápida y segura.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: ColoresApp.textoSecundario,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [ColoresApp.blobSuave, ColoresApp.fondoAzulClaro2],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ColoresApp.bordeAviso),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 20,
                        color: ColoresApp.primario.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Tu seguridad es importante para nosotros. Cuidamos tu información en cada paso.',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColoresApp.textoSecundario,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                BotonPrimario(
                  texto: 'Iniciar sesión',
                  alPresionar: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PantallaIniciarSesion(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                BotonSecundario(
                  texto: 'Crear cuenta',
                  alPresionar: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PantallaRegistro(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
