import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/admin/mini_perfil_admin.dart';
import '../widgets/admin/tarjeta_historial_admin.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_monto_pagado.dart';

class PantallaAdminHistorial extends StatefulWidget {
  final int? idUsuario;
  final String nombre;
  final String apellidos;

  const PantallaAdminHistorial({
    super.key,
    this.idUsuario,
    this.nombre = 'Usuario',
    this.apellidos = '',
  });

  @override
  State<PantallaAdminHistorial> createState() => _PantallaAdminHistorialState();
}

class _PantallaAdminHistorialState extends State<PantallaAdminHistorial> {
  bool _cargando = true;
  String? _error;
  List<ItemHistorialAdmin> _items = [];

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
      final id = widget.idUsuario;
      final delUsuario = raw.where((j) {
        if (id == null) return false;
        return int.tryParse(j['id_usuario']?.toString() ?? '') == id;
      }).toList();

      final resueltas = delUsuario.where((j) {
        final e = (j['estado'] ?? '').toString().toLowerCase();
        return e == 'aceptada' ||
            e == 'rechazada' ||
            e == 'aprobada' ||
            e == 'completado' ||
            e == 'completada';
      }).toList();

      resueltas.sort((a, b) {
        final fa = DateTime.tryParse(
                a['created_at']?.toString() ?? a['fecha']?.toString() ?? '') ??
            DateTime(2000);
        final fb = DateTime.tryParse(
                b['created_at']?.toString() ?? b['fecha']?.toString() ?? '') ??
            DateTime(2000);
        return fb.compareTo(fa);
      });

      if (!mounted) return;
      setState(() {
        _items = resueltas.map(_mapItem).toList();
        _cargando = false;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() {
        _error = e.mensaje;
        _cargando = false;
      });
    } catch (_) {
      if (mounted) setState(() {
        _error = 'No se pudo cargar el historial.';
        _cargando = false;
      });
    }
  }

  ItemHistorialAdmin _mapItem(Map<String, dynamic> j) {
    final monto = int.tryParse(j['monto_solicitado']?.toString() ?? '') ?? 0;
    final cuotas = int.tryParse(j['coutas']?.toString() ?? '') ?? 0;
    final estado = (j['estado'] ?? '').toString().toLowerCase();
    final fecha = DateTime.tryParse(
        j['created_at']?.toString() ?? j['fecha']?.toString() ?? '');
    final titulo = fecha != null
        ? 'Préstamo ${_fmt(fecha)}'
        : 'Solicitud #${j['id_solicitud'] ?? ''}';
    final estadoUi = estado == 'rechazada'
        ? 'Rechazado'
        : (estado == 'aceptada' || estado == 'aprobada')
            ? 'Aprobado'
            : estado.isEmpty
                ? '—'
                : '${estado[0].toUpperCase()}${estado.substring(1)}';
    final metodo =
        (j['metodo_desembolso'] ?? '').toString() == 'nequi' ? 'Nequi' : 'Efectivo';

    return ItemHistorialAdmin(
      titulo: titulo,
      monto: monto,
      cuotaTexto: cuotas > 0 ? '$cuotas cuotas' : '—',
      estado: estadoUi,
      fechaPago: fecha != null ? _fmt(fecha) : '—',
      metodo: metodo,
    );
  }

  String _fmt(DateTime f) {
    const m = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${f.day} ${m[f.month - 1]} ${f.year}';
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
                  'HISTORIAL DE PRÉSTAMOS',
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
              'Historial de préstamo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Revisa el detalle de cada préstamo.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 18),
            MiniPerfilAdmin(
              nombre: widget.nombre,
              apellidos: widget.apellidos,
            ),
            const SizedBox(height: 14),
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
          'Este usuario aún no tiene historial de préstamos.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF66758D)),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _cargar,
      child: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final it = _items[i];
          return TarjetaHistorialAdmin(
            item: it,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PantallaAdminMontoPagado(
                    monto: it.monto,
                    tipoPrestamo: it.cuotaTexto,
                    fechaPago: it.fechaPago,
                    metodo: it.metodo,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
