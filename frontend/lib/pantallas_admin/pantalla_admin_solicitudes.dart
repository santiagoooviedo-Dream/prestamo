import 'package:flutter/material.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_detalle_solicitud.dart';

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
      fecha: j['created_at']?.toString() ??
          j['fecha']?.toString() ??
          '',
      pendiente: estado == 'pendiente',
      motivo: j['motivo']?.toString() ?? '',
      cuotas: int.tryParse(j['coutas']?.toString() ?? '') ?? 0,
      metodoDesembolso: j['metodo_desembolso']?.toString() ?? 'efectivo',
      telefonoNequi: j['telefono_nequi']?.toString(),
    );
  }
}

class PantallaAdminSolicitudes extends StatefulWidget {
  const PantallaAdminSolicitudes({super.key});

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
      Map<int, Map<String, dynamic>> usuarios = {};
      try {
        final lista = await ApiService.obtenerUsuarios();
        for (final u in lista) {
          final id = int.tryParse(u['id_usuario']?.toString() ?? '');
          if (id != null) usuarios[id] = u;
        }
      } catch (_) {}
      final list = raw
          .map((j) {
            final idU = int.tryParse(j['id_usuario']?.toString() ?? '') ?? 0;
            return SolicitudAdmin.fromJson(j, usuario: usuarios[idU]);
          })
          .toList();
      list.sort((a, b) {
        if (a.pendiente != b.pendiente) return a.pendiente ? -1 : 1;
        return b.idSolicitud.compareTo(a.idSolicitud);
      });
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

  static String _fmt(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
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
              'Solicitudes de préstamo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Revisa y gestiona las solicitudes enviadas.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_error!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color(0xFFDC2626))),
                              const SizedBox(height: 12),
                              TextButton(
                                  onPressed: _cargar,
                                  child: const Text('Reintentar')),
                            ],
                          ),
                        )
                      : _solicitudes.isEmpty
                          ? const Center(
                              child: Text(
                                'No hay solicitudes por ahora.',
                                style: TextStyle(color: Color(0xFF66758D)),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _cargar,
                              child: ListView.separated(
                                itemCount: _solicitudes.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (_, i) =>
                                    _tarjeta(context, _solicitudes[i]),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, SolicitudAdmin s) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PantallaAdminDetalleSolicitud(solicitud: s),
          ),
        );
        _cargar();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE1E8F3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A17243C),
              blurRadius: 16,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFE8F0FE),
                  child: Text(
                    s.nombre.isNotEmpty ? s.nombre[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF285FE8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF17243C),
                        ),
                      ),
                      Text(
                        s.apellidos,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF66758D),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: s.pendiente
                        ? const Color(0xFFFFF4E5)
                        : s.estado == 'aceptada'
                            ? const Color(0xFFEAF7F0)
                            : const Color(0xFFFFF0F2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    s.estado,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: s.pendiente
                          ? const Color(0xFFA65B0B)
                          : s.estado == 'aceptada'
                              ? const Color(0xFF168261)
                              : const Color(0xFFBC4351),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Préstamo solicitado',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A0B3)),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${_fmt(s.monto)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${s.cuotas} cuotas · #${s.idSolicitud}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF66758D)),
            ),
          ],
        ),
      ),
    );
  }
}
