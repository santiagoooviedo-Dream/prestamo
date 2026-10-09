import 'package:flutter/material.dart';
import 'package:front_prestamo/screens/loginScreens.dart';
import '../../core/colores.dart';

class ListaContent extends StatelessWidget {
  final double width;
  final double height;

  const ListaContent({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Título
        Positioned(
          left: width * 0.10,
          right: width * 0.10,
          top: height * 0.20,
          child: const Text(
            '¡Todo listo!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly",
              color: Colores.negro,
              fontSize: 34,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Descripción
        Positioned(
          left: width * 0.12,
          right: width * 0.12,
          top: height * 0.29,
          child: const Text(
            'Tu contraseña ha sido actualizada\n'
            'ahora puedes iniciar sesion con tu\n'
            'nueva contraseña',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.negro,
              fontSize: 17,
              height: 1.35,
            ),
          ),
        ),

        Positioned(
          left: width * 0.10,
          right: width * 0.10,
          top: height * 0.80,
          height: height * 0.065,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colores.azulSecundario,
              foregroundColor: Colores.blanco,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('Iniciar sesión'),
          ),
        ),

        // Icono candado grande con check
        Positioned(
          left: width * 0.28,
          right: width * 0.28,
          top: height * 0.45,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Candado principal
              Icon(
                Icons.lock_rounded,
                size: width * 0.32,
                color: Colores.azulSecundario,
              ),
              // Check verde abajo derecha
              Positioned(
                right: width * 0.02,
                bottom: height * 0.01,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colores.verde,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colores.blanco,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
