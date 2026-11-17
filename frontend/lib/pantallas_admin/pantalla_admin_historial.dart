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

      // Más reciente primero
      resueltas.sort((a, b) {
        final fa = _fechaOrdenRaw(a);
        final fb = _fechaOrdenRaw(b);
        final cmp = fb.compareTo(fa);
        if (cmp != 0) return cmp;
        final idA = int.tryParse(a['id_solicitud']?.toString() ?? '') ?? 0;
        final idB = int.tryParse(b['id_solicitud']?.toString() ?? '') ?? 0;
        return idB.compareTo(idA);
      });

      if (!mounted) return;
      setState(() {
        _items = resueltas.map(_mapItem).toList();
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
          _error = 'No se pudo cargar el historial.';
          _cargando = false;
        });
      }
    }
  }

  /// Parsea fechas ISO, con espacio, o dd/mm/yyyy.
  DateTime? _parseFecha(dynamic raw) {
    if (raw == null) return null;
    var s = raw.toString().trim();
    if (s.isEmpty || s == 'null' || s == '—' || s == '-') return null;
    // "2026-11-11 15:30:00" -> ISO-ish
    if (s.contains(' ') && !s.contains('T')) {
      s = s.replaceFirst(' ', 'T');
    }
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;
    final p = RegExp(r'^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})').firstMatch(s);
    if (p != null) {
      final d = int.tryParse(p.group(1)!);
      final m = int.tryParse(p.group(2)!);
      final y = int.tryParse(p.group(3)!);
      if (d != null && m != null && y != null) {
        return DateTime(y, m, d);
      }
    }
    return null;
  }

  DateTime _fechaOrdenRaw(Map<String, dynamic> j) {
    return _parseFecha(j['fecha_desembolso']) ??
        _parseFecha(j['fecha_inicio']) ??
        _parseFecha(j['created_at']) ??
        _parseFecha(j['fecha']) ??
        DateTime(2000);
  }

  /// Primer pago = mes siguiente al inicio, día 15.
  DateTime _basePrimerPago(DateTime inicio) {
    return DateTime(inicio.year, inicio.month + 1, 15);
  }

  DateTime _fechaMensual(DateTime base, int meses) {
    final m = base.month + meses;
    final year = base.year + ((m - 1) ~/ 12);
    final month = ((m - 1) % 12) + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = base.day > lastDay ? lastDay : base.day;
    return DateTime(year, month, day);
  }

  String _fmt(DateTime f) {
    const m = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${f.day} ${m[f.month - 1]} ${f.year}';
  }

  ItemHistorialAdmin _mapItem(Map<String, dynamic> j) {
    final monto = int.tryParse(j['monto_solicitado']?.toString() ?? '') ?? 0;
    final cuotas = int.tryParse(j['coutas']?.toString() ?? '') ??
        int.tryParse(j['cuotas']?.toString() ?? '') ??
        0;
    final estado = (j['estado'] ?? '').toString().toLowerCase();

    // Prioridad: fecha_desembolso (al aceptar) > fecha_inicio > created_at
    final inicioRaw = _parseFecha(j['fecha_desembolso']) ??
        _parseFecha(j['fecha_inicio']) ??
        _parseFecha(j['created_at']) ??
        _parseFecha(j['fecha']);

    final titulo = inicioRaw != null
        ? 'Préstamo ${_fmt(inicioRaw)}'
        : 'Solicitud #${j['id_solicitud'] ?? ''}';

    final estadoUi = estado == 'rechazada'
        ? 'Rechazado'
        : (estado == 'aceptada' || estado == 'aprobada')
            ? 'Aprobado'
            : estado == 'completado' || estado == 'completada'
                ? 'Completado'
                : estado.isEmpty
                    ? '—'
                    : '${estado[0].toUpperCase()}${estado.substring(1)}';

    final metodo =
        (j['metodo_desembolso'] ?? '').toString().toLowerCase() == 'nequi'
            ? 'Nequi'
            : 'Efectivo';

    String fechaInicioTxt = '—';
    String fechaFinTxt = '—';
    if (inicioRaw != null) {
      fechaInicioTxt = _fmt(inicioRaw);
      if (cuotas > 0) {
        final fin = _fechaMensual(_basePrimerPago(inicioRaw), cuotas - 1);
        fechaFinTxt = _fmt(fin);
      }
    }

    return ItemHistorialAdmin(
      titulo: titulo,
      monto: monto,
      cuotaTexto: cuotas > 0 ? '$cuotas cuotas' : '—',
      numeroCuotas: cuotas,
      estado: estadoUi,
      fechaPago: fechaInicioTxt,
      metodo: metodo,
      fechaInicio: fechaInicioTxt,
      fechaFin: fechaFinTxt,
      fechaOrden: inicioRaw,
    );
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
                    tipoPrestamo: 'Préstamo personal',
                    fechaPago: it.fechaInicio,
                    metodo: it.metodo,
                    numeroCuotas: it.numeroCuotas,
                    estado: it.estado,
                    fechaInicio: it.fechaInicio,
                    fechaFin: it.fechaFin,
                    puedeConfirmar: false,
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
