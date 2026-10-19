import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nucleo/colores_app.dart';
import 'pantallas/pantalla_bienvenida.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const AppPrestamos());
}

class AppPrestamos extends StatelessWidget {
  const AppPrestamos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP Préstamos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColoresApp.primario,
          primary: ColoresApp.primario,
        ),
        scaffoldBackgroundColor: ColoresApp.fondoFin,
      ),
      // Solo la pantalla principal. El resto se navega desde cada pantalla.
      home: const PantallaBienvenida(),
    );
  }
}
