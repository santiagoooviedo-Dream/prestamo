import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nucleo/colores_app.dart';
import 'pantallas/pantalla_bienvenida.dart';
import 'pantallas/pantalla_iniciar_sesion.dart';
import 'pantallas/pantalla_recuperar_acceso.dart';
import 'pantallas/pantalla_nueva_contrasena.dart';
import 'pantallas/pantalla_confirmar_contrasena.dart';
import 'pantallas/pantalla_contrasena_lista.dart';
import 'pantallas/pantalla_datos_personales.dart';
import 'pantallas/pantalla_pago_exitoso.dart';
import 'pantallas/pantalla_solicitud_enviada.dart';
import 'pantallas/pantalla_registro.dart';
import 'pantallas/pantalla_verificar_correo.dart';
import 'pantallas/pantalla_inicio.dart';

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
      home: const PantallaBienvenida(),
      routes: {
        '/bienvenida': (_) => const PantallaBienvenida(),
        '/iniciar-sesion': (_) => const PantallaIniciarSesion(),
        '/recuperar-acceso': (_) => const PantallaRecuperarAcceso(),
        '/nueva-contrasena': (_) => const PantallaNuevaContrasena(),
        '/confirmar-contrasena': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final clave = args is String ? args : null;
          return PantallaConfirmarContrasena(contrasenaAnterior: clave);
        },
        '/contrasena-lista': (_) => const PantallaContrasenaLista(),
        '/datos-personales': (_) => const PantallaDatosPersonales(),
        '/pago-exitoso': (_) => const PantallaPagoExitoso(),
        '/solicitud-enviada': (_) => const PantallaSolicitudEnviada(),
        // Nuevas
        '/registro': (_) => const PantallaRegistro(),
        '/verificar-correo': (_) => const PantallaVerificarCorreo(),
        '/inicio': (_) => const PantallaInicio(),
      },
    );
  }
}
