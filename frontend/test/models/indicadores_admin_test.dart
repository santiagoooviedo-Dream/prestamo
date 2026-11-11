import 'package:flutter_test/flutter_test.dart';
import 'package:front_prestamo/nucleo/indicadores_admin.dart';

void main() {
  group('IndicadoresAdmin', () {
    test(
      'detecta mensajes nuevos del usuario aunque haya respuesta del bot',
      () {
        final mensajes = [
          {
            'id_mensaje': 4,
            'remitente': 'usuario',
            'respuesta': 'Necesito ayuda',
          },
          {'id_mensaje': 5, 'remitente': 'bot', 'respuesta': 'Te comunicaré'},
        ];

        expect(IndicadoresAdmin.firmaUltimoMensajeUsuario(mensajes), '4');
        expect(IndicadoresAdmin.ultimoMensajeEsUsuario(mensajes), isTrue);
      },
    );

    test('considera atendida la conversación tras una respuesta admin', () {
      final mensajes = [
        {
          'id_mensaje': 4,
          'remitente': 'usuario',
          'respuesta': 'Necesito ayuda',
        },
        {'id_mensaje': 6, 'remitente': 'admin', 'respuesta': 'Ya te ayudamos'},
      ];

      expect(IndicadoresAdmin.ultimoMensajeEsUsuario(mensajes), isFalse);
    });

    test('clasifica las solicitudes de pago como pendientes del historial', () {
      expect(
        IndicadoresAdmin.esPagoPersonal(const {
          'tipo': 'pago',
        }, 'Tu cuota fue confirmada'),
        isTrue,
      );
    });
  });
}
