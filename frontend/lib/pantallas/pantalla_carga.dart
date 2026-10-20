import 'dart:convert';

import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/logo_app_bytes.dart';
import 'pantalla_bienvenida.dart';

/// Primera pantalla al abrir la app: logo, bienvenida y mensaje de espera.
class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  late final ImageProvider _logo;

  @override
  void initState() {
    super.initState();
    final bytes = base64Decode(kLogoAppBase64.replaceAll(RegExp(r'\s+'), ''));
    _logo = MemoryImage(bytes);

    Future.delayed(const Duration(milliseconds: 5000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const PantallaBienvenida(),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        ),
      );
    });
  }

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
            colors: [
              Color(0xFFB8D0FF),
              Color(0xFFD6E4FF),
              Color(0xFFE8F0FE),
              Color(0xFFF0F5FF),
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Logo real embebido
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Image(
                    image: _logo,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Prestamo amigo',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF214EC4),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '¡Bienvenido!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF17243C),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Pronto se abrirá la aplicación.\nEstamos preparando todo para ti…',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF536887),
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 2),
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFF285FE8),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Espera un momento…',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: ColoresApp.textoContexto,
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
