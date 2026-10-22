import '../nucleo/api_service.dart';

class SolicitudPrestamoModel {
  const SolicitudPrestamoModel();

  static bool esMontoValido(int monto) => monto >= 100000 && monto <= 3000000;
  static bool sonCuotasValidas(int cuotas) => cuotas >= 2 && cuotas <= 36;
  static bool esTelefonoNequiValido(String telefono) =>
      RegExp(r'^3\d{9}$').hasMatch(telefono);

  Future<Map<String, dynamic>> crear({
    required int monto,
    required int cuotas,
    required String motivo,
    required String metodoDesembolso,
    String? telefonoNequi,
  }) {
    return ApiService.crearSolicitud(
      monto: monto,
      cuotas: cuotas,
      motivo: motivo,
      metodoDesembolso: metodoDesembolso,
      telefonoNequi: telefonoNequi,
    );
  }
}
