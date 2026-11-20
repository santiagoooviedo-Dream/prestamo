import 'dart:async';
import 'dart:convert';


import 'api_core.dart';

class ApiChat {
  ApiChat._();

  static Future<Map<String, dynamic>> crearConversacion() {
    return ApiCore.solicitar('POST', '/conversaciones');
  }

  static Future<Map<String, dynamic>> enviarMensajeChatbot(
    String idConversacion,
    String mensaje,
  ) {
    return ApiCore.solicitar(
      'POST',
      '/conversaciones/$idConversacion/chatbot',
      datos: {'mensaje': mensaje},
    );
  }

  static Future<List<Map<String, dynamic>>> obtenerConversacionesAdmin() async {
    final respuesta = await ApiCore.solicitar('GET', '/conversaciones/admin');
    final items =
        respuesta['conversaciones'] ??
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
    final respuesta = await ApiCore.solicitar('GET', '/conversaciones');
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
    final respuesta = await ApiCore.solicitar(
      'GET',
      '/conversaciones/$idConversacion/mensajes',
    );
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
    return ApiCore.solicitar(
      'POST',
      '/conversaciones/$idConversacion/mensajes',
      datos: {'respuesta': mensaje},
    );
  }

  static Future<void> cerrarConversacion(String idConversacion) async {
    await ApiCore.solicitar('PUT', '/conversaciones/$idConversacion/cerrar');
  }

  static Future<void> transferirConversacionAAdmin(
    String idConversacion,
  ) async {
    await ApiCore.solicitar('PUT', '/conversaciones/$idConversacion/transferir');
  }

  static Future<Map<String, String>> obtenerConversacionesRevisadas() async {
    try {
      final raw = await ApiCore.leerDatoSeguro(ApiCore.kConvRevisadas);
      if (raw == null || raw.isEmpty) return <String, String>{};
      final lista = jsonDecode(raw);
      if (lista is List) {
        return {for (final id in lista) id.toString(): '*'};
      }
      if (lista is Map) {
        return {
          for (final entry in lista.entries)
            entry.key.toString(): entry.value.toString(),
        };
      }
    } catch (_) {}
    return <String, String>{};
  }

  static Future<void> marcarConversacionRevisada(
    String id, {
    String? ultimoMensajeUsuario,
  }) async {
    if (id.isEmpty) return;
    final actual = await obtenerConversacionesRevisadas();
    final firma = ultimoMensajeUsuario ?? '*';
    if (actual[id] == firma) return;
    actual[id] = firma;
    try {
      await ApiCore.guardarDatoSeguro(ApiCore.kConvRevisadas, jsonEncode(actual));
    } catch (_) {}
  }
}
