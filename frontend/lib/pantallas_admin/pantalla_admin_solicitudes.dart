import 'package:flutter/material.dart';

import '../models/solicitud_admin.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/admin/tarjeta_solicitud_admin.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_detalle_solicitud.dart';

class PantallaAdminSolicitudes extends StatefulWidget {
  final int? idUsuarioFiltro;
  final String? nombreUsuario;

  const PantallaAdminSolicitudes({
    super.key,
    this.idUsuarioFiltro,
    this.nombreUsuario,
  });

  @override
  State<PantallaAdminSolicitudes> createState() =>
      _PantallaAdminSolicitudesState();
}

class _PantallaAdminSolicitudesState extends State<PantallaAdminSolicitudes> {
  bool _cargando = true;
  String? _error;
  List<SolicitudAdmin> _solicitudes = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final raw = await ApiService.obtenerSolicitudesAdmin();
      final usuarios = <int, Map<String, dynamic>>{};
      try {
        for (final u in await ApiService.obtenerUsuarios()) {
          final id = int.tryParse(u['id_usuario']?.toString() ?? '');
          if (id != null) usuarios[id] = u;
        }
      } catch (_) {}

      var list = raw.map((j) {
        final idU = int.tryParse(j['id_usuario']?.toString() ?? '') ?? 0;
        return SolicitudAdmin.fromJson(j, usuario: usuarios[idU]);
      }).where((s) => s.pendiente).toList();

      final filtro = widget.idUsuarioFiltro;
      if (filtro != null) {
        list = list.where((s) => s.idUsuario == filtro).toList();
      }
      list.sort((a, b) => b.idSolicitud.compareTo(a.idSolicitud));

      if (mounted) {
        setState(() {
          _solicitudes = list;
          _cargando = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.mensaje;
          _cargando = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No se pudieron cargar las solicitudes.';
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final titulo = widget.nombreUsuario != null
        ? 'Solicitudes de ${widget.nombreUsuario}'
        : 'Solicitudes de préstamo';
    final sub = widget.idUsuarioFiltro != null
        ? 'Solo solicitudes pendientes de este usuario.'
        : 'Solo se muestran solicitudes pendientes.';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(
                  alPresionar: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                ),
                const Text(
                  'ADMINISTRADOR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sub,
              style: const TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 16),
            Expanded(child: _cuerpo()),
          ],
        ),
      ),
    );
  }

  Widget _cuerpo() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            TextButton(onPressed: _cargar, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    if (_solicitudes.isEmpty) {
      return const Center(
        child: Text(
          'No hay solicitudes pendientes.',
          style: TextStyle(color: Color(0xFF66758D)),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _cargar,
      child: ListView.separated(
        itemCount: _solicitudes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final s = _solicitudes[i];
          return TarjetaSolicitudAdmin(
            solicitud: s,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PantallaAdminDetalleSolicitud(solicitud: s),
                ),
              );
              _cargar();
            },
          );
        },
      ),
    );
  }
}
