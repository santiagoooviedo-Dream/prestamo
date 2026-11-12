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

  /// Cuotas del préstamo activo.
  /// - Primera cuota: mes siguiente a la fecha de inicio (día 15).
  /// - Monto: aplica 10% de interés si el backend no lo trajo.
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
        int.tryParse(activo['coutas']?.toString() ??
                activo['cuotas']?.toString() ??
                activo['numero_cuotas']?.toString() ??
                '') ??
            0;

    var cuotas = cuotasRaw
        .where((c) => c['id_prestamo']?.toString() == idActivo)
        .map(CuotaPrestamoModel.desdeApi)
        .toList();

    cuotas.sort((a, b) {
      final na = int.tryParse(a.numero) ?? 0;
      final nb = int.tryParse(b.numero) ?? 0;
      return na.compareTo(nb);
    });

    if (cuotas.isEmpty) return [];

    final total = totalCuotasPrestamo > 0 ? totalCuotasPrestamo : cuotas.length;

    // Primer pago = mes siguiente al inicio / desembolso (día 15)
    final inicioRaw =
        DateTime.tryParse(activo['fecha_inicio']?.toString() ?? '');
    final base = _basePrimerPago(inicioRaw);

    // Interés 10%
    final montoPrestamo =
        double.tryParse(activo['monto']?.toString() ?? '0') ?? 0;
    final tasaRaw = double.tryParse(
      activo['interes']?.toString() ??
          activo['tasa_interes']?.toString() ??
          '0.10',
    );
    double tasa = 0.10;
    if (tasaRaw != null && tasaRaw > 0) {
      tasa = tasaRaw > 1 ? tasaRaw / 100.0 : tasaRaw;
    }

    // Siempre corregir montos si no incluyen el 10 % (todas las cuotas)
    List<int>? montosCorregidos;
    if (montoPrestamo > 0 && total > 0) {
      final totalConInteres = (montoPrestamo * (1 + tasa)).round();
      final sumaActual = cuotas.fold<double>(0, (s, c) => s + c.monto);
      final promedioEsperado = totalConInteres / total;
      final algunaBaja = cuotas.any((c) => c.monto < promedioEsperado * 0.95);
      if (sumaActual < totalConInteres * 0.95 || algunaBaja) {
        montosCorregidos = _montosCuotasRedondeados(totalConInteres, total);
      }
    }

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
          monto: montosCorregidos != null && i < montosCorregidos.length
              ? montosCorregidos[i].toDouble()
              : cuotas[i].monto,
          totalCuotas: total,
        ),
    ];
  }

  static DateTime _basePrimerPago(DateTime? fechaInicio) {
    final ref = fechaInicio ?? DateTime.now();
    return DateTime(ref.year, ref.month + 1, 15);
  }

  static DateTime _fechaMensual(DateTime base, int meses) {
    final y = base.year;
    final m = base.month + meses;
    final year = y + ((m - 1) ~/ 12);
    final month = ((m - 1) % 12) + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = base.day > lastDay ? lastDay : base.day;
    return DateTime(year, month, day);
  }

  static List<int> _montosCuotasRedondeados(int total, int n) {
    if (n <= 0) return const [];
    if (n == 1) return [total];
    final crudo = total / n;
    var base = ((crudo / 100).round() * 100);
    if (base <= 0) base = total ~/ n;
    final lista = List<int>.filled(n, base);
    final sumaParcial = base * (n - 1);
    lista[n - 1] = total - sumaParcial;
    if (lista[n - 1] <= 0) {
      final b = total ~/ n;
      final r = total - b * n;
      return [for (var i = 0; i < n; i++) i == n - 1 ? b + r : b];
    }
    return lista;
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
