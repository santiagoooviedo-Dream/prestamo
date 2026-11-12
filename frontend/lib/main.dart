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

// solucionar bug de calendario de pago inicia en el mes actual y no en el siguiente 
// y la cantidad de couta que el usuario debe pagar es erronea 

//solucionar bu de pagar con nequi a el momento de el usuario mande su factura que pueda ver con mayor facilidad la imagen

// en conversasciones con el administrador (usuario) Pueda ver la imagen que este mando

//modulo de admin el boton rojo de notificacion se demora mucho y ahi un usuario que constantemente dice que ahi una notificacion
//pero no ahi nada 