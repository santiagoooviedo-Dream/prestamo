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
      final estadoCuota = (cuota['estado'] ?? '').toString().toLowerCase();
      return estadoCuota == 'pagada' ||
          estadoCuota == 'pagado' ||
          estadoCuota.contains('pagad') ||
          estadoCuota == 'completada' ||
          estadoCuota == 'completado';
    }).length;
    return cuotasPagadas >= totalCuotas;
  }

  /// Solo se permite una solicitud/préstamo activo a la vez.
  bool get puedeSolicitarNuevo {
    if (prestamosActivos.isNotEmpty) return false;
    for (final s in solicitudes) {
      final estado = (s['estado'] ?? '').toString().toLowerCase();
      if (estado == 'pendiente') return false;
      if (estado == 'aceptada') {
        final idS = s['id_solicitud']?.toString();
        final yaTiene = prestamos.any(
          (p) => p['id_solicitud']?.toString() == idS,
        );
        if (!yaTiene) return false;
      }
    }
    return true;
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

/// Tasa por defecto de la app (10 %).
const double tasaInteresApp = 0.10;

/// Lee la tasa del préstamo. Si no viene o es 0, usa 10 %.
double tasaDelPrestamo(Map<String, dynamic> prestamo) {
  final raw = num.tryParse(
    prestamo['interes']?.toString() ??
        prestamo['tasa_interes']?.toString() ??
        prestamo['tasa']?.toString() ??
        '',
  );
  if (raw == null || raw == 0) return tasaInteresApp;
  return raw > 1 ? raw / 100.0 : raw.toDouble();
}

/// Número de cuotas del préstamo.
int numeroCuotasPrestamo(
  Map<String, dynamic> prestamo, [
  List<Map<String, dynamic>>? cuotas,
]) {
  return int.tryParse(
        prestamo['coutas']?.toString() ??
            prestamo['cuotas']?.toString() ??
            prestamo['numero_cuotas']?.toString() ??
            '',
      ) ??
      (cuotas?.length ?? 0);
}

/// Cuota mensual con el 10 % incluido.
/// Si el backend guardó la cuota sin interés, la corrige.
num cuotaMensualConInteres(
  Map<String, dynamic> prestamo, [
  List<Map<String, dynamic>>? cuotas,
]) {
  final monto = num.tryParse(prestamo['monto']?.toString() ?? '0') ?? 0;
  final n = numeroCuotasPrestamo(prestamo, cuotas);
  final tasa = tasaDelPrestamo(prestamo);

  var cuota = num.tryParse(
    prestamo['coutas_mensual']?.toString() ??
        prestamo['cuota_mensual']?.toString() ??
        '',
  );

  if (monto > 0 && n > 0) {
    final esperada = (monto * (1 + tasa)) / n;
    if (cuota == null || cuota < esperada * 0.95) {
      cuota = esperada;
    }
  }

  if ((cuota == null || cuota <= 0) && cuotas != null && cuotas.isNotEmpty) {
    final montos = cuotas
        .map((c) => num.tryParse(c['monto']?.toString() ?? '') ?? 0)
        .where((m) => m > 0)
        .toList();
    if (montos.isNotEmpty) {
      // Si las cuotas del API tampoco traen interés, promedia con interés
      final suma = montos.fold<num>(0, (s, m) => s + m);
      if (monto > 0 && n > 0) {
        final totalEsperado = monto * (1 + tasa);
        if (suma < totalEsperado * 0.95) {
          return totalEsperado / n;
        }
      }
      cuota = montos.first;
    }
  }

  return cuota ?? 0;
}
