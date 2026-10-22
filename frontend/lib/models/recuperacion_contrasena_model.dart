import '../nucleo/api_service.dart';
import 'contrasena_model.dart';

class RecuperacionContrasenaModel {
  const RecuperacionContrasenaModel();

  Future<void> solicitarCodigo(String correo) {
    return ApiService.solicitarCodigoRecuperacion(correo);
  }

  Future<void> verificarCodigo(String correo, String codigo) {
    return ApiService.verificarCodigoRecuperacion(correo, codigo);
  }

  Future<void> actualizarContrasena({
    required String correo,
    required String codigo,
    required String contrasenaNueva,
  }) {
    return ApiService.recuperarContrasena(
      correo: correo,
      codigo: codigo,
      contrasenaNueva: contrasenaNueva,
    );
  }

  static bool cumpleRequisitos(String contrasena) =>
      ContrasenaModel.esValida(contrasena);
}
