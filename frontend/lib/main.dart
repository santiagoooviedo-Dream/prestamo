import 'package:flutter/material.dart';
import 'package:front_prestamo/screens/Inicio/InicioScreens.dart';
import 'package:front_prestamo/screens/login/loginScreens.dart';
import 'package:front_prestamo/screens/recuperarContrase%C3%B1a/recuperar_screen.dart';

void main() {
  runApp(const FrontPrestamoApp());
}

class FrontPrestamoApp extends StatelessWidget {
  const FrontPrestamoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RecuperarScreen(),
    );
  }
}