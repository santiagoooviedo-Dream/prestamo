import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';

class MovimientoCuenta {
  final String titulo;
  final String descripcion;
  final String fecha;
  final double monto;
  final bool positivo;
  final IconData icono;

  const MovimientoCuenta({
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.monto,
    required this.positivo,
    required this.icono,
  });

  factory MovimientoCuenta.desdeApi(Map<String, dynamic> datos) {
    final tipo = datos['tipo']?.toString() ?? 'info';
    final descripcion =
        datos['description']?.toString() ??
        datos['descripcion']?.toString() ??
        'Movimiento de cuenta';
    final fecha =
        datos['fecha']?.toString() ??
        datos['created_at']?.toString() ??
        datos['fecha_pago']?.toString() ??
        '';
    final monto = double.tryParse(datos['monto']?.toString() ?? '') ?? 0;
    return MovimientoCuenta(
      titulo: _titulo(tipo, descripcion),
      descripcion: descripcion,
      fecha: fecha,
      monto: monto,
      positivo: tipo != 'pago',
      icono: tipo == 'pago'
          ? Icons.calendar_today_outlined
          : Icons.south_west_rounded,
    );
  }

  static String _titulo(String tipo, String descripcion) {
    if (tipo == 'pago') return 'Pago de cuota';
    if (tipo == 'desembolso') return 'Desembolso';
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

  int get cuotasPagadas =>
      cuotas.where((cuota) => cuota['estado'] == 'pagada').length;

  int get totalCuotas => cuotas.length;

  Map<String, dynamic>? get proximaCuota {
    final pendientes =
        cuotas.where((cuota) => cuota['estado'] != 'pagada').toList()
          ..sort((a, b) {
            final fechaA = DateTime.tryParse(a['fecha_pago']?.toString() ?? '');
            final fechaB = DateTime.tryParse(b['fecha_pago']?.toString() ?? '');
            if (fechaA == null) return 1;
            if (fechaB == null) return -1;
            return fechaA.compareTo(fechaB);
          });
    return pendientes.isEmpty ? null : pendientes.first;
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
