import '../nucleo/api_service.dart';
import 'prestamo_model.dart';

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

  bool get estaPagada {
    final e = estado.toLowerCase().trim();
    return e == 'pagada' ||
        e == 'pagado' ||
        e == 'completada' ||
        e == 'completado' ||
        e == 'paid';
  }

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

  /// Solo cuotas del préstamo activo, con fechas mes a mes.
  Future<List<CuotaPrestamoModel>> obtenerCuotas() async {
    final prestamosRaw = await ApiService.obtenerPrestamos();
    final cuotasRaw = await ApiService.obtenerCuotas();

    final contenedor = PrestamosUsuario(
      solicitudes: const [],
      prestamos: prestamosRaw,
      cuotas: cuotasRaw,
    );
    final activos = contenedor.prestamosActivos;

    if (activos.isEmpty) return [];

    // Un préstamo en curso: el más reciente
    activos.sort((a, b) {
      final fa = DateTime.tryParse(a['fecha_inicio']?.toString() ?? '');
      final fb = DateTime.tryParse(b['fecha_inicio']?.toString() ?? '');
      if (fa == null) return 1;
      if (fb == null) return -1;
      return fb.compareTo(fa);
    });
    final activo = activos.first;
    final idActivo = activo['id_prestamo']?.toString();
    if (idActivo == null || idActivo.isEmpty) return [];

    final totalCuotasPrestamo =
        int.tryParse(activo['coutas']?.toString() ?? '') ?? 0;

    var cuotas = cuotasRaw
        .where((c) => c['id_prestamo']?.toString() == idActivo)
        .map(CuotaPrestamoModel.desdeApi)
        .toList();

    // Orden por número de cuota
    cuotas.sort((a, b) {
      final na = int.tryParse(a.numero) ?? 0;
      final nb = int.tryParse(b.numero) ?? 0;
      return na.compareTo(nb);
    });

    if (cuotas.isEmpty) return [];

    // Base: fecha_inicio del préstamo o la primera fecha de cuota
    final inicio =
        DateTime.tryParse(activo['fecha_inicio']?.toString() ?? '');
    final primeraConFecha = cuotas.cast<CuotaPrestamoModel?>().firstWhere(
          (c) => c?.fecha != null,
          orElse: () => null,
        );
    final base = inicio ??
        primeraConFecha?.fecha ??
        DateTime.now();

    // Siempre repartir mes a mes según el número de cuota
    // cuota 1 → base, cuota 2 → base+1 mes, etc.
    final total = totalCuotasPrestamo > 0 ? totalCuotasPrestamo : cuotas.length;

    return [
      for (var i = 0; i < cuotas.length; i++)
        CuotaPrestamoModel(
          idCuota: cuotas[i].idCuota,
          idPrestamo: cuotas[i].idPrestamo,
          numero: cuotas[i].numero,
          estado: cuotas[i].estado,
          fecha: _fechaMensual(
            base,
            (int.tryParse(cuotas[i].numero) ?? (i + 1)) - 1,
          ),
          monto: cuotas[i].monto,
          totalCuotas: total,
        ),
    ];
  }

  /// Suma [meses] a [base] sin romper el día (ej. 31 ene → 28/29 feb).
  static DateTime _fechaMensual(DateTime base, int meses) {
    final y = base.year;
    final m = base.month + meses;
    final year = y + ((m - 1) ~/ 12);
    final month = ((m - 1) % 12) + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = base.day > lastDay ? lastDay : base.day;
    return DateTime(year, month, day);
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
  return '${dias[fecha.weekday - 1]}, ${fecha.day} de ${meses[fecha.month - 1]}';
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
