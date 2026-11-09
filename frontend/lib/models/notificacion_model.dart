import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';

class NotificacionModel {
  final String id;
  final String titulo;
  final String cuerpo;
  final String tiempo;
  final IconData icono;
  final String categoria;
  final bool leida;

  const NotificacionModel({
    required this.id,
    required this.titulo,
    required this.cuerpo,
    required this.tiempo,
    required this.icono,
    required this.categoria,
    required this.leida,
  });

  factory NotificacionModel.desdeApi(Map<String, dynamic> dato) {
    final tipo = (dato['tipo']?.toString() ?? 'info').toLowerCase();
    final mensajeRaw =
        dato['mensaje']?.toString() ?? 'Tienes una nueva notificación.';

    // Formato admin: "Título\n\nCuerpo"
    String titulo;
    String cuerpo;
    final sep = mensajeRaw.indexOf('\n\n');
    if (sep > 0) {
      titulo = mensajeRaw.substring(0, sep).trim();
      cuerpo = mensajeRaw.substring(sep + 2).trim();
      if (titulo.isEmpty) titulo = 'Notificación';
      if (cuerpo.isEmpty) cuerpo = mensajeRaw;
    } else {
      // Notificaciones del sistema (sin título propio)
      final lower = mensajeRaw.toLowerCase();
      if (lower.contains('aprob')) {
        titulo = 'Solicitud aprobada';
      } else if (lower.contains('rechaz')) {
        titulo = 'Solicitud rechazada';
      } else if (tipo == 'pago') {
        titulo = 'Actualización de pago';
      } else if (tipo == 'admin') {
        titulo = 'Mensaje del administrador';
      } else {
        titulo = 'Notificación';
      }
      cuerpo = mensajeRaw;
    }

    final fecha = DateTime.tryParse(dato['fecha']?.toString() ?? '');
    final local = fecha?.toLocal();

    return NotificacionModel(
      id: dato['id_notificacion']?.toString() ?? '',
      titulo: titulo,
      cuerpo: cuerpo,
      tiempo: local == null
          ? ''
          : '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year} · ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}',
      icono: _iconoDe(tipo, mensajeRaw),
      categoria: _categoriaDe(tipo, mensajeRaw),
      leida: dato['leida'] == true,
    );
  }

  NotificacionModel marcarComoLeida() => NotificacionModel(
        id: id,
        titulo: titulo,
        cuerpo: cuerpo,
        tiempo: tiempo,
        icono: icono,
        categoria: categoria,
        leida: true,
      );

  static IconData _iconoDe(String tipo, String mensaje) {
    final lower = mensaje.toLowerCase();
    if (tipo == 'pago' || lower.contains('pago')) {
      return Icons.payments_outlined;
    }
    if (lower.contains('aprob')) return Icons.check_circle_outline;
    if (lower.contains('rechaz')) return Icons.cancel_outlined;
    if (lower.contains('desembolso') || lower.contains('recib')) {
      return Icons.account_balance_wallet_outlined;
    }
    return Icons.notifications_outlined;
  }

  static String _categoriaDe(String tipo, String mensaje) {
    final lower = mensaje.toLowerCase();
    if (tipo == 'pago' || lower.contains('pago') || lower.contains('cuota')) {
      return 'pagos';
    }
    return 'prestamos';
  }
}

class NotificacionesModel {
  const NotificacionesModel();

  Future<List<NotificacionModel>> obtenerTodas() async {
    final datos = await ApiService.obtenerNotificaciones();
    return datos.map(NotificacionModel.desdeApi).toList();
  }

  Future<void> marcarLeida(String id) => ApiService.marcarNotificacionLeida(id);
}
