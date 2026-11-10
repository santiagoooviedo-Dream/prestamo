import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/admin/tarjeta_conversacion_admin.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_chat.dart';

class PantallaAdminConversaciones extends StatefulWidget {
  /// Si se pasa, solo muestra las conversaciones de ese usuario.
  final int? idUsuarioFiltro;
  final String? nombreUsuario;

  const PantallaAdminConversaciones({
    super.key,
    this.idUsuarioFiltro,
    this.nombreUsuario,
  });

  @override
  State<PantallaAdminConversaciones> createState() =>
      _PantallaAdminConversacionesState();
}

class _PantallaAdminConversacionesState
    extends State<PantallaAdminConversaciones> {
  bool _cargando = true;
  String? _error;
  List<_ConvItem> _items = [];

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
      final raw = await ApiService.obtenerConversacionesAdmin();
      final usuarios = <int, Map<String, dynamic>>{};
      try {
        for (final u in await ApiService.obtenerUsuarios()) {
          final id = int.tryParse(u['id_usuario']?.toString() ?? '');
          if (id != null) usuarios[id] = u;
        }
      } catch (_) {}

      // Conversaciones del admin:
      // - modo / modo_atencion == admin
      // - o bien (si hay filtro de usuario) todas las de ese usuario
      final conAdmin = raw.where((c) {
        final modo = (c['modo'] ?? c['modo_atencion'] ?? '')
            .toString()
            .toLowerCase()
            .trim();
        final esAdmin = modo == 'admin' ||
            modo == 'administrador' ||
            modo == 'soporte';

        final idUser = int.tryParse(
          c['id_usuario']?.toString() ??
              c['usuario_id']?.toString() ??
              (c['usuario'] is Map
                  ? c['usuario']['id_usuario']?.toString() ?? ''
                  : '') ??
              '',
        );

        final filtroId = widget.idUsuarioFiltro;
        if (filtroId != null) {
          // Desde el perfil: solo ese usuario (admin o pago personal)
          return idUser == filtroId;
        }

        // Vista general: solo transferidas a admin
        return esAdmin;
      }).toList();

      // Cargar mensajes en paralelo (antes era 1 request por chat en serie)
      final futures = <Future<_ConvItem?>>[];
      for (final c in conAdmin) {
        final idConv = c['id_conversacion']?.toString() ??
            c['id']?.toString() ??
            '';
        if (idConv.isEmpty) continue;

        final idUser = int.tryParse(
          c['id_usuario']?.toString() ??
              c['usuario_id']?.toString() ??
              (c['usuario'] is Map
                  ? c['usuario']['id_usuario']?.toString() ?? ''
                  : '') ??
              '',
        );
        final u = idUser != null ? usuarios[idUser] : null;
        final nombre = _nombreDe(c, u);

        futures.add(() async {
          var preview = c['ultimo_mensaje']?.toString() ??
              c['mensaje']?.toString() ??
              c['preview']?.toString() ??
              c['asunto']?.toString() ??
              '';
          var todosLosTextos = preview;
          try {
            final msgs =
                await ApiService.obtenerMensajesConversacion(idConv);
            if (msgs.isNotEmpty) {
              if (preview.isEmpty) {
                final last = msgs.last;
                preview = last['mensaje']?.toString() ??
                    last['respuesta']?.toString() ??
                    last['contenido']?.toString() ??
                    '';
              }
              final buffer = StringBuffer(preview);
              for (final msg in msgs) {
                buffer.write(' ');
                buffer.write(msg['mensaje'] ?? '');
                buffer.write(' ');
                buffer.write(msg['respuesta'] ?? '');
                buffer.write(' ');
                buffer.write(msg['contenido'] ?? '');
              }
              todosLosTextos = buffer.toString();
            }
          } catch (_) {}
          if (preview.isEmpty) preview = 'Sin mensajes';

          final pago = _esPagoPersonal(c, todosLosTextos);
          final lowerAll = todosLosTextos.toLowerCase();
          final yaValidado =
              lowerAll.contains('pago personal fue validado') ||
                  lowerAll.contains('pago nequi verificado') ||
                  lowerAll.contains('pago verificado') ||
                  lowerAll.contains('queda registrada como pagada') ||
                  lowerAll.contains('cuota ya quedó registrada');

          return _ConvItem(
            id: idConv,
            nombre: nombre,
            preview: preview,
            esPago: pago,
            yaValidado: yaValidado,
            idUsuario: idUser,
          );
        }());
      }

      final resultados = await Future.wait(futures);
      final items = resultados.whereType<_ConvItem>().toList();

      if (!mounted) return;
      setState(() {
        _items = items;
        _cargando = false;
      });
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
          _error = 'No se pudieron cargar las conversaciones.';
          _cargando = false;
        });
      }
    }
  }

  String _nombreDe(Map<String, dynamic> c, Map<String, dynamic>? u) {
    if (u != null) {
      final n = '${u['nombre'] ?? ''} ${u['apellido'] ?? ''}'.trim();
      if (n.isNotEmpty) return n;
    }
    final nested = c['usuario'];
    if (nested is Map) {
      final n = '${nested['nombre'] ?? ''} ${nested['apellido'] ?? ''}'.trim();
      if (n.isNotEmpty) return n;
    }
    for (final k in ['nombre', 'nombre_usuario', 'correo']) {
      final v = c[k]?.toString().trim();
      if (v != null && v.isNotEmpty && v.toLowerCase() != 'usuario') {
        return v;
      }
    }
    return 'Usuario';
  }

  bool _esPagoPersonal(Map<String, dynamic> c, String preview) {
    final texto = [
      preview,
      c['asunto'],
      c['descripcion'],
      c['tipo'],
      c['modo'],
      c['categoria'],
      c['origen'],
    ].whereType<Object>().map((e) => e.toString().toLowerCase()).join(' ');

    // Detectar por palabras clave comunes de pago presencial / personal
    if (texto.contains('pago personal') ||
        texto.contains('pago presencial') ||
        texto.contains('pagar en persona') ||
        texto.contains('pagar mi cuota') ||
        texto.contains('quiero pagar') ||
        texto.contains('ref_pago') ||
        texto.contains('ref_nequi') ||
        texto.contains('pago por nequi') ||
        texto.contains('comprobante') ||
        texto.contains('id_prestamo') ||
        texto.contains('id_cuota')) {
      return true;
    }

    // Si el backend marca el tipo explícitamente
    final tipo = (c['tipo'] ?? c['categoria'] ?? '').toString().toLowerCase();
    if (tipo.contains('pago') || tipo == 'personal' || tipo == 'presencial') {
      return true;
    }

    // Si viene con id_prestamo o id_cuota asociado
    if (c['id_prestamo'] != null || c['id_cuota'] != null) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

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
                  'SOPORTE',
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
              widget.nombreUsuario != null && widget.nombreUsuario!.isNotEmpty
                  ? 'Conversaciones de ${widget.nombreUsuario}'
                  : 'Conversaciones',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.idUsuarioFiltro != null
                  ? 'Solo chats de este usuario transferidos al administrador.'
                  : 'Solo chats transferidos al administrador y pagos personales.',
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
    if (_items.isEmpty) {
      return const Center(
        child: Text(
          'No hay conversaciones con el administrador.',
          style: TextStyle(color: Color(0xFF66758D)),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _cargar,
      child: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final it = _items[i];
          return TarjetaConversacionAdmin(
            nombre: it.nombre,
            preview: it.preview,
            esPagoPersonal: it.esPago,
            yaValidado: it.yaValidado,
            onTap: () {
              // Extraer datos de REF_PAGO del preview si existen
              int? idPrestamo;
              int? idCuota;
              num? monto;
              final p = RegExp(r'id_prestamo=(\d+)').firstMatch(it.preview);
              final c = RegExp(r'id_cuota=(\d+)').firstMatch(it.preview);
              final m = RegExp(r'monto=([0-9.]+)').firstMatch(it.preview);
              if (p != null) idPrestamo = int.tryParse(p.group(1)!);
              if (c != null) idCuota = int.tryParse(c.group(1)!);
              if (m != null) monto = num.tryParse(m.group(1)!);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PantallaAdminChat(
                    idConversacion: it.id,
                    nombreUsuario: it.nombre,
                    mensajeInicialUsuario:
                        it.preview == 'Sin mensajes' ? null : it.preview,
                    esPagoPersonal: it.esPago ||
                        idPrestamo != null ||
                        it.preview.toLowerCase().contains('ref_pago') ||
                        it.preview.toLowerCase().contains('ref_nequi') ||
                        it.preview.toLowerCase().contains('pago personal') ||
                        it.preview.toLowerCase().contains('pago por nequi'),
                    idPrestamo: idPrestamo,
                    idCuota: idCuota,
                    monto: monto,
                    idUsuario: it.idUsuario,
                  ),
                ),
              ).then((_) => _cargar());
            },
          );
        },
      ),
    );
  }
}

class _ConvItem {
  final String id;
  final String nombre;
  final String preview;
  final bool esPago;
  final bool yaValidado;
  final int? idUsuario;

  _ConvItem({
    required this.id,
    required this.nombre,
    required this.preview,
    required this.esPago,
    this.yaValidado = false,
    this.idUsuario,
  });
}
