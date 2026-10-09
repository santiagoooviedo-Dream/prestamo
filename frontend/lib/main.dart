import 'package:flutter/material.dart';
import 'package:front_prestamo/screens/Bienvenido_card.dart';
import 'package:front_prestamo/screens/codigo_recuperacion_screen.dart';
import 'package:front_prestamo/screens/codigo_verificacion_screen.dart';
import 'package:front_prestamo/screens/confirmar_contrasena_screen%20(1).dart';
import 'package:front_prestamo/screens/contrasena_lista_screen.dart';
import 'package:front_prestamo/screens/crear_cuenta_screen.dart';
import 'package:front_prestamo/widgets/Inicio/InicioScreens.dart';
import 'package:front_prestamo/screens/loginScreens.dart';
import 'package:front_prestamo/screens/recuperar_screen.dart';

void main() {
  runApp(const FrontPrestamoApp());
}

class FrontPrestamoApp extends StatelessWidget {
  const FrontPrestamoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}