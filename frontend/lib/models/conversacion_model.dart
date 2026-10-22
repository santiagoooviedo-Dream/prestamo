import '../nucleo/api_service.dart';

class ConversacionModel {
  const ConversacionModel();

  Future<String> crear() async {
    final respuesta = await ApiService.crearConversacion();
    final conversacion = respuesta['conversacion'];
    if (conversacion is! Map<String, dynamic>) {
      throw const ApiException('El servidor no devolvió la conversación.');
    }
    final id = conversacion['id_conversacion']?.toString();
    if (id == null || id.isEmpty) {
      throw const ApiException(
        'La conversación no tiene un identificador válido.',
      );
    }
    return id;
  }

  Future<String> enviarMensaje(String idConversacion, String mensaje) async {
    final respuesta = await ApiService.enviarMensajeChatbot(
      idConversacion,
      mensaje,
    );
    final texto = respuesta['respuesta'];
    if (texto is! String || texto.isEmpty) {
      throw const ApiException('El asistente devolvió una respuesta inválida.');
    }
    return texto;
  }
}
