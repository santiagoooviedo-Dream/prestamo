import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart'; 
import 'pantallas/pantalla_carga.dart'; 
import 'widgets/comunes/fondo_degradado.dart'; 
void main() { 
  WidgetsFlutterBinding.ensureInitialized(); 
  SystemChrome.setSystemUIOverlayStyle( 
    const SystemUiOverlayStyle( 
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Brightness.dark, 
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
        scaffoldBackgroundColor: Colors.transparent, 
      ), 
      builder: (context, child) { 
        return Container( 
          decoration: FondoDegradado.decoracion, 
          child: child ?? const SizedBox.shrink(), 
        ); 
      }, 
      home: const PantallaCarga(), 
    ); 
  } 
} 
