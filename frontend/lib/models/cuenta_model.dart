import '../nucleo/api_service.dart';

class MovimientoCuenta {
  final String titulo;
  final String descripcion;
  final String fecha;
  final DateTime? fechaDate;
  final double monto;
  final bool positivo;
  /// pago | interes | desembolso | otro
  final String tipoIcono;
  final String tipo;

  const MovimientoCuenta({
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.fechaDate,
    required this.monto,
    required this.positivo,
    required this.tipoIcono,
    required this.tipo,
  });

  factory MovimientoCuenta.desdeApi(Map<String, dynamic> datos) {
    final tipo = (datos['tipo']?.toString() ?? 'info').toLowerCase();
    final descripcion = datos['description']?.toString() ??
        datos['descripcion']?.toString() ??
        'Movimiento de cuenta';
    final fechaRaw = datos['fecha']?.toString() ??
        datos['created_at']?.toString() ??
        datos['fecha_pago']?.toString() ??
        '';
    final fechaDate = DateTime.tryParse(fechaRaw);
    final monto = double.tryParse(datos['monto']?.toString() ?? '') ?? 0;
    final esPago = tipo == 'pago' || tipo.contains('pago');
    final esInteres = tipo.contains('interes') || tipo.contains('interés');
    final esDesembolso = tipo == 'desembolso' || tipo.contains('desembolso');

    final tipoIcono = esPago
        ? 'pago'
        : esInteres
            ? 'interes'
            : esDesembolso
                ? 'desembolso'
                : 'otro';

    return MovimientoCuenta(
      titulo: _titulo(tipo, descripcion),
      descripcion: _subtitulo(tipo, descripcion),
      fecha: fechaRaw,
      fechaDate: fechaDate,
      monto: monto.abs(),
      positivo: !esPago && !esInteres,
      tipoIcono: tipoIcono,
      tipo: tipo,
    );
  }

  static String _titulo(String tipo, String descripcion) {
    if (tipo.contains('pago')) return 'Pago de cuota';
    if (tipo.contains('desembolso')) return 'Desembolso';
    if (tipo.contains('interes') || tipo.contains('interés')) {
      return 'Interés aplicado';
    }
    if (descripcion.trim().isNotEmpty) return descripcion;
    return 'Movimiento';
  }

  static String _subtitulo(String tipo, String descripcion) {
    if (tipo.contains('desembolso')) return 'Préstamo personal';
    if (tipo.contains('interes') || tipo.contains('interés')) {
      return 'Interés mensual';
    }
    if (tipo.contains('pago')) {
      final match = RegExp(r'(\d+)').firstMatch(descripcion);
      if (match != null) return 'Cuota #${match.group(1)} de tu préstamo';
      return 'Cuota de tu préstamo';
    }
    return descripcion;
  }
}

class CuentaEstado {
  final List<Map<String, dynamic>> prestamos;
  final List<Map<String, dynamic>> cuotas;
  final List<MovimientoCuenta> movimientos;

  const CuentaEstado({
    required this.prestamos,
    required this.cuotas,
    required this.movimientos,
  });

  double get montoTotal => prestamos.fold<double>(
        0,
        (total, prestamo) =>
            total + (double.tryParse(prestamo['monto']?.toString() ?? '') ?? 0),
      );

  int get cuotasPagadas => cuotas.where((cuota) {
        final e = (cuota['estado'] ?? '').toString().toLowerCase();
        return e == 'pagada' || e == 'pagado';
      }).length;

  int get totalCuotas => cuotas.length;

  Map<String, dynamic>? get proximaCuota {
    final pendientes = cuotas.where((cuota) {
      final e = (cuota['estado'] ?? '').toString().toLowerCase();
      return e != 'pagada' && e != 'pagado';
    }).toList()
      ..sort((a, b) {
        final fechaA = DateTime.tryParse(a['fecha_pago']?.toString() ?? '');
        final fechaB = DateTime.tryParse(b['fecha_pago']?.toString() ?? '');
        if (fechaA == null) return 1;
        if (fechaB == null) return -1;
        return fechaA.compareTo(fechaB);
      });
    return pendientes.isEmpty ? null : pendientes.first;
  }

  List<MovimientoCuenta> get movimientosRecientes {
    final lista = List<MovimientoCuenta>.from(movimientos);
    lista.sort((a, b) {
      if (a.fechaDate == null) return 1;
      if (b.fechaDate == null) return -1;
      return b.fechaDate!.compareTo(a.fechaDate!);
    });
    return lista.take(3).toList();
  }
}

class CuentaModel {
  const CuentaModel();

  Future<CuentaEstado> cargar() async {
    final datos = await Future.wait([
      ApiService.obtenerPrestamos(),
      ApiService.obtenerCuotas(),
      ApiService.obtenerMovimientos(),
    ]);
    return CuentaEstado(
      prestamos: datos[0],
      cuotas: datos[1],
      movimientos: datos[2].map(MovimientoCuenta.desdeApi).toList(),
    );
  }
}

String formatoMontoCuenta(num valor) {
  final entero = valor.round().abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < entero.length; i++) {
    if (i > 0 && (entero.length - i) % 3 == 0) b.write('.');
    b.write(entero[i]);
  }
  return b.toString();
}

String formatoFechaCortaCuenta(DateTime? fecha) {
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

String formatoFechaHoraCuenta(DateTime? fecha) {
  if (fecha == null) return '';
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
  final h = fecha.hour % 12 == 0 ? 12 : fecha.hour % 12;
  final m = fecha.minute.toString().padLeft(2, '0');
  final ampm = fecha.hour >= 12 ? 'p. m.' : 'a. m.';
  return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year} · $h:$m $ampm';
}

String nombreMesAnio(DateTime fecha) {
  const meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  return '${meses[fecha.month - 1]} ${fecha.year}';
}
