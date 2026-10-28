import 'package:flutter_test/flutter_test.dart';
import 'package:front_prestamo/models/prestamo_model.dart';

void main() {
  group('PrestamosUsuario', () {
    test('separa préstamos completos usando el estado de sus cuotas', () {
      final datos = PrestamosUsuario(
        solicitudes: const [],
        prestamos: [
          {
            'id_prestamo': 1,
            'estado': 'activo',
            'coutas': 2,
            'fecha_inicio': '2026-03-01',
          },
          {
            'id_prestamo': 2,
            'estado': 'activo',
            'coutas': 2,
            'fecha_inicio': '2026-04-01',
          },
        ],
        cuotas: [
          {'id_prestamo': 1, 'estado': 'pagada'},
          {'id_prestamo': 1, 'estado': 'pagada'},
          {'id_prestamo': 2, 'estado': 'pagada'},
          {'id_prestamo': 2, 'estado': 'pendiente'},
        ],
      );

      expect(datos.prestamosAnteriores.map((p) => p['id_prestamo']), [1]);
      expect(datos.prestamosActivos.map((p) => p['id_prestamo']), [2]);
    });

    test('no marca como completo un préstamo con cuotas faltantes', () {
      final datos = PrestamosUsuario(
        solicitudes: const [],
        prestamos: const [
          {'id_prestamo': 1, 'estado': 'activo', 'coutas': 2},
        ],
        cuotas: const [
          {'id_prestamo': 1, 'estado': 'pagada'},
        ],
      );

      expect(datos.prestamosAnteriores, isEmpty);
      expect(datos.prestamosActivos, hasLength(1));
    });
  });

  test('formatea montos y fechas para la interfaz en español', () {
    expect(formatoMontoPrestamo(1000000), '1.000.000');
    expect(formatoMontoPrestamo('600000'), '600.000');
    expect(formatoFechaPrestamo('2026-01-15'), '15 enero 2026');
    expect(formatoFechaPrestamo(null), '—');
  });
}
