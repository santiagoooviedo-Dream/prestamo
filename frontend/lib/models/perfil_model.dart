import '../nucleo/api_service.dart';

class PerfilModel {
  const PerfilModel();

  Future<Map<String, dynamic>> cargar() => ApiService.obtenerPerfil();
}
