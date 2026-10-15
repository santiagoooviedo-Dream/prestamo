import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  final VoidCallback? onRegister;

  const LoginFooter({super.key, this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿No tienes cuenta? ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          GestureDetector(
            onTap: onRegister,
            child: const Text(
              'Crear cuenta',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
