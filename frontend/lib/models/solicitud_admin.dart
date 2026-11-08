class SolicitudAdmin {
  final int idSolicitud;
  final int idUsuario;
  final String nombre;
  final String apellidos;
  final int monto;
  final String estado;
  final String fecha;
  final bool pendiente;
  final String motivo;
  final int cuotas;
  final String metodoDesembolso;
  final String? telefonoNequi;

  const SolicitudAdmin({
    required this.idSolicitud,
    required this.idUsuario,
    required this.nombre,
    required this.apellidos,
    required this.monto,
    required this.estado,
    required this.fecha,
    required this.pendiente,
    required this.motivo,
    required this.cuotas,
    this.metodoDesembolso = 'efectivo',
    this.telefonoNequi,
  });

  factory SolicitudAdmin.fromJson(
    Map<String, dynamic> j, {
    Map<String, dynamic>? usuario,
  }) {
    final estado = (j['estado'] ?? 'pendiente').toString().toLowerCase();
    final nombre = usuario?['nombre']?.toString() ??
        j['nombre']?.toString() ??
        'Usuario';
    final apellido = usuario?['apellido']?.toString() ??
        j['apellido']?.toString() ??
        '#${j['id_usuario'] ?? ''}';
    return SolicitudAdmin(
      idSolicitud: int.tryParse(j['id_solicitud']?.toString() ?? '') ?? 0,
      idUsuario: int.tryParse(j['id_usuario']?.toString() ?? '') ?? 0,
      nombre: nombre,
      apellidos: apellido,
      monto: int.tryParse(j['monto_solicitado']?.toString() ?? '') ?? 0,
      estado: estado,
      fecha: j['created_at']?.toString() ?? j['fecha']?.toString() ?? '',
      pendiente: estado == 'pendiente',
      motivo: j['motivo']?.toString() ?? '',
      cuotas: int.tryParse(j['coutas']?.toString() ?? '') ?? 0,
      metodoDesembolso: j['metodo_desembolso']?.toString() ?? 'efectivo',
      telefonoNequi: j['telefono_nequi']?.toString(),
    );
  }

  static String formatoMonto(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}
