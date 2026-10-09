class Usuario {
  final String? id;
  final String nombre;
  final String apellido;
  final String correo;
  final String telefono;
  final String rol;

  const Usuario({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.telefono,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id_usuario']?.toString(),
      nombre: json['nombre'] as String? ?? '',
      apellido: json['apellido'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      telefono: json['telefono']?.toString() ?? '',
      rol: json['rol'] as String? ?? 'usuario',
    );
  }
}

class Sesion {
  final String token;
  final Usuario usuario;

  const Sesion({required this.token, required this.usuario});

  factory Sesion.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    final usuario = json['usuario'];
    if (token is! String || usuario is! Map<String, dynamic>) {
      throw const FormatException('La respuesta de inicio de sesión no es válida.');
    }

    return Sesion(
      token: token,
      usuario: Usuario.fromJson(usuario),
    );
  }
}
