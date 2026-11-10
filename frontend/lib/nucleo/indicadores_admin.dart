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
    final raw = m['id_usuario'] ??
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

  static bool _textoYaValidado(String texto) {
    final t = texto.toLowerCase();
    return t.contains('pago verificado') ||
        t.contains('pago nequi verificado') ||
        t.contains('fue validado') ||
        t.contains('nequi verificado') ||
        t.contains('queda registrada como pagada') ||
        t.contains('cuota ya quedó registrada') ||
        t.contains('validado correctamente');
  }

  static Future<String> _textosConv(String idConv) async {
    try {
      final msgs = await ApiService.obtenerMensajesConversacion(idConv);
      if (msgs.isEmpty) return '';
      final b = StringBuffer();
      for (final m in msgs) {
        b.write(' ${m['mensaje'] ?? ''}');
        b.write(' ${m['respuesta'] ?? ''}');
        b.write(' ${m['contenido'] ?? ''}');
      }
      return b.toString().trim();
    } catch (_) {
      return '';
    }
  }

  /// true solo si hay algo real por atender (no vacío, no verificado, no leído).
  static Future<bool> _convPendienteReal(
    Map<String, dynamic> c,
    Set<String> revisadas,
  ) async {
    final idConv = idConvDe(c);
    if (idConv.isEmpty) return false;
    if (revisadas.contains(idConv)) return false;
    if (!esChatAdmin(c)) return false;

    final textos = await _textosConv(idConv);
    if (textos.isEmpty) return false;
    if (_textoYaValidado(textos)) {
      // Ya está verificado: marcarlo leído para no volver a marcar punto
      try {
        await ApiService.marcarConversacionRevisada(idConv);
      } catch (_) {}
      return false;
    }
    return true;
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
          final pend = await _convPendienteReal(c, revisadas);
          if (!pend) return null;
          return idUsuarioDe(c);
        }),
      );
      for (final id in flags) {
        if (id != null) usuariosConPunto.add(id);
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
      final delUser =
          convs.where((c) => idUsuarioDe(c) == idUsuario && esChatAdmin(c));
      for (final c in delUser) {
        if (await _convPendienteReal(c, revisadas)) {
          soporte = true;
          break;
        }
      }
    } catch (_) {}

    return IndicadoresUsuarioResult(
      solicitudes: solicitudes,
      soporte: soporte,
      historial: false,
    );
  }
}
