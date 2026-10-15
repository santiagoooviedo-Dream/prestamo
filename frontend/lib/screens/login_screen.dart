import 'package:flutter/material.dart';
import 'package:front_prestamo/widgets/Login/login_button.dart';
import 'package:front_prestamo/widgets/Login/login_footer.dart';
import 'package:front_prestamo/widgets/Login/login_form.dart';
import 'package:front_prestamo/widgets/Login/login_header.dart';
import 'package:front_prestamo/widgets/Login/login_title.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _cedulaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            // Soft background blobs
            Positioned(
              top: -30,
              left: -40,
              child: _blob(140, const Color(0xFFDBEAFE).withOpacity(0.5)),
            ),
            Positioned(
              top: 80,
              right: -60,
              child: _blob(180, const Color(0xFFE0E7FF).withOpacity(0.45)),
            ),
            // Content
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  LoginHeader(
                    onBack: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 28),
                  const LoginTitle(),
                  const SizedBox(height: 32),
                  // Lock icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.08),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      size: 32,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 36),
                  LoginForm(
                    cedulaController: _cedulaController,
                    passwordController: _passwordController,
                    onForgotPassword: () {
                      // TODO: Navigate to recover password
                    },
                  ),
                  const SizedBox(height: 28),
                  LoginButton(
                    onPressed: () {
                      // TODO: Handle login
                    },
                  ),
                  const SizedBox(height: 24),
                  LoginFooter(
                    onRegister: () {
                      // TODO: Navigate to register
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
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
