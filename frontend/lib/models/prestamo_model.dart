import '../nucleo/api_service.dart';

class PrestamosUsuario {
  final List<Map<String, dynamic>> solicitudes;
  final List<Map<String, dynamic>> prestamos;
  final List<Map<String, dynamic>> cuotas;

  const PrestamosUsuario({
    required this.solicitudes,
    required this.prestamos,
    required this.cuotas,
  });

  List<Map<String, dynamic>> get prestamosActivos =>
      prestamos.where((prestamo) => !estaCompletado(prestamo)).toList();

  List<Map<String, dynamic>> get prestamosAnteriores {
    final anteriores = prestamos.where(estaCompletado).toList();
    anteriores.sort((a, b) {
      final fechaA = DateTime.tryParse(a['fecha_inicio']?.toString() ?? '');
      final fechaB = DateTime.tryParse(b['fecha_inicio']?.toString() ?? '');
      if (fechaA == null) return 1;
      if (fechaB == null) return -1;
      return fechaB.compareTo(fechaA);
    });
    return anteriores;
  }

  List<Map<String, dynamic>> cuotasDelPrestamo(dynamic idPrestamo) => cuotas
      .where(
        (cuota) => cuota['id_prestamo']?.toString() == idPrestamo?.toString(),
      )
      .toList();

  bool estaCompletado(Map<String, dynamic> prestamo) {
    final estado = prestamo['estado']?.toString().toLowerCase();
    if (estado == 'completado' ||
        estado == 'completada' ||
        estado == 'finalizado' ||
        estado == 'finalizada' ||
        estado == 'pagada' ||
        estado == 'pagado') {
      return true;
    }

    final cuotasPrestamo = cuotasDelPrestamo(prestamo['id_prestamo']);
    final totalCuotas =
        int.tryParse(prestamo['coutas']?.toString() ?? '') ??
        cuotasPrestamo.length;
    if (totalCuotas == 0 || cuotasPrestamo.length < totalCuotas) return false;

    final cuotasPagadas = cuotasPrestamo.where((cuota) {
      final estadoCuota = cuota['estado']?.toString().toLowerCase();
      return estadoCuota == 'pagada' || estadoCuota == 'pagado';
    }).length;
    return cuotasPagadas >= totalCuotas;
  }
}

class PrestamoModel {
  const PrestamoModel();

  Future<PrestamosUsuario> obtenerMisPrestamos() async {
    final resultados = await Future.wait([
      ApiService.obtenerSolicitudes(),
      ApiService.obtenerPrestamos(),
      ApiService.obtenerCuotas(),
    ]);
    return PrestamosUsuario(
      solicitudes: resultados[0],
      prestamos: resultados[1],
      cuotas: resultados[2],
    );
  }
}

String formatoMontoPrestamo(dynamic valor) {
  final monto = num.tryParse(valor?.toString() ?? '')?.round() ?? 0;
  final texto = monto.toString();
  final salida = StringBuffer();
  for (var i = 0; i < texto.length; i++) {
    if (i > 0 && (texto.length - i) % 3 == 0) salida.write('.');
    salida.write(texto[i]);
  }
  return salida.toString();
}

String formatoFechaPrestamo(dynamic valor) {
  final fecha = DateTime.tryParse(valor?.toString() ?? '');
  if (fecha == null) return '—';
  const meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
}
