import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'api_core.dart';
import 'api_data.dart';
import 'api_exception.dart';

class ApiAuth {
  ApiAuth._();

  static Future<Map<String, dynamic>> iniciarSesion(
    String cedula,
    String contrasena,
  ) async {
    final respuesta = await ApiCore.solicitar(
      'POST',
      '/usuarios/login',
      autenticada: false,
      datos: {'cedula': cedula, 'contrasena': contrasena},
    );
    final token = respuesta['token'];
    if (token is! String || token.isEmpty) {
      throw const ApiException('El servidor no devolvió un token de sesión.');
    }
    await ApiCore.guardarDatoSeguro('token', token);
    final usuario = respuesta['usuario'];
    return usuario is Map<String, dynamic> ? usuario : <String, dynamic>{};
  }

  static Future<void> registrarUsuario(Map<String, dynamic> usuario) async {
    await ApiCore.solicitar(
      'POST',
      '/usuarios/registrar',
      autenticada: false,
      datos: usuario,
    );
  }

  static Future<Map<String, dynamic>> obtenerPerfil() async {
    final respuesta = await ApiCore.solicitar('GET', '/usuarios/perfil');
    final usuario = respuesta['usuario'];
    if (usuario is! Map<String, dynamic>) {
      throw const ApiException('La respuesta del perfil no es válida.');
    }
    return usuario;
  }

  static Future<void> eliminarCuenta() async {
    // Elimina la cuenta del usuario autenticado en el backend
    await ApiCore.solicitar('DELETE', '/usuarios/cuenta');
  }

  static Future<void> verificarRegistro(String correo, String codigo) async {
    await ApiCore.solicitar(
      'POST',
      '/usuarios/registrar/verificar-codigo',
      autenticada: false,
      datos: {'correo': correo, 'codigo': codigo},
    );
  }

  static Future<void> reenviarCodigoRegistro(String correo) async {
    await ApiCore.solicitar(
      'POST',
      '/usuarios/registrar/reenviar-codigo',
      autenticada: false,
      datos: {'correo': correo},
    );
  }

  static Future<Map<String, dynamic>> solicitarCambioCorreo({
    required String nuevoCorreo,
    required String contrasena,
  }) async {
    return ApiCore.solicitar(
      'POST',
      '/usuarios/correo/solicitar-cambio',
      datos: {'nuevoCorreo': nuevoCorreo, 'contrasena': contrasena},
    );
  }

  static Future<void> verificarCambioCorreo({
    required String tokenVerificacion,
    required String codigo,
  }) async {
    await ApiCore.solicitar(
      'POST',
      '/usuarios/correo/verificar',
      datos: {'tokenVerificacion': tokenVerificacion, 'codigo': codigo},
    );
  }

  static Future<void> cambiarContrasena({
    required String contrasenaActual,
    required String contrasenaNueva,
  }) async {
    await ApiCore.solicitar(
      'PUT',
      '/usuarios/contrasena',
      datos: {
        'contrasenaActual': contrasenaActual,
        'contrasenaNueva': contrasenaNueva,
      },
    );
  }

  static Future<void> solicitarCodigoRecuperacion(String correo) async {
    await ApiCore.solicitar(
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
    await ApiCore.solicitar(
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
    await ApiCore.solicitar(
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

  static Future<Map<String, dynamic>> cambiarFoto(XFile archivo) async {
    final uri = Uri.parse('${ApiCore.baseUrl}/usuarios/foto');
    final token = await ApiCore.leerDatoSeguro('token');
    if (token == null || token.isEmpty) {
      throw const ApiException('Inicia sesión para continuar.');
    }
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        http.MultipartFile.fromBytes(
          'foto',
          await archivo.readAsBytes(),
          filename: archivo.name,
        ),
      );
    try {
      final streamed = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final respuesta = await http.Response.fromStream(streamed);
      final cuerpo = respuesta.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(respuesta.body);
      if (cuerpo is! Map<String, dynamic>) {
        throw const ApiException(
          'El servidor devolvió una respuesta inválida.',
        );
      }
      if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
        final mensaje = cuerpo['mensaje'] ?? cuerpo['error'];
        throw ApiException(
          mensaje is String ? mensaje : 'No se pudo subir la foto.',
        );
      }
      return cuerpo;
    } on TimeoutException {
      throw const ApiException('El servidor tardó demasiado en responder.');
    } on http.ClientException {
      throw const ApiException(
        'No fue posible conectar con el servidor. Verifica tu conexión.',
      );
    } on FormatException {
      throw const ApiException('El servidor devolvió una respuesta inválida.');
    }
  }

  static Future<void> cerrarSesion() async {
    final idInstalacionPush = await ApiCore.leerDatoSeguro('fcm_installation_id');
    if (idInstalacionPush != null && idInstalacionPush.isNotEmpty) {
      try {
        await ApiData.eliminarInstalacionNotificaciones(idInstalacionPush);
      } on ApiException catch (error) {
        debugPrint(
          'No se pudo desvincular el dispositivo de notificaciones: ${error.mensaje}',
        );
      }
    }
    await ApiCore.borrarDatoSeguro('fcm_installation_id');
    await ApiCore.borrarDatoSeguro('token');
  }
}
