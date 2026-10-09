import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:front_prestamo/services/api_client.dart';
import 'package:front_prestamo/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'iniciar sesión envía la cédula y convierte la sesión del backend',
    () async {
      late http.Request request;
      final client = MockClient((receivedRequest) async {
        request = receivedRequest;
        return http.Response(
          jsonEncode({
            'token': 'jwt-token',
            'usuario': {
              'id_usuario': 7,
              'nombre': 'Ana',
              'apellido': 'Pérez',
              'correo': 'ana@example.com',
              'telefono': '3001234567',
              'rol': 'usuario',
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final service = AuthService(client: ApiClient(client: client));

      final sesion = await service.iniciarSesion(
        cedula: '12345678',
        contrasena: 'ClaveSegura1!',
      );

      expect(request.method, 'POST');
      expect(request.url.path, '/usuarios/login');
      expect(jsonDecode(request.body), {
        'cedula': '12345678',
        'contrasena': 'ClaveSegura1!',
      });
      expect(sesion.token, 'jwt-token');
      expect(sesion.usuario.id, '7');
      expect(sesion.usuario.nombre, 'Ana');
    },
  );

  test(
    'registro llama al endpoint de creación con los campos del usuario',
    () async {
      late http.Request request;
      final client = MockClient((receivedRequest) async {
        request = receivedRequest;
        return http.Response(
          jsonEncode({
            'mensaje': 'Usuario creado',
            'correo': 'ana@example.com',
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });
      final service = AuthService(client: ApiClient(client: client));

      await service.registrar(
        nombre: 'Ana',
        apellido: 'Pérez',
        correo: 'ana@example.com',
        telefono: '3001234567',
        cedula: '12345678',
        contrasena: 'ClaveSegura1!',
      );

      expect(request.url.path, '/usuarios/registrar');
      expect(jsonDecode(request.body), {
        'nombre': 'Ana',
        'apellido': 'Pérez',
        'correo': 'ana@example.com',
        'telefono': '3001234567',
        'cedula': '12345678',
        'contrasena': 'ClaveSegura1!',
      });
    },
  );

  test(
    'verificación y recuperación usan los endpoints y datos esperados',
    () async {
      final requests = <http.Request>[];
      final client = MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({'mensaje': 'Correcto'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final service = AuthService(client: ApiClient(client: client));

      await service.verificarRegistro(
        correo: 'ana@example.com',
        codigo: '123456',
      );
      await service.reenviarCodigoRegistro('ana@example.com');
      await service.solicitarCodigoRecuperacion('ana@example.com');
      await service.verificarCodigoRecuperacion(
        correo: 'ana@example.com',
        codigo: '654321',
      );
      await service.recuperarContrasena(
        correo: 'ana@example.com',
        codigo: '654321',
        contrasenaNueva: 'NuevaClave1!',
      );

      expect(
        requests.map((request) => '${request.method} ${request.url.path}'),
        [
          'POST /usuarios/registrar/verificar-codigo',
          'POST /usuarios/registrar/reenviar-codigo',
          'POST /usuarios/codigo',
          'POST /usuarios/verificar',
          'PUT /usuarios/recuperar',
        ],
      );
      expect(jsonDecode(requests.last.body), {
        'correo': 'ana@example.com',
        'codigo': '654321',
        'contrasenaNueva': 'NuevaClave1!',
      });
    },
  );

  test('los errores HTTP del backend se propagan como ApiException', () async {
    final client = MockClient(
      (_) async => http.Response(
        jsonEncode({'mensaje': 'Verifica tu cuenta'}),
        403,
        headers: {'content-type': 'application/json'},
      ),
    );
    final service = AuthService(client: ApiClient(client: client));

    await expectLater(
      service.iniciarSesion(cedula: '12345678', contrasena: 'ClaveSegura1!'),
      throwsA(
        isA<ApiException>()
            .having((error) => error.message, 'message', 'Verifica tu cuenta')
            .having((error) => error.statusCode, 'statusCode', 403),
      ),
    );
  });
}
