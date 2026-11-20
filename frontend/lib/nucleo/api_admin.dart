import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_core.dart';
import 'api_exception.dart';

class ApiAdmin {
  ApiAdmin._();

  static Future<List<Map<String, dynamic>>> obtenerSolicitudesAdmin() async {
    final respuesta = await ApiCore.solicitar('GET', '/solicitudes/admin');
    final items = respuesta['solicitud'] ?? respuesta['solicitudes'];
    if (items is! List) {
      throw const ApiException(
        'La respuesta de solicitudes admin no es válida.',
      );
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<Map<String, dynamic>> actualizarEstadoSolicitud({
    required int idSolicitud,
    required String estado,
    String? fechaDesembolso,
    String? lugarRecogida,
  }) {
    final datos = <String, dynamic>{'estado': estado};
    if (fechaDesembolso != null) datos['fecha_desembolso'] = fechaDesembolso;
    if (lugarRecogida != null) datos['lugar_recogida'] = lugarRecogida;
    return ApiCore.solicitar('PATCH', '/solicitudes/$idSolicitud', datos: datos);
  }

  static Future<Map<String, dynamic>> crearPrestamoDesdeSolicitud(
    int idSolicitud,
  ) {
    return ApiCore.solicitar('POST', '/prestamos/$idSolicitud');
  }

  static Future<Map<String, dynamic>> crearCuotasPrestamo(int idPrestamo) {
    return ApiCore.solicitar('POST', '/prestamos/$idPrestamo/cuotas');
  }

  static Future<Map<String, dynamic>> crearNotificacion({
    required int idUsuario,
    required String mensaje,
    String tipo = 'info',
  }) async {
    if (idUsuario <= 0) {
      throw const ApiException('Destinatario inválido.');
    }
    if (mensaje.trim().isEmpty) {
      throw const ApiException('El mensaje no puede estar vacío.');
    }
    return ApiCore.solicitar(
      'POST',
      '/notificaciones',
      datos: {'id_usuario': idUsuario, 'mensaje': mensaje.trim(), 'tipo': tipo},
    );
  }

  static Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    final uri = Uri.parse('${ApiCore.baseUrl}/usuarios');
    final token = await ApiCore.leerDatoSeguro('token');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    try {
      final respuesta = await ApiCore.cliente
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 20));
      final cuerpo = respuesta.body.isEmpty ? null : jsonDecode(respuesta.body);
      if (cuerpo is List) {
        return cuerpo.whereType<Map<String, dynamic>>().toList();
      }
      if (cuerpo is Map<String, dynamic>) {
        for (final v in cuerpo.values) {
          if (v is List) {
            return v.whereType<Map<String, dynamic>>().toList();
          }
        }
      }
      throw const ApiException('La respuesta de usuarios no es válida.');
    } on TimeoutException {
      throw const ApiException('El servidor tardó demasiado en responder.');
    } on http.ClientException {
      throw const ApiException(
        'No fue posible conectar con el servidor. Verifica tu conexión.',
      );
    }
  }
}
