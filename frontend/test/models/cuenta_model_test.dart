import 'package:flutter_test/flutter_test.dart';
import 'package:front_prestamo/models/calendario_pagos_model.dart';
import 'package:front_prestamo/models/cuenta_model.dart';
import 'package:front_prestamo/models/solicitud_prestamo_model.dart';

void main() {
  group('Modelos de préstamos y cuenta', () {
    test('valida montos, cuotas y teléfonos de desembolso', () {
      expect(SolicitudPrestamoModel.esMontoValido(100000), isTrue);
      expect(SolicitudPrestamoModel.esMontoValido(3000000), isTrue);
      expect(SolicitudPrestamoModel.esMontoValido(99999), isFalse);
      expect(SolicitudPrestamoModel.sonCuotasValidas(2), isTrue);
      expect(SolicitudPrestamoModel.sonCuotasValidas(37), isFalse);
      expect(
        SolicitudPrestamoModel.esTelefonoNequiValido('3001234567'),
        isTrue,
      );
      expect(
        SolicitudPrestamoModel.esTelefonoNequiValido('2001234567'),
        isFalse,
      );
    });

    test('calcula resumen y siguiente cuota desde los datos del backend', () {
      final estado = CuentaEstado(
        prestamos: [
          {'monto': 500000},
          {'monto': '250000'},
        ],
        cuotas: [
          {'estado': 'pagada', 'fecha_pago': '2026-10-01'},
          {
            'estado': 'pendiente',
            'fecha_pago': '2026-11-01',
            'numero_cuota': 2,
          },
        ],
        movimientos: const [],
      );

      expect(estado.montoTotal, 750000);
      expect(estado.cuotasPagadas, 1);
      expect(estado.totalCuotas, 2);
      expect(estado.proximaCuota?['numero_cuota'], 2);
    });

    test('convierte los datos de cuota recibidos por la API', () {
      final cuota = CuotaPrestamoModel.desdeApi({
        'numero_cuota': 3,
        'estado': 'pendiente',
        'fecha_pago': '2026-11-20',
        'monto': 200000,
      });

      expect(cuota.numero, '3');
      expect(cuota.estado, 'pendiente');
      expect(cuota.fecha, DateTime(2026, 11, 20));
      expect(cuota.monto, 200000);
    });
  });
}
