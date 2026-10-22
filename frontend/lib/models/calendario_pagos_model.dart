import '../nucleo/api_service.dart';

class CuotaPrestamoModel {
  final String numero;
  final String estado;
  final DateTime? fecha;
  final double monto;

  const CuotaPrestamoModel({
    required this.numero,
    required this.estado,
    required this.fecha,
    required this.monto,
  });

  factory CuotaPrestamoModel.desdeApi(Map<String, dynamic> datos) {
    return CuotaPrestamoModel(
      numero: datos['numero_cuota']?.toString() ?? '—',
      estado: datos['estado']?.toString() ?? 'pendiente',
      fecha: DateTime.tryParse(datos['fecha_pago']?.toString() ?? ''),
      monto: double.tryParse(datos['monto']?.toString() ?? '') ?? 0,
    );
  }
}

class CalendarioPagosModel {
  const CalendarioPagosModel();

  Future<List<CuotaPrestamoModel>> obtenerCuotas() async {
    final datos = await ApiService.obtenerCuotas();
    final cuotas = datos.map(CuotaPrestamoModel.desdeApi).toList();
    cuotas.sort((a, b) {
      if (a.fecha == null) return 1;
      if (b.fecha == null) return -1;
      return a.fecha!.compareTo(b.fecha!);
    });
    return cuotas;
  }
}
