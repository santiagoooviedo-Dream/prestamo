import 'package:flutter/material.dart';

import '../../models/notificacion_model.dart';

class FiltrosNotificaciones extends StatelessWidget {
  final List<String> filtros;
  final int seleccionado;
  final ValueChanged<int> alSeleccionar;

  const FiltrosNotificaciones({
    super.key,
    required this.filtros,
    required this.seleccionado,
    required this.alSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filtros.length, (indice) {
          final activo = seleccionado == indice;
          return Padding(
            padding: EdgeInsets.only(
              right: indice < filtros.length - 1 ? 8 : 0,
            ),
            child: GestureDetector(
              onTap: () => alSeleccionar(indice),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: activo ? const Color(0xFF285FE8) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: activo
                        ? const Color(0xFF285FE8)
                        : const Color(0xFFE1E8F3),
                  ),
                ),
                child: Text(
                  filtros[indice],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: activo ? Colors.white : const Color(0xFF66758D),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ListaNotificaciones extends StatelessWidget {
  final List<NotificacionModel> items;
  final bool cargando;
  final String? error;
  final VoidCallback alReintentar;
  final ValueChanged<NotificacionModel> alSeleccionar;

  const ListaNotificaciones({
    super.key,
    required this.items,
    required this.cargando,
    required this.error,
    required this.alReintentar,
    required this.alSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) return const Center(child: CircularProgressIndicator());
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error!, textAlign: TextAlign.center),
            TextButton(
              onPressed: alReintentar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    if (items.isEmpty) {
      return const Center(child: Text('No hay notificaciones'));
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, indice) => _TarjetaNotificacion(
        notificacion: items[indice],
        alSeleccionar: () => alSeleccionar(items[indice]),
      ),
    );
  }
}

class _TarjetaNotificacion extends StatelessWidget {
  final NotificacionModel notificacion;
  final VoidCallback alSeleccionar;

  const _TarjetaNotificacion({
    required this.notificacion,
    required this.alSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    final item = notificacion;
    return GestureDetector(
      onTap: alSeleccionar,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.leida ? Colors.white : const Color(0xFFEDF3FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE1E8F3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icono, size: 20, color: const Color(0xFF285FE8)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.titulo,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF17243C),
                          ),
                        ),
                      ),
                      if (!item.leida)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF285FE8),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.cuerpo,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF66758D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.tiempo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A0B3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
