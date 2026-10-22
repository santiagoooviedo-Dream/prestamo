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
    final tipo = dato['tipo']?.toString() ?? 'info';
    final cuerpo =
        dato['mensaje']?.toString() ?? 'Tienes una nueva notificación.';
    final mensaje = cuerpo.toLowerCase();
    final titulo = mensaje.contains('aprob')
        ? 'Solicitud aprobada'
        : mensaje.contains('rechaz')
        ? 'Actualización de solicitud'
        : tipo == 'pago'
        ? 'Actualización de pago'
        : 'Actualización de solicitud';
    final fecha = DateTime.tryParse(dato['fecha']?.toString() ?? '');
    final local = fecha?.toLocal();

    return NotificacionModel(
      id: dato['id_notificacion']?.toString() ?? '',
      titulo: titulo,
      cuerpo: cuerpo,
      tiempo: local == null
          ? ''
          : '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year} · ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}',
      icono: tipo == 'pago'
          ? Icons.payments_outlined
          : Icons.account_balance_wallet_outlined,
      categoria: tipo == 'pago' ? 'pagos' : 'prestamos',
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
}

class NotificacionesModel {
  const NotificacionesModel();

  Future<List<NotificacionModel>> obtenerTodas() async {
    final datos = await ApiService.obtenerNotificaciones();
    return datos.map(NotificacionModel.desdeApi).toList();
  }

  Future<void> marcarLeida(String id) => ApiService.marcarNotificacionLeida(id);
}
