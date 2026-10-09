import 'package:flutter/material.dart';
import 'package:front_prestamo/screens/loginScreens.dart';

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