import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiCore {
  ApiCore._();

  static const bool useRemote = true;
  static const String remoteUrl = 'https://prestamo-amigo.onrender.com';
  static const almacenSeguro = FlutterSecureStorage();
  static final cliente = http.Client();
  static const urlConfigurada = String.fromEnvironment('API_BASE_URL');
  static const String kConvRevisadas = 'admin_conv_revisadas';

  static String get baseUrl {
    if (useRemote) {
      return remoteUrl;
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static Future<Map<String, dynamic>> solicitar(
    String metodo,
    String ruta, {
    Map<String, dynamic>? datos,
    bool autenticada = true,
  }) async {
    final uri = Uri.parse('$baseUrl$ruta');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (autenticada) {
      final token = await leerDatoSeguro('token');
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
      final respuesta = await cliente
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
          statusCode: respuestaCompleta.statusCode,
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

  static Future<String?> leerDatoSeguro(String clave) async {
    try {
      return await almacenSeguro.read(key: clave);
    } on PlatformException {
      throw const ApiException('No se pudo acceder al almacenamiento seguro.');
    }
  }

  static Future<void> guardarDatoSeguro(String clave, String valor) async {
    try {
      await almacenSeguro.write(key: clave, value: valor);
    } on PlatformException {
      throw const ApiException('No se pudo guardar la sesión de forma segura.');
    }
  }

  static Future<void> borrarDatoSeguro(String clave) async {
    try {
      await almacenSeguro.delete(key: clave);
    } on PlatformException {
      throw const ApiException('No se pudo cerrar la sesión de forma segura.');
    }
  }
}
