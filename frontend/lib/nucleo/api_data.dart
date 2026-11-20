import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'api_core.dart';
import 'api_exception.dart';

class ApiData {
  ApiData._();

  static Future<Map<String, dynamic>> crearSolicitud({
    required int monto,
    required int cuotas,
    required String motivo,
    required String metodoDesembolso,
    String? telefonoNequi,
  }) {
    return ApiCore.solicitar(
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
    final respuesta = await ApiCore.solicitar('GET', '/notificaciones');
    final items = respuesta['notificaciones'];
    if (items is! List) {
      throw const ApiException('La respuesta de notificaciones no es válida.');
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<void> registrarInstalacionNotificaciones(String fid) async {
    await ApiCore.solicitar('PUT', '/notificaciones/dispositivo', datos: {'fid': fid});
    await ApiCore.guardarDatoSeguro('fcm_installation_id', fid);
  }

  static Future<void> eliminarInstalacionNotificaciones(String fid) async {
    await ApiCore.solicitar(
      'DELETE',
      '/notificaciones/dispositivo',
      datos: {'fid': fid},
    );
  }

  static Future<List<Map<String, dynamic>>> obtenerSolicitudes() async {
    final respuesta = await ApiCore.solicitar('GET', '/solicitudes');
    final items = respuesta['solicitud'];
    if (items is! List) {
      throw const ApiException('La respuesta de solicitudes no es válida.');
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> obtenerPrestamos() async {
    final respuesta = await ApiCore.solicitar('GET', '/prestamos');
    final items = respuesta['prestamos'];
    if (items is! List) {
      throw const ApiException('La respuesta de préstamos no es válida.');
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> obtenerCuotas() async {
    final respuesta = await ApiCore.solicitar('GET', '/prestamos/cuotas');
    final items = respuesta['cuotas'];
    if (items is! List) {
      throw const ApiException('La respuesta de cuotas no es válida.');
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> obtenerMovimientos() async {
    final respuesta = await ApiCore.solicitar('GET', '/pagos/movimientos');
    final items = respuesta['movimientos'];
    if (items is! List) {
      throw const ApiException('La respuesta de movimientos no es válida.');
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<void> marcarNotificacionLeida(String id) async {
    await ApiCore.solicitar('PUT', '/notificaciones/$id');
  }

  static Future<Map<String, dynamic>> registrarPago({
    required int idPrestamo,
    required int idCuota,
    required num monto,
    required String metodoPago,
  }) {
    return ApiCore.solicitar(
      'POST',
      '/pagos',
      datos: {
        'id_prestamos': idPrestamo,
        'id_cuota': idCuota,
        'monto': monto,
        'metodo_pago': metodoPago,
      },
    );
  }

  static Future<Map<String, dynamic>> subirComprobantePago(
    XFile archivo,
  ) async {
    final uri = Uri.parse('${ApiCore.baseUrl}/pagos/comprobante');
    final token = await ApiCore.leerDatoSeguro('token');
    if (token == null || token.isEmpty) {
      throw const ApiException('Inicia sesión para continuar.');
    }
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        http.MultipartFile.fromBytes(
          'comprobante',
          await archivo.readAsBytes(),
          filename: archivo.name.isNotEmpty ? archivo.name : 'comprobante.jpg',
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
          mensaje is String ? mensaje : 'No se pudo subir el comprobante.',
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
}
