import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/admin/accion_rapida_admin.dart';
import '../widgets/admin/cabecera_perfil_usuario.dart';
import '../widgets/admin/datos_perfil_usuario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_conversaciones.dart';
import 'pantalla_admin_historial.dart';
import 'pantalla_admin_solicitudes.dart';

class PantallaAdminPerfil extends StatefulWidget {
  final int? idUsuario;
  final String nombre;
  final String apellidos;
  final String correo;
  final String telefono;
  final String cedula;
  final String fechaRegistro;

  const PantallaAdminPerfil({
    super.key,
    this.idUsuario,
    this.nombre = 'Usuario',
    this.apellidos = '',
    this.correo = '',
    this.telefono = '',
    this.cedula = '',
    this.fechaRegistro = '',
  });

  @override
  State<PantallaAdminPerfil> createState() => _PantallaAdminPerfilState();
}

class _PantallaAdminPerfilState extends State<PantallaAdminPerfil> {
  bool _cargando = true;
  int _prestamosActivos = 0;
  int _solicitudes = 0;

  @override
  void initState() {
    super.initState();
    _cargarContadores();
  }

  Future<void> _cargarContadores() async {
    final id = widget.idUsuario;
    if (id == null) {
      setState(() => _cargando = false);
      return;
    }
    try {
      final raw = await ApiService.obtenerSolicitudesAdmin();
      final delUsuario = raw
          .where((j) =>
              int.tryParse(j['id_usuario']?.toString() ?? '') == id)
          .toList();
      final activos = delUsuario.where((j) {
        final e = (j['estado'] ?? '').toString().toLowerCase();
        return e == 'aceptada' || e == 'activo' || e == 'aprobada';
      }).length;
      if (!mounted) return;
      setState(() {
        _solicitudes = delUsuario.length;
        _prestamosActivos = activos;
        _cargando = false;
      });
    } catch (_) {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final completo = '${widget.nombre} ${widget.apellidos}'.trim();

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
                  'PERFIL DE USUARIO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CabeceraPerfilUsuario(
                      nombre: widget.nombre,
                      apellidos: widget.apellidos,
                      fechaRegistro: widget.fechaRegistro,
                    ),
                    const SizedBox(height: 18),
                    DatosPerfilUsuario(
                      correo: widget.correo,
                      telefono: widget.telefono,
                      cedula: widget.cedula,
                      prestamosActivos: _prestamosActivos,
                      solicitudesRealizadas: _solicitudes,
                      cargando: _cargando,
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Acciones rápidas',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17243C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AccionRapidaAdmin(
                      icono: Icons.bar_chart_rounded,
                      titulo: 'Historial de préstamos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PantallaAdminHistorial(
                              idUsuario: widget.idUsuario,
                              nombre: widget.nombre,
                              apellidos: widget.apellidos,
                            ),
                          ),
                        );
                      },
                    ),
                    AccionRapidaAdmin(
                      icono: Icons.mail_outline_rounded,
                      titulo: 'Solicitudes de préstamo',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PantallaAdminSolicitudes(
                              idUsuarioFiltro: widget.idUsuario,
                              nombreUsuario: completo,
                            ),
                          ),
                        );
                      },
                    ),
                    AccionRapidaAdmin(
                      icono: Icons.notifications_none_rounded,
                      titulo: 'Soporte',
                      onTap: () {
                        final nombreCompleto =
                            '${widget.nombre} ${widget.apellidos}'.trim();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PantallaAdminConversaciones(
                              idUsuarioFiltro: widget.idUsuario,
                              nombreUsuario: nombreCompleto.isEmpty
                                  ? null
                                  : nombreCompleto,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
