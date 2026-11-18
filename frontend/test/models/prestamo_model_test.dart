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

    test('separa solicitudes rechazadas para mostrarlas en el historial', () {
      final datos = PrestamosUsuario(
        solicitudes: const [
          {
            'id_solicitud': 1,
            'estado': 'rechazada',
            'created_at': '2026-03-01',
          },
          {
            'id_solicitud': 2,
            'estado': 'pendiente',
            'created_at': '2026-04-01',
          },
          {
            'id_solicitud': 3,
            'estado': 'rechazada',
            'created_at': '2026-05-01',
          },
        ],
        prestamos: const [],
        cuotas: const [],
      );

      expect(datos.solicitudesRechazadas.map((s) => s['id_solicitud']), [3, 1]);
      expect(datos.puedeSolicitarNuevo, isFalse);
    });

    test('una solicitud rechazada no bloquea una nueva solicitud', () {
      final datos = PrestamosUsuario(
        solicitudes: const [
          {'id_solicitud': 1, 'estado': 'rechazada'},
        ],
        prestamos: const [],
        cuotas: const [],
      );

      expect(datos.puedeSolicitarNuevo, isTrue);
    });

    test('oculta las rechazadas de préstamos en curso', () {
      final datos = PrestamosUsuario(
        solicitudes: const [
          {'id_solicitud': 1, 'estado': 'rechazada'},
          {'id_solicitud': 2, 'estado': 'pendiente'},
          {'id_solicitud': 3, 'estado': 'aceptada'},
        ],
        prestamos: const [
          {'id_prestamo': 10, 'id_solicitud': 3, 'estado': 'activo'},
        ],
        cuotas: const [],
      );

      expect(datos.solicitudesEnCurso.map((s) => s['id_solicitud']), [2]);
    });
  });

  test('formatea montos y fechas para la interfaz en español', () {
    expect(formatoMontoPrestamo(1000000), '1.000.000');
    expect(formatoMontoPrestamo('600000'), '600.000');
    expect(formatoFechaPrestamo('2026-01-15'), '15 enero 2026');
    expect(formatoFechaPrestamo(null), '—');
  });
}
