import '../nucleo/api_service.dart';

class UsuarioModel {
  const UsuarioModel();

  Future<Map<String, dynamic>> iniciarSesion(String cedula, String contrasena) {
    return ApiService.iniciarSesion(cedula, contrasena);
  }

  Future<Map<String, dynamic>> obtenerPerfil() {
    return ApiService.obtenerPerfil();
  }

  Future<void> cambiarCorreo({
    required String nuevoCorreo,
    required String contrasena,
  }) {
    return ApiService.cambiarCorreo(
      nuevoCorreo: nuevoCorreo,
      contrasena: contrasena,
    );
  }

  Future<void> cambiarContrasena({
    required String contrasenaActual,
    required String contrasenaNueva,
  }) {
    return ApiService.cambiarContrasena(
      contrasenaActual: contrasenaActual,
      contrasenaNueva: contrasenaNueva,
    );
  }

  Future<void> cerrarSesion() => ApiService.cerrarSesion();
}
