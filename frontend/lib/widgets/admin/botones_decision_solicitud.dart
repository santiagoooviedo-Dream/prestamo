import 'package:flutter/material.dart';

import '../../models/solicitud_admin.dart';
import '../../nucleo/api_service.dart';
import 'dialogo_carga_admin.dart';

class BotonesDecisionSolicitud extends StatelessWidget {
  final SolicitudAdmin solicitud;

  const BotonesDecisionSolicitud({super.key, required this.solicitud});

  Future<void> _aprobar(BuildContext context) async {
    final s = solicitud;
    mostrarCargaAdmin(context, 'Aprobando solicitud…');
    try {
      final fecha =
          DateTime.now().add(const Duration(days: 2)).toIso8601String();
      await ApiService.actualizarEstadoSolicitud(
        idSolicitud: s.idSolicitud,
        estado: 'aceptada',
        fechaDesembolso: fecha,
        lugarRecogida: s.metodoDesembolso == 'efectivo'
            ? 'Punto de atención principal'
            : null,
      );
      try {
        final prestamo =
            await ApiService.crearPrestamoDesdeSolicitud(s.idSolicitud);
        final idP =
            prestamo['prestamo']?['id_prestamo'] ?? prestamo['id_prestamo'];
        if (idP != null) {
          await ApiService.crearCuotasPrestamo(int.parse(idP.toString()));
        }
      } catch (_) {}
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solicitud de ${s.nombre} aprobada')),
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.mensaje)));
    } catch (_) {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo aprobar la solicitud.')),
      );
    }
  }

  Future<void> _rechazar(BuildContext context) async {
    final s = solicitud;
    mostrarCargaAdmin(context, 'Rechazando solicitud…');
    try {
      await ApiService.actualizarEstadoSolicitud(
        idSolicitud: s.idSolicitud,
        estado: 'rechazada',
      );
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solicitud de ${s.nombre} rechazada')),
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.mensaje)));
    } catch (_) {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo rechazar la solicitud.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () => _aprobar(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF285FE8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Aprobar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () => _rechazar(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF0F2),
                  foregroundColor: const Color(0xFFBC4351),
                  side: const BorderSide(color: Color(0xFFF0D5DB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Rechazar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
