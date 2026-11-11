import 'api_service.dart';

class IndicadoresAdminResult {
  final bool prestamos;
  final bool usuarios;
  final Set<int> usuariosConPunto;

  const IndicadoresAdminResult({
    required this.prestamos,
    required this.usuarios,
    required this.usuariosConPunto,
  });
}

class IndicadoresUsuarioResult {
  final bool solicitudes;
  final bool soporte;
  final bool historial;

  const IndicadoresUsuarioResult({
    required this.solicitudes,
    required this.soporte,
    required this.historial,
  });
}

/// Puntos rojos del admin.
class IndicadoresAdmin {
  IndicadoresAdmin._();

  static bool solicitudPendiente(Map<String, dynamic> s) {
    final e = (s['estado'] ?? '').toString().toLowerCase().trim();
    return e == 'pendiente';
  }

  static int? idUsuarioDe(Map<String, dynamic> m) {
    final raw =
        m['id_usuario'] ??
        m['usuario_id'] ??
        (m['usuario'] is Map ? m['usuario']['id_usuario'] : null);
    if (raw == null) return null;
    if (raw is int) return raw;
    return int.tryParse(raw.toString());
  }

  static String idConvDe(Map<String, dynamic> c) {
    final raw = c['id_conversacion'] ?? c['id'];
    return raw?.toString() ?? '';
  }

  static bool esChatAdmin(Map<String, dynamic> c) {
    final modo = (c['modo'] ?? '').toString().toLowerCase().trim();
    return modo == 'admin' ||
        modo == 'administrador' ||
        modo == 'soporte' ||
        modo.contains('admin');
  }

  static Future<List<Map<String, dynamic>>> _mensajesConv(String idConv) async {
    try {
      return await ApiService.obtenerMensajesConversacion(idConv);
    } catch (_) {
      return [];
    }
  }

  static String? firmaUltimoMensajeUsuario(
    List<Map<String, dynamic>> mensajes,
  ) {
    for (final mensaje in mensajes.reversed) {
      if (!esMensajeUsuario(mensaje)) continue;
      final id = mensaje['id_mensaje'] ?? mensaje['id'];
      if (id != null) return id.toString();
      final fecha = mensaje['fecha']?.toString() ?? '';
      final texto =
          mensaje['respuesta'] ??
          mensaje['mensaje'] ??
          mensaje['contenido'] ??
          '';
      return '$fecha|$texto';
    }
    return null;
  }

  static bool esMensajeUsuario(Map<String, dynamic> mensaje) {
    final remitente =
        (mensaje['remitente'] ?? mensaje['rol'] ?? mensaje['tipo'] ?? '')
            .toString()
            .toLowerCase()
            .trim();
    return remitente.isEmpty ||
        (remitente != 'admin' &&
            remitente != 'administrador' &&
            remitente != 'agente' &&
            remitente != 'bot');
  }

  static bool ultimoMensajeEsUsuario(List<Map<String, dynamic>> mensajes) {
    for (final mensaje in mensajes.reversed) {
      final remitente =
          (mensaje['remitente'] ?? mensaje['rol'] ?? mensaje['tipo'] ?? '')
              .toString()
              .toLowerCase()
              .trim();
      if (remitente == 'bot') continue;
      return esMensajeUsuario(mensaje);
    }
    return false;
  }

  static bool esPagoPersonal(Map<String, dynamic> conversacion, String textos) {
    final texto =
        [
              textos,
              conversacion['asunto'],
              conversacion['descripcion'],
              conversacion['tipo'],
              conversacion['modo'],
              conversacion['categoria'],
              conversacion['origen'],
            ]
            .whereType<Object>()
            .map((valor) => valor.toString().toLowerCase())
            .join(' ');
    final tipo = (conversacion['tipo'] ?? conversacion['categoria'] ?? '')
        .toString()
        .toLowerCase();
    return texto.contains('pago personal') ||
        texto.contains('pago presencial') ||
        texto.contains('pagar en persona') ||
        texto.contains('pagar mi cuota') ||
        texto.contains('quiero pagar') ||
        texto.contains('ref_pago') ||
        texto.contains('ref_nequi') ||
        texto.contains('pago por nequi') ||
        texto.contains('comprobante') ||
        texto.contains('id_prestamo') ||
        texto.contains('id_cuota') ||
        tipo.contains('pago') ||
        tipo == 'personal' ||
        tipo == 'presencial' ||
        conversacion['id_prestamo'] != null ||
        conversacion['id_cuota'] != null;
  }

  static bool pagoValidado(String textos) {
    final lower = textos.toLowerCase();
    return lower.contains('pago personal fue validado') ||
        lower.contains('pago nequi verificado') ||
        lower.contains('pago verificado') ||
        lower.contains('queda registrada como pagada') ||
        lower.contains('cuota ya quedó registrada');
  }

  static bool _pagoPendiente(
    Map<String, dynamic> conversacion,
    List<Map<String, dynamic>> mensajes,
    String textos,
  ) {
    if (!esPagoPersonal(conversacion, textos)) return false;
    var solicitudPago = -1;
    var ultimoUsuario = -1;
    var validacion = -1;
    for (var i = 0; i < mensajes.length; i++) {
      final mensaje = mensajes[i];
      final texto =
          (mensaje['respuesta'] ??
                  mensaje['mensaje'] ??
                  mensaje['contenido'] ??
                  '')
              .toString()
              .toLowerCase();
      if (esMensajeUsuario(mensaje)) {
        ultimoUsuario = i;
        if (texto.contains('pago') ||
            texto.contains('cuota') ||
            texto.contains('comprobante') ||
            texto.contains('ref_')) {
          solicitudPago = i;
        }
      } else if (pagoValidado(texto)) {
        validacion = i;
      }
    }

    final tipo = (conversacion['tipo'] ?? conversacion['categoria'] ?? '')
        .toString()
        .toLowerCase();
    if (solicitudPago >= 0) return solicitudPago > validacion;
    if (tipo.contains('pago') || tipo == 'personal' || tipo == 'presencial') {
      return ultimoUsuario > validacion;
    }
    return validacion < 0 && !pagoValidado(textos);
  }

  /// Hay algo pendiente si el último mensaje lo envió el usuario y el admin
  /// todavía no abrió esa actualización.
  static Future<({bool pendiente, bool pago})> _estadoConversacion(
    Map<String, dynamic> c,
    Map<String, String> revisadas,
  ) async {
    final idConv = idConvDe(c);
    if (idConv.isEmpty || !esChatAdmin(c)) {
      return (pendiente: false, pago: false);
    }

    final mensajes = await _mensajesConv(idConv);
    final firma = firmaUltimoMensajeUsuario(mensajes);
    final revisada = revisadas[idConv];
    if (firma != null && revisada == '*') {
      await ApiService.marcarConversacionRevisada(
        idConv,
        ultimoMensajeUsuario: firma,
      );
    }
    final textos = mensajes
        .map(
          (mensaje) =>
              (mensaje['respuesta'] ??
                      mensaje['mensaje'] ??
                      mensaje['contenido'] ??
                      '')
                  .toString(),
        )
        .join(' ');
    final ultimoEsUsuario = ultimoMensajeEsUsuario(mensajes);
    return (
      pendiente:
          firma != null &&
          ultimoEsUsuario &&
          revisada != '*' &&
          revisada != firma,
      pago: _pagoPendiente(c, mensajes, textos),
    );
  }

  static Future<IndicadoresAdminResult> cargar() async {
    final usuariosConPunto = <int>{};
    var prestamos = false;

    try {
      final sols = await ApiService.obtenerSolicitudesAdmin();
      for (final s in sols) {
        if (!solicitudPendiente(s)) continue;
        prestamos = true;
        final id = idUsuarioDe(s);
        if (id != null) usuariosConPunto.add(id);
      }
    } catch (_) {}

    try {
      final revisadas = await ApiService.obtenerConversacionesRevisadas();
      final convs = await ApiService.obtenerConversacionesAdmin();
      final adminConvs = convs.where(esChatAdmin).toList();
      final flags = await Future.wait(
        adminConvs.map((c) async {
          final estado = await _estadoConversacion(c, revisadas);
          if (!estado.pendiente && !estado.pago) return null;
          return (
            id: idUsuarioDe(c),
            soporte: estado.pendiente,
            pago: estado.pago,
          );
        }),
      );
      for (final flag in flags) {
        if (flag == null) continue;
        if (flag.id != null && (flag.soporte || flag.pago)) {
          usuariosConPunto.add(flag.id!);
        }
        if (flag.pago) prestamos = true;
      }
    } catch (_) {}

    return IndicadoresAdminResult(
      prestamos: prestamos,
      usuarios: usuariosConPunto.isNotEmpty,
      usuariosConPunto: usuariosConPunto,
    );
  }

  static Future<IndicadoresUsuarioResult> cargarDeUsuario(int idUsuario) async {
    var solicitudes = false;
    var soporte = false;
    var historial = false;

    try {
      final sols = await ApiService.obtenerSolicitudesAdmin();
      for (final s in sols) {
        if (idUsuarioDe(s) == idUsuario && solicitudPendiente(s)) {
          solicitudes = true;
          break;
        }
      }
    } catch (_) {}

    try {
      final revisadas = await ApiService.obtenerConversacionesRevisadas();
      final convs = await ApiService.obtenerConversacionesAdmin();
      final delUser = convs.where(
        (c) => idUsuarioDe(c) == idUsuario && esChatAdmin(c),
      );
      for (final c in delUser) {
        final estado = await _estadoConversacion(c, revisadas);
        if (estado.pendiente) soporte = true;
        if (estado.pago) historial = true;
      }
    } catch (_) {}

    return IndicadoresUsuarioResult(
      solicitudes: solicitudes,
      soporte: soporte,
      historial: historial,
    );
  }
}
