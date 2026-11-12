import '../nucleo/api_service.dart';

class UsuarioModel {
  const UsuarioModel();

  Future<Map<String, dynamic>> iniciarSesion(String cedula, String contrasena) {
    return ApiService.iniciarSesion(cedula, contrasena);
  }

  Future<Map<String, dynamic>> obtenerPerfil() {
    return ApiService.obtenerPerfil();
  }

  Future<Map<String, dynamic>> solicitarCambioCorreo({
    required String nuevoCorreo,
    required String contrasena,
  }) {
    return ApiService.solicitarCambioCorreo(
      nuevoCorreo: nuevoCorreo,
      contrasena: contrasena,
    );
  }

  Future<void> verificarCambioCorreo({
    required String tokenVerificacion,
    required String codigo,
  }) {
    return ApiService.verificarCambioCorreo(
      tokenVerificacion: tokenVerificacion,
      codigo: codigo,
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
