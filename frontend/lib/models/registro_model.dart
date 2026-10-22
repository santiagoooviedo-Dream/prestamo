import '../nucleo/api_service.dart';
import 'contrasena_model.dart';

class RegistroModel {
  const RegistroModel();

  static bool contrasenaValida(String valor) => ContrasenaModel.esValida(valor);

  Future<void> registrar({
    required String cedula,
    required String nombres,
    required String apellidos,
    required String correo,
    required String telefono,
    required String contrasena,
  }) {
    return ApiService.registrarUsuario({
      'nombre': nombres,
      'apellido': apellidos,
      'correo': correo,
      'telefono': telefono,
      'cedula': cedula,
      'contrasena': contrasena,
    });
  }
}
