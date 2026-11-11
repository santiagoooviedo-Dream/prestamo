import 'package:flutter_test/flutter_test.dart';
import 'package:front_prestamo/models/notificacion_model.dart';

void main() {
  group('NotificacionModel', () {
    test('clasifica las respuestas de solicitudes en préstamos', () {
      final notificacion = NotificacionModel.desdeApi({
        'tipo': 'solicitud',
        'mensaje': 'Tu solicitud fue aprobada en 12 cuotas.',
        'leida': false,
      });

      expect(notificacion.categoria, 'prestamos');
      expect(notificacion.leida, isFalse);
    });

    test('clasifica los mensajes del administrador como generales', () {
      final notificacion = NotificacionModel.desdeApi({
        'tipo': 'admin',
        'mensaje': 'Recordatorio\n\nRevisa tu cuenta.',
        'leida': 'true',
      });

      expect(notificacion.categoria, 'generales');
      expect(notificacion.leida, isTrue);
      expect(notificacion.titulo, 'Recordatorio');
      expect(notificacion.cuerpo, 'Revisa tu cuenta.');
    });

    test('conserva los avisos de pago en la categoría de pagos', () {
      final notificacion = NotificacionModel.desdeApi({
        'tipo': 'pago',
        'mensaje': 'Tu cuota fue recibida.',
        'leida': 0,
      });

      expect(notificacion.categoria, 'pagos');
      expect(notificacion.leida, isFalse);
    });
  });
}
