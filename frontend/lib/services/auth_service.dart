import '../models/usuario.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _client;

  AuthService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<Sesion> iniciarSesion({
    required String cedula,
    required String contrasena,
  }) async {
    final response = await _client.post(
      '/usuarios/login',
      body: {'cedula': cedula, 'contrasena': contrasena},
    );
    return Sesion.fromJson(response);
  }

  Future<void> registrar({
    required String nombre,
    required String apellido,
    required String correo,
    required String telefono,
    required String cedula,
    required String contrasena,
  }) async {
    await _client.post(
      '/usuarios/registrar',
      body: {
        'nombre': nombre,
        'apellido': apellido,
        'correo': correo,
        'telefono': telefono,
        'cedula': cedula,
        'contrasena': contrasena,
      },
    );
  }

  Future<void> verificarRegistro({
    required String correo,
    required String codigo,
  }) async {
    await _client.post(
      '/usuarios/registrar/verificar-codigo',
      body: {'correo': correo, 'codigo': codigo},
    );
  }

  Future<void> reenviarCodigoRegistro(String correo) async {
    await _client.post(
      '/usuarios/registrar/reenviar-codigo',
      body: {'correo': correo},
    );
  }

  Future<void> solicitarCodigoRecuperacion(String correo) async {
    await _client.post('/usuarios/codigo', body: {'correo': correo});
  }

  Future<void> verificarCodigoRecuperacion({
    required String correo,
    required String codigo,
  }) async {
    await _client.post(
      '/usuarios/verificar',
      body: {'correo': correo, 'codigo': codigo},
    );
  }

  Future<void> recuperarContrasena({
    required String correo,
    required String codigo,
    required String contrasenaNueva,
  }) async {
    await _client.put(
      '/usuarios/recuperar',
      body: {
        'correo': correo,
        'codigo': codigo,
        'contrasenaNueva': contrasenaNueva,
      },
    );
  }
}
