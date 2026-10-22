import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String mensaje;

  const ApiException(this.mensaje);

  @override
  String toString() => mensaje;
}

class ApiService {
  ApiService._();

  static const _almacenSeguro = FlutterSecureStorage();
  static final _cliente = http.Client();
  static const _urlConfigurada = String.fromEnvironment('API_BASE_URL');

  static String get _baseUrl {
    if (_urlConfigurada.isNotEmpty) {
      return _urlConfigurada.replaceFirst(RegExp(r'/$'), '');
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static Future<Map<String, dynamic>> _solicitar(
    String metodo,
    String ruta, {
    Map<String, dynamic>? datos,
    bool autenticada = true,
  }) async {
    final uri = Uri.parse('$_baseUrl$ruta');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (autenticada) {
      final token = await _leerDatoSeguro('token');
      if (token == null || token.isEmpty) {
        throw const ApiException('Inicia sesión para continuar.');
      }
      headers['Authorization'] = 'Bearer $token';
    }

    final solicitud = http.Request(metodo, uri)..headers.addAll(headers);
    if (datos != null) {
      solicitud.body = jsonEncode(datos);
    }

    try {
      final respuesta = await _cliente
          .send(solicitud)
          .timeout(const Duration(seconds: 20));
      final respuestaCompleta = await http.Response.fromStream(respuesta);
      final cuerpo = respuestaCompleta.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(respuestaCompleta.body);

      if (cuerpo is! Map<String, dynamic>) {
        throw const ApiException(
          'El servidor devolvió una respuesta inválida.',
        );
      }
      if (respuestaCompleta.statusCode < 200 ||
          respuestaCompleta.statusCode >= 300) {
        final mensaje = cuerpo['mensaje'] ?? cuerpo['error'];
        throw ApiException(
          mensaje is String ? mensaje : 'No se pudo completar la solicitud.',
        );
      }
      return cuerpo;
    } on TimeoutException {
      throw const ApiException('El servidor tardó demasiado en responder.');
    } on http.ClientException {
      throw const ApiException(
        'No fue posible conectar con el servidor. Verifica la dirección de la API y tu conexión.',
      );
    } on FormatException {
      throw const ApiException('El servidor devolvió una respuesta inválida.');
    }
  }

  static Future<Map<String, dynamic>> iniciarSesion(
    String cedula,
    String contrasena,
  ) async {
    final respuesta = await _solicitar(
      'POST',
      '/usuarios/login',
      autenticada: false,
      datos: {'cedula': cedula, 'contrasena': contrasena},
    );
    final token = respuesta['token'];
    if (token is! String || token.isEmpty) {
      throw const ApiException('El servidor no devolvió un token de sesión.');
    }
    await _guardarDatoSeguro('token', token);
    final usuario = respuesta['usuario'];
    return usuario is Map<String, dynamic> ? usuario : <String, dynamic>{};
  }

  static Future<void> registrarUsuario(Map<String, dynamic> usuario) async {
    await _solicitar(
      'POST',
      '/usuarios/registrar',
      autenticada: false,
      datos: usuario,
    );
  }

  static Future<void> verificarRegistro(String correo, String codigo) async {
    await _solicitar(
      'POST',
      '/usuarios/registrar/verificar-codigo',
      autenticada: false,
      datos: {'correo': correo, 'codigo': codigo},
    );
  }

  static Future<void> reenviarCodigoRegistro(String correo) async {
    await _solicitar(
      'POST',
      '/usuarios/registrar/reenviar-codigo',
      autenticada: false,
      datos: {'correo': correo},
    );
  }

  static Future<void> solicitarCodigoRecuperacion(String correo) async {
    await _solicitar(
      'POST',
      '/usuarios/codigo',
      autenticada: false,
      datos: {'correo': correo},
    );
  }

  static Future<void> verificarCodigoRecuperacion(
    String correo,
    String codigo,
  ) async {
    await _solicitar(
      'POST',
      '/usuarios/verificar',
      autenticada: false,
      datos: {'correo': correo, 'codigo': codigo},
    );
  }

  static Future<void> recuperarContrasena({
    required String correo,
    required String codigo,
    required String contrasenaNueva,
  }) async {
    await _solicitar(
      'PUT',
      '/usuarios/recuperar',
      autenticada: false,
      datos: {
        'correo': correo,
        'codigo': codigo,
        'contrasenaNueva': contrasenaNueva,
      },
    );
  }

  static Future<Map<String, dynamic>> crearSolicitud({
    required int monto,
    required int cuotas,
    required String motivo,
    required String metodoDesembolso,
    String? telefonoNequi,
  }) {
    return _solicitar(
      'POST',
      '/solicitudes',
      datos: {
        'monto_solicitado': monto,
        'coutas': cuotas,
        'motivo': motivo,
        'metodo_desembolso': metodoDesembolso,
        'telefono_nequi': telefonoNequi,
      },
    );
  }

  static Future<List<Map<String, dynamic>>> obtenerNotificaciones() async {
    final respuesta = await _solicitar('GET', '/notificaciones');
    final items = respuesta['notificaciones'];
    if (items is! List) {
      throw const ApiException('La respuesta de notificaciones no es válida.');
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> obtenerSolicitudes() async {
    final respuesta = await _solicitar('GET', '/solicitudes');
    final items = respuesta['solicitud'];
    if (items is! List) {
      throw const ApiException('La respuesta de solicitudes no es válida.');
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> obtenerPrestamos() async {
    final respuesta = await _solicitar('GET', '/prestamos');
    final items = respuesta['prestamos'];
    if (items is! List) {
      throw const ApiException('La respuesta de préstamos no es válida.');
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<void> marcarNotificacionLeida(String id) async {
    await _solicitar('PUT', '/notificaciones/$id');
  }

  static Future<void> cerrarSesion() async {
    await _borrarDatoSeguro('token');
  }

  static Future<String?> _leerDatoSeguro(String clave) async {
    try {
      return await _almacenSeguro.read(key: clave);
    } on PlatformException {
      throw const ApiException('No se pudo acceder al almacenamiento seguro.');
    }
  }

  static Future<void> _guardarDatoSeguro(String clave, String valor) async {
    try {
      await _almacenSeguro.write(key: clave, value: valor);
    } on PlatformException {
      throw const ApiException('No se pudo guardar la sesión de forma segura.');
    }
  }

  static Future<void> _borrarDatoSeguro(String clave) async {
    try {
      await _almacenSeguro.delete(key: clave);
    } on PlatformException {
      throw const ApiException('No se pudo cerrar la sesión de forma segura.');
    }
  }
}
