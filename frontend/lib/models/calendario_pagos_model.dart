import '../nucleo/api_service.dart';

class CuotaPrestamoModel {
  final String idCuota;
  final String idPrestamo;
  final String numero;
  final String estado;
  final DateTime? fecha;
  final double monto;
  final int totalCuotas;

  const CuotaPrestamoModel({
    required this.idCuota,
    required this.idPrestamo,
    required this.numero,
    required this.estado,
    required this.fecha,
    required this.monto,
    this.totalCuotas = 0,
  });

  factory CuotaPrestamoModel.desdeApi(Map<String, dynamic> datos) {
    final fechaRaw =
        datos['fecha_pago'] ?? datos['fecha_vencimiento'] ?? datos['fecha'];
    return CuotaPrestamoModel(
      idCuota: datos['id_cuota']?.toString() ?? '',
      idPrestamo: datos['id_prestamo']?.toString() ?? '',
      numero: datos['numero_cuota']?.toString() ?? '—',
      estado: (datos['estado']?.toString() ?? 'pendiente').toLowerCase(),
      fecha: DateTime.tryParse(fechaRaw?.toString() ?? ''),
      monto: double.tryParse(datos['monto']?.toString() ?? '') ?? 0,
      totalCuotas: int.tryParse(datos['total_cuotas']?.toString() ?? '') ?? 0,
    );
  }

  bool get estaPagada =>
      estado == 'pagada' || estado == 'pagado' || estado == 'completada';

  bool get estaVencida {
    if (estaPagada || fecha == null) return false;
    final hoy = DateTime.now();
    final f = DateTime(fecha!.year, fecha!.month, fecha!.day);
    final h = DateTime(hoy.year, hoy.month, hoy.day);
    return f.isBefore(h);
  }
}

class CalendarioPagosModel {
  const CalendarioPagosModel();

  Future<List<CuotaPrestamoModel>> obtenerCuotas() async {
    final datos = await ApiService.obtenerCuotas();
    var cuotas = datos.map(CuotaPrestamoModel.desdeApi).toList();

    cuotas.sort((a, b) {
      final na = int.tryParse(a.numero) ?? 0;
      final nb = int.tryParse(b.numero) ?? 0;
      if (na != nb) return na.compareTo(nb);
      if (a.fecha == null) return 1;
      if (b.fecha == null) return -1;
      return a.fecha!.compareTo(b.fecha!);
    });

    // Si el backend puso la misma fecha a todas, distribuir mensualmente
    if (cuotas.length > 1) {
      final fechas = cuotas.map((c) => c.fecha).whereType<DateTime>().toList();
      final todasIguales = fechas.length == cuotas.length &&
          fechas.every((f) =>
              f.year == fechas.first.year &&
              f.month == fechas.first.month &&
              f.day == fechas.first.day);
      if (todasIguales) {
        final base = fechas.first;
        cuotas = [
          for (var i = 0; i < cuotas.length; i++)
            CuotaPrestamoModel(
              idCuota: cuotas[i].idCuota,
              idPrestamo: cuotas[i].idPrestamo,
              numero: cuotas[i].numero,
              estado: cuotas[i].estado,
              fecha: DateTime(base.year, base.month + i, base.day),
              monto: cuotas[i].monto,
              totalCuotas: cuotas.length,
            ),
        ];
      }
    }

    // Completar total de cuotas por préstamo
    final porPrestamo = <String, int>{};
    for (final c in cuotas) {
      porPrestamo[c.idPrestamo] = (porPrestamo[c.idPrestamo] ?? 0) + 1;
    }
    return [
      for (final c in cuotas)
        CuotaPrestamoModel(
          idCuota: c.idCuota,
          idPrestamo: c.idPrestamo,
          numero: c.numero,
          estado: c.estado,
          fecha: c.fecha,
          monto: c.monto,
          totalCuotas: c.totalCuotas > 0
              ? c.totalCuotas
              : (porPrestamo[c.idPrestamo] ?? 0),
        ),
    ];
  }
}

String formatoMontoCuota(num valor) {
  final entero = valor.round().toString();
  final b = StringBuffer();
  for (var i = 0; i < entero.length; i++) {
    if (i > 0 && (entero.length - i) % 3 == 0) b.write('.');
    b.write(entero[i]);
  }
  return b.toString();
}

String formatoFechaLarga(DateTime? fecha) {
  if (fecha == null) return '—';
  const dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];
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
  // DateTime.weekday: 1=Mon ... 7=Sun
  final nombreDia = dias[fecha.weekday - 1];
  return '$nombreDia, ${fecha.day} de ${meses[fecha.month - 1]}';
}

String formatoFechaCorta(DateTime? fecha) {
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
