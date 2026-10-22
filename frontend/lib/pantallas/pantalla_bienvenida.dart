import 'package:flutter/material.dart';

import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_secundario.dart';
import '../widgets/acceso/logo_bienvenida.dart';
import 'pantalla_registro.dart';
import 'pantalla_iniciar_sesion.dart';

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
                color: const Color(0xFFE4EDFF).withValues(alpha: 0.65),
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
                color: const Color(0xFFEAF1FF).withValues(alpha: 0.5),
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
                      'TP / Préstamos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF285FE8),
                      ),
                    ),
                    Text(
                      'BIENVENIDO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF41618E),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const LogoBienvenida(),

                // Un poco de aire (no todo el espacio vacío)
                const Spacer(flex: 2),

                // Textos más grandes para ocupar el medio
                const Text(
                  'Tus préstamos, sin complicaciones.',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17243C),
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Accede a tus préstamos de forma rápida y segura.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF66758D),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEAF1FF), Color(0xFFF2F6FF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD9E5FA)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 20,
                        color: const Color(0xFF285FE8).withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Tu seguridad es importante para nosotros. Cuidamos tu información en cada paso.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF66758D),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Pequeño aire antes de botones
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
