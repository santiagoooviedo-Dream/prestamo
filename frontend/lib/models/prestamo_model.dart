import '../nucleo/api_service.dart';

class PrestamosUsuario {
  final List<Map<String, dynamic>> solicitudes;
  final List<Map<String, dynamic>> prestamos;

  const PrestamosUsuario({required this.solicitudes, required this.prestamos});
}

class PrestamoModel {
  const PrestamoModel();

  Future<PrestamosUsuario> obtenerMisPrestamos() async {
    final resultados = await Future.wait([
      ApiService.obtenerSolicitudes(),
      ApiService.obtenerPrestamos(),
    ]);
    return PrestamosUsuario(
      solicitudes: resultados[0],
      prestamos: resultados[1],
    );
  }
}
