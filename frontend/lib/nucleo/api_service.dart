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

  static const bool useRemote = true;

  static const String _remoteUrl = 'https://prestamo-amigo.onrender.com';

  ApiService._();

  static const _almacenSeguro = FlutterSecureStorage();
  static final _cliente = http.Client();
  static const _urlConfigurada = String.fromEnvironment('API_BASE_URL');

  static String get _baseUrl {
    if (useRemote) {
      return _remoteUrl;
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

  static Future<Map<String, dynamic>> obtenerPerfil() async {
    final respuesta = await _solicitar('GET', '/usuarios/perfil');
    final usuario = respuesta['usuario'];
    if (usuario is! Map<String, dynamic>) {
      throw const ApiException('La respuesta del perfil no es válida.');
    }
    return usuario;
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

  static Future<void> cambiarCorreo({
    required String nuevoCorreo,
    required String contrasena,
  }) async {
    await _solicitar(
      'PUT',
      '/usuarios/correo',
      datos: {'nuevoCorreo': nuevoCorreo, 'contrasena': contrasena},
    );
  }

  static Future<void> cambiarContrasena({
    required String contrasenaActual,
    required String contrasenaNueva,
  }) async {
    await _solicitar(
      'PUT',
      '/usuarios/contrasena',
      datos: {
        'contrasenaActual': contrasenaActual,
        'contrasenaNueva': contrasenaNueva,
      },
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

  static Future<List<Map<String, dynamic>>> obtenerCuotas() async {
    final respuesta = await _solicitar('GET', '/prestamos/cuotas');
    final items = respuesta['cuotas'];
    if (items is! List) {
      throw const ApiException('La respuesta de cuotas no es válida.');
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> obtenerMovimientos() async {
    final respuesta = await _solicitar('GET', '/pagos/movimientos');
    final items = respuesta['movimientos'];
    if (items is! List) {
      throw const ApiException('La respuesta de movimientos no es válida.');
    }
    return items.whereType<Map<String, dynamic>>().toList();
  }

  static Future<void> marcarNotificacionLeida(String id) async {
    await _solicitar('PUT', '/notificaciones/$id');
  }

  static Future<Map<String, dynamic>> crearConversacion() {
    return _solicitar('POST', '/conversaciones');
  }

  static Future<Map<String, dynamic>> enviarMensajeChatbot(
    String idConversacion,
    String mensaje,
  ) {
    return _solicitar(
      'POST',
      '/conversaciones/$idConversacion/chatbot',
      datos: {'mensaje': mensaje},
    );
  }


  /// Registrar pago de una cuota
  static Future<Map<String, dynamic>> registrarPago({
    required int idPrestamo,
    required int idCuota,
    required num monto,
    required String metodoPago,
  }) {
    return _solicitar(
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

  /// Subir foto de perfil (multipart)
  static Future<Map<String, dynamic>> cambiarFoto(String rutaArchivo) async {
    final uri = Uri.parse('$_baseUrl/usuarios/foto');
    final token = await _leerDatoSeguro('token');
    if (token == null || token.isEmpty) {
      throw const ApiException('Inicia sesión para continuar.');
    }
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('foto', rutaArchivo));
    try {
      final streamed = await request.send().timeout(const Duration(seconds: 30));
      final respuesta = await http.Response.fromStream(streamed);
      final cuerpo = respuesta.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(respuesta.body);
      if (cuerpo is! Map<String, dynamic>) {
        throw const ApiException('El servidor devolvió una respuesta inválida.');
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
    }
  }

  // ─── Admin ───────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> obtenerSolicitudesAdmin() async {
    final respuesta = await _solicitar('GET', '/solicitudes/admin');
    final items = respuesta['solicitud'] ?? respuesta['solicitudes'];
    if (items is! List) {
      throw const ApiException('La respuesta de solicitudes admin no es válida.');
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
    return _solicitar('PATCH', '/solicitudes/$idSolicitud', datos: datos);
  }

  static Future<Map<String, dynamic>> crearPrestamoDesdeSolicitud(int idSolicitud) {
    return _solicitar('POST', '/prestamos/$idSolicitud');
  }

  static Future<Map<String, dynamic>> crearCuotasPrestamo(int idPrestamo) {
    return _solicitar('POST', '/prestamos/$idPrestamo/cuotas');
  }

  static Future<Map<String, dynamic>> crearNotificacion({
    required int idUsuario,
    required String mensaje,
    String tipo = 'info',
  }) {
    return _solicitar(
      'POST',
      '/notificaciones',
      datos: {
        'id_usuario': idUsuario,
        'mensaje': mensaje,
        'tipo': tipo,
      },
    );
  }

  static Future<List<Map<String, dynamic>>> obtenerConversacionesAdmin() async {
    final respuesta = await _solicitar('GET', '/conversaciones/admin');
    final items = respuesta['conversaciones'] ??
        respuesta['data'] ??
        (respuesta is List ? respuesta : null);
    if (items is List) {
      return items.whereType<Map<String, dynamic>>().toList();
    }
    // Si la respuesta es la lista envuelta de otra forma
    for (final key in respuesta.keys) {
      final v = respuesta[key];
      if (v is List) return v.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> obtenerMisConversaciones() async {
    final respuesta = await _solicitar('GET', '/conversaciones');
    for (final key in ['conversaciones', 'data']) {
      final v = respuesta[key];
      if (v is List) return v.whereType<Map<String, dynamic>>().toList();
    }
    for (final v in respuesta.values) {
      if (v is List) return v.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> obtenerMensajesConversacion(
    String idConversacion,
  ) async {
    final respuesta =
        await _solicitar('GET', '/conversaciones/$idConversacion/mensajes');
    for (final key in ['mensajes', 'data']) {
      final v = respuesta[key];
      if (v is List) return v.whereType<Map<String, dynamic>>().toList();
    }
    for (final v in respuesta.values) {
      if (v is List) return v.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> enviarMensajeConversacion({
    required String idConversacion,
    required String mensaje,
  }) {
    return _solicitar(
      'POST',
      '/conversaciones/$idConversacion/mensajes',
      datos: {'respuesta': mensaje},
    );
  }

  static Future<void> cerrarConversacion(String idConversacion) async {
    await _solicitar('PUT', '/conversaciones/$idConversacion/cerrar');
  }

  static Future<void> transferirConversacionAAdmin(String idConversacion) async {
    await _solicitar('PUT', '/conversaciones/$idConversacion/transferir');
  }

  /// Lista todos los usuarios (ruta temporal del backend GET /usuarios)
  static Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    final uri = Uri.parse('$_baseUrl/usuarios');
    final token = await _leerDatoSeguro('token');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    try {
      final respuesta = await _cliente
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
