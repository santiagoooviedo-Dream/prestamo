import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/admin/tarjeta_destinatario.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';

class PantallaAdminNotificaciones extends StatefulWidget {
  const PantallaAdminNotificaciones({super.key});

  @override
  State<PantallaAdminNotificaciones> createState() =>
      _PantallaAdminNotificacionesState();
}

class _PantallaAdminNotificacionesState
    extends State<PantallaAdminNotificaciones> {
  final _titulo = TextEditingController();
  final _mensaje = TextEditingController();
  final _busqueda = TextEditingController();
  int? _usuarioSel;
  bool _cargando = true;
  bool _enviando = false;
  String? _error;
  List<_Dest> _destinatarios = [];

  @override
  void initState() {
    super.initState();
    _busqueda.addListener(() => setState(() {}));
    _cargarDestinatarios();
  }

  @override
  void dispose() {
    _titulo.dispose();
    _mensaje.dispose();
    _busqueda.dispose();
    super.dispose();
  }

  List<_Dest> get _filtrados {
    final q = _busqueda.text.trim().toLowerCase();
    if (q.isEmpty) return _destinatarios;
    return _destinatarios.where((d) {
      return d.nombre.toLowerCase().contains(q) ||
          d.correo.toLowerCase().contains(q) ||
          d.cedula.toLowerCase().contains(q);
    }).toList();
  }

  int? _idDeUsuario(Map<String, dynamic> u) {
    return int.tryParse(
      u['id_usuario']?.toString() ??
          u['id']?.toString() ??
          u['usuario_id']?.toString() ??
          '',
    );
  }

  Future<void> _cargarDestinatarios() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      // 1) Cargar TODOS los usuarios (fuente principal)
      final usuarios = <int, Map<String, dynamic>>{};
      try {
        for (final u in await ApiService.obtenerUsuarios()) {
          final id = _idDeUsuario(u);
          if (id == null) continue;
          // No listar administradores como destinatarios
          final rol = (u['rol'] ?? '').toString().toLowerCase();
          if (rol == 'admin' || rol == 'administrador') continue;
          usuarios[id] = u;
        }
      } catch (_) {}

      // 2) Enriquecer con estado de solicitudes
      final detallePorUsuario = <int, String>{};
      try {
        final raw = await ApiService.obtenerSolicitudesAdmin();
        for (final j in raw) {
          final idU = int.tryParse(j['id_usuario']?.toString() ?? '') ?? 0;
          if (idU == 0) continue;
          final estado = (j['estado'] ?? '').toString().toLowerCase();
          String detalle = 'Usuario registrado';
          if (estado == 'pendiente') {
            detalle = 'Solicitud pendiente';
          } else if (estado == 'aceptada' || estado == 'aprobada') {
            detalle = 'Solicitud aceptada';
          } else if (estado == 'rechazada') {
            detalle = 'Solicitud rechazada';
          } else if (estado.isNotEmpty) {
            detalle = 'Actividad: $estado';
          }
          final prev = detallePorUsuario[idU];
          if (prev == null ||
              (detalle == 'Solicitud pendiente' &&
                  prev != 'Solicitud pendiente')) {
            detallePorUsuario[idU] = detalle;
          }
        }
      } catch (_) {}

      // 3) Enriquecer con préstamos (si el endpoint lo permite)
      try {
        final prestamos = await ApiService.obtenerPrestamos();
        for (final p in prestamos) {
          final idU = int.tryParse(p['id_usuario']?.toString() ?? '') ?? 0;
          if (idU == 0 || detallePorUsuario.containsKey(idU)) continue;
          final estado = (p['estado'] ?? '').toString().toLowerCase();
          if (estado.contains('complet')) {
            detallePorUsuario[idU] = 'Préstamo completado';
          } else if (estado.contains('activ')) {
            detallePorUsuario[idU] = 'Préstamo activo';
          } else {
            detallePorUsuario[idU] = 'Con préstamo';
          }
        }
      } catch (_) {}

      final porUsuario = <int, _Dest>{};
      for (final entry in usuarios.entries) {
        final id = entry.key;
        final u = entry.value;
        final nombreRaw =
            '${u['nombre'] ?? ''} ${u['apellido'] ?? u['apellidos'] ?? ''}'
                .trim();
        porUsuario[id] = _Dest(
          id: id,
          nombre: nombreRaw.isEmpty ? 'Usuario #$id' : nombreRaw,
          detalle: detallePorUsuario[id] ?? 'Usuario registrado',
          correo: u['correo']?.toString() ?? '',
          cedula: u['cedula']?.toString() ?? '',
        );
      }

      // Si no hubo listado de usuarios, al menos usar los de solicitudes
      if (porUsuario.isEmpty) {
        for (final e in detallePorUsuario.entries) {
          porUsuario[e.key] = _Dest(
            id: e.key,
            nombre: 'Usuario #${e.key}',
            detalle: e.value,
          );
        }
      }

      final lista = porUsuario.values.toList()
        ..sort((a, b) => a.nombre.compareTo(b.nombre));

      if (!mounted) return;
      setState(() {
        _destinatarios = lista;
        _cargando = false;
        if (lista.isEmpty) {
          _error = 'No se encontraron usuarios para notificar.';
        }
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
          _error = 'No se pudieron cargar los destinatarios.';
          _cargando = false;
        });
      }
    }
  }

  Future<void> _enviar() async {
    final id = _usuarioSel;
    final titulo = _titulo.text.trim();
    final cuerpo = _mensaje.text.trim();
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elige un destinatario.')),
      );
      return;
    }
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un título para la notificación.')),
      );
      return;
    }
    if (cuerpo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe el mensaje.')),
      );
      return;
    }
    // Título y cuerpo separados para que el usuario vea el título elegido
    final texto = '$titulo\n\n$cuerpo';
    final nombreDest = _destinatarios
        .where((d) => d.id == id)
        .map((d) => d.nombre)
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);

    setState(() => _enviando = true);
    try {
      await ApiService.crearNotificacion(
        idUsuario: id,
        mensaje: texto,
        tipo: 'admin',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            nombreDest == null
                ? 'Notificación enviada.'
                : 'Notificación enviada a $nombreDest.',
          ),
        ),
      );
      _titulo.clear();
      _mensaje.clear();
      setState(() => _usuarioSel = null);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.mensaje}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo enviar la notificación. $e'),
        ),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final lista = _filtrados;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
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
            const Text(
              'Notificaciones',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Elige un usuario y escribe el título y mensaje.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _busqueda,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, correo o cédula',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A0B3)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE1E8F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE1E8F3)),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Destinatario',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_cargando)
                      const Center(child: CircularProgressIndicator())
                    else if (_error != null)
                      Text(_error!,
                          style: const TextStyle(color: Color(0xFFDC2626)))
                    else if (lista.isEmpty)
                      const Text(
                        'No hay destinatarios con ese filtro.',
                        style: TextStyle(color: Color(0xFF66758D)),
                      )
                    else
                      ...lista.map(
                        (d) => TarjetaDestinatario(
                          nombre: d.nombre,
                          detalle: d.detalle,
                          seleccionado: _usuarioSel == d.id,
                          onTap: () => setState(() => _usuarioSel = d.id),
                        ),
                      ),
                    const SizedBox(height: 12),
                    CampoTexto(
                      etiqueta: 'Título',
                      pista: 'Ej. Recordatorio de pago',
                      controlador: _titulo,
                    ),
                    const SizedBox(height: 12),
                    CampoTexto(
                      etiqueta: 'Mensaje',
                      pista: 'Escribe el mensaje...',
                      controlador: _mensaje,
                      maxLineas: 4,
                    ),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: _enviando ? 'Enviando…' : 'Enviar notificación',
              alPresionar: _enviando ? null : _enviar,
              cargando: _enviando,
            ),
          ],
        ),
      ),
    );
  }
}

class _Dest {
  final int id;
  final String nombre;
  final String detalle;
  final String correo;
  final String cedula;

  _Dest({
    required this.id,
    required this.nombre,
    required this.detalle,
    this.correo = '',
    this.cedula = '',
  });
}
