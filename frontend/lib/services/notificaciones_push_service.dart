import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../nucleo/api_service.dart';

class NotificacionesPushService {
  NotificacionesPushService._();

  static const _idCanal = 'prestamo_notificaciones';
  static const _nombreCanal = 'Notificaciones de Préstamo Amigo';
  static const _descripcionCanal =
      'Actualizaciones de solicitudes y de tu cuenta.';
  static const _canal = AndroidNotificationChannel(
    _idCanal,
    _nombreCanal,
    description: _descripcionCanal,
    importance: Importance.high,
  );
  static const _ajustes = InitializationSettings(
    android: AndroidInitializationSettings('launcher_icon'),
    iOS: DarwinInitializationSettings(),
  );

  static final _notificacionesLocales = FlutterLocalNotificationsPlugin();
  static StreamSubscription<RemoteMessage>? _suscripcionMensajes;
  static StreamSubscription<String>? _suscripcionToken;
  static Completer<String>? _registroEnCurso;
  static bool _inicializado = false;

  static Future<void> activarParaUsuario() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }

    try {
      if (!_inicializado) {
        await Firebase.initializeApp();
        await _notificacionesLocales.initialize(settings: _ajustes);

        final android = _notificacionesLocales
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        await android?.createNotificationChannel(_canal);

        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
              alert: false,
              badge: false,
              sound: false,
            );
        _inicializado = true;
      }

      _suscripcionMensajes ??= FirebaseMessaging.onMessage.listen(
        _mostrarNotificacion,
        onError: (Object error) {
          debugPrint('Error al recibir una notificación push: $error');
        },
      );
      _suscripcionToken ??= FirebaseMessaging.instance.onRegistered.listen(
        (fid) {
          final registro = _registroEnCurso;
          if (registro != null && !registro.isCompleted) {
            registro.complete(fid);
          } else {
            unawaited(_registrarInstalacion(fid));
          }
        },
        onError: (Object error) {
          debugPrint('Error al registrar el dispositivo push: $error');
        },
      );

      final permiso = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (permiso.authorizationStatus == AuthorizationStatus.denied) return;

      final registro = Completer<String>();
      _registroEnCurso = registro;
      await FirebaseMessaging.instance.register();
      final fid = await registro.future.timeout(const Duration(seconds: 20));
      await ApiService.registrarInstalacionNotificaciones(fid);
    } on TimeoutException {
      debugPrint(
        'Firebase no entregó a tiempo el identificador del dispositivo.',
      );
    } on FirebaseException catch (error) {
      debugPrint(
        'No se pudo iniciar Firebase Messaging. Revisa la configuración de Firebase: ${error.message}',
      );
    } on ApiException catch (error) {
      debugPrint(
        'No se pudo registrar el dispositivo para push: ${error.mensaje}',
      );
    } on PlatformException catch (error) {
      debugPrint(
        'No se pudo configurar las notificaciones push: ${error.message}',
      );
    } on MissingPluginException catch (error) {
      debugPrint(
        'Falta registrar un plugin de notificaciones: ${error.message}',
      );
    } finally {
      _registroEnCurso = null;
    }
  }

  static Future<void> detener() async {
    await _suscripcionMensajes?.cancel();
    await _suscripcionToken?.cancel();
    _suscripcionMensajes = null;
    _suscripcionToken = null;
    _registroEnCurso = null;
  }

  static Future<void> _registrarInstalacion(String fid) async {
    try {
      await ApiService.registrarInstalacionNotificaciones(fid);
    } on ApiException catch (error) {
      debugPrint('No se pudo actualizar el dispositivo push: ${error.mensaje}');
    } on PlatformException catch (error) {
      debugPrint('No se pudo guardar el identificador push: ${error.message}');
    }
  }

  static Future<void> _mostrarNotificacion(RemoteMessage mensaje) async {
    final notificacion = mensaje.notification;
    if (notificacion == null) return;
 
    await _notificacionesLocales.show(
      id: mensaje.messageId?.hashCode ?? mensaje.hashCode,
      title: notificacion.title ?? 'Préstamo Amigo',
      body: notificacion.body ?? '',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _idCanal,
          _nombreCanal,
          channelDescription: _descripcionCanal,
          importance: Importance.high,
          priority: Priority.high,
          icon: 'launcher_icon',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: mensaje.data['notificationId']?.toString(),
    );
  }
}
