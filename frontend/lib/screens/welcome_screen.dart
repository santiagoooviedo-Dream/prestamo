import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/Bienvenida/security_badge.dart';
import 'package:front_prestamo/widgets/Bienvenida/welcome_buttons.dart';
import 'package:front_prestamo/widgets/Bienvenida/welcome_content.dart';
import 'package:front_prestamo/widgets/Bienvenida/welcome_header.dart';
import 'package:front_prestamo/widgets/Bienvenida/welcome_logo.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            // Background soft blobs
            Positioned(
              top: -40,
              left: -60,
              child: _blob(180, const Color(0xFFDBEAFE).withOpacity(0.6)),
            ),
            Positioned(
              top: 120,
              right: -50,
              child: _blob(160, const Color(0xFFE0E7FF).withOpacity(0.5)),
            ),
            Positioned(
              bottom: 80,
              left: -30,
              child: _blob(140, const Color(0xFFDBEAFE).withOpacity(0.4)),
            ),
            // Content
            Column(
              children: [
                const SizedBox(height: 12),
                const WelcomeHeader(),
                const Spacer(flex: 2),
                const WelcomeLogo(),
                const Spacer(flex: 2),
                const WelcomeContent(),
                const SizedBox(height: 24),
                const SecurityBadge(),
                const Spacer(flex: 3),
                WelcomeButtons(
                  onLogin: () {
                    // TODO: Navigate to LoginScreen
                  },
                  onRegister: () {
                    // TODO: Navigate to Register
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
