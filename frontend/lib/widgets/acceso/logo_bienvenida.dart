import 'package:flutter/material.dart';

class LogoBienvenida extends StatelessWidget {
  const LogoBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF3FF),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/imagenes/logo_tp.png',
            width: 130,
            height: 110,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF285FE8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text(
                  'TP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'BIENVENIDO',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF285FE8),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
