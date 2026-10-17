import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nucleo/colores_app.dart';
import 'pantallas/pantalla_bienvenida.dart';
import 'pantallas/pantalla_iniciar_sesion.dart';
import 'pantallas/pantalla_recuperar_acceso.dart';
import 'pantallas/pantalla_codigo_recuperacion.dart';
import 'pantallas/pantalla_nueva_contrasena.dart';
import 'pantallas/pantalla_confirmar_contrasena.dart';
import 'pantallas/pantalla_contrasena_lista.dart';
import 'pantallas/pantalla_datos_personales.dart';
import 'pantallas/pantalla_registro.dart';
import 'pantallas/pantalla_verificar_correo.dart';
import 'pantallas/pantalla_inicio.dart';
import 'pantallas/pantalla_perfil.dart';
import 'pantallas/pantalla_mis_prestamos.dart';
import 'pantallas/pantalla_solicitar_prestamo.dart';
import 'pantallas/pantalla_metodo_desembolso.dart';
import 'pantallas/pantalla_validando_solicitud.dart';
import 'pantallas/pantalla_detalle_prestamo.dart';
import 'pantallas/pantalla_detalle_prestamo_completado.dart';
import 'pantallas/pantalla_prestamos_anteriores.dart';
import 'pantallas/pantalla_asistente_virtual.dart';
import 'pantallas/pantalla_cerrar_sesion.dart';
import 'pantallas/pantalla_calendario_pagos.dart';
import 'pantallas/pantalla_notificaciones.dart';
import 'pantallas/pantalla_metodo_pago.dart';
import 'pantallas/pantalla_confirmar_pago.dart';
import 'pantallas/pantalla_estado_cuenta.dart';
import 'pantallas/pantalla_actividad_cuenta.dart';
import 'pantallas/pantalla_pago_exitoso.dart';
import 'pantallas/pantalla_procesando_pago.dart';
import 'pantallas/pantalla_solicitud_enviada.dart';
import 'pantallas/pantalla_cambiar_foto.dart';
import 'pantallas/pantalla_cambiar_contrasena_perfil.dart';
import 'pantallas/pantalla_cambiar_correo.dart';
import 'pantallas/pantalla_codigo_cambio_correo.dart';

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
        '/codigo-recuperacion': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final correo = args is String ? args : 'correo@ejemplo.com';
          return PantallaCodigoRecuperacion(correo: correo);
        },
        '/nueva-contrasena': (_) => const PantallaNuevaContrasena(),
        '/confirmar-contrasena': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final clave = args is String ? args : null;
          return PantallaConfirmarContrasena(contrasenaAnterior: clave);
        },
        '/contrasena-lista': (_) => const PantallaContrasenaLista(),
        '/registro': (_) => const PantallaRegistro(),
        '/verificar-correo': (_) => const PantallaVerificarCorreo(),
        '/datos-personales': (_) => const PantallaDatosPersonales(),
        '/inicio': (_) => const PantallaInicio(),
        '/mis-prestamos': (_) => const PantallaMisPrestamos(),
        '/detalle-prestamo': (_) => const PantallaDetallePrestamo(),
        '/prestamos-anteriores': (_) => const PantallaPrestamosAnteriores(),
        '/detalle-prestamo-completado': (_) =>
            const PantallaDetallePrestamoCompletado(),
        '/solicitar-prestamo': (_) => const PantallaSolicitarPrestamo(),
        '/metodo-desembolso': (_) => const PantallaMetodoDesembolso(),
        '/validando-solicitud': (_) => const PantallaValidandoSolicitud(),
        '/solicitud-enviada': (_) => const PantallaSolicitudEnviada(),
        '/calendario-pagos': (_) => const PantallaCalendarioPagos(),
        '/metodo-pago': (_) => const PantallaMetodoPago(),
        '/confirmar-pago': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final metodo = args is String ? args : 'Nequi';
          return PantallaConfirmarPago(metodo: metodo);
        },
        '/procesando-pago': (_) => const PantallaProcesandoPago(),
        '/pago-exitoso': (_) => const PantallaPagoExitoso(),
        '/perfil': (_) => const PantallaPerfil(),
        '/cerrar-sesion': (_) => const PantallaCerrarSesion(),
        '/soporte': (_) => const PantallaAsistenteVirtual(),
        '/asistente-virtual': (_) => const PantallaAsistenteVirtual(),
        '/notificaciones': (_) => const PantallaNotificaciones(),
        '/cambiar-contrasena-perfil': (_) =>
            const PantallaCambiarContrasenaPerfil(),
        '/cambiar-foto': (_) => const PantallaCambiarFoto(),
        '/cambiar-correo': (_) => const PantallaCambiarCorreo(),
        '/codigo-cambio-correo': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final correo = args is String ? args : 'correo@ejemplo.com';
          return PantallaCodigoCambioCorreo(correo: correo);
        },
        '/estado-cuenta': (_) => const PantallaEstadoCuenta(),
        '/actividad-cuenta': (_) => const PantallaActividadCuenta(),
      },
    );
  }
}
