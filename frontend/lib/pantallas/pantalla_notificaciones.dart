import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_perfil.dart';

class PantallaNotificaciones extends StatefulWidget {
  const PantallaNotificaciones({super.key});

  @override
  State<PantallaNotificaciones> createState() => _PantallaNotificacionesState();
}

class _Notif {
  final String id;
  final String titulo;
  final String cuerpo;
  final String tiempo;
  final IconData icono;
  final String categoria; // pagos | prestamos | info
  final bool leida;

  const _Notif({
    required this.id,
    required this.titulo,
    required this.cuerpo,
    required this.tiempo,
    required this.icono,
    required this.categoria,
    this.leida = false,
  });
}

class _PantallaNotificacionesState extends State<PantallaNotificaciones> {
  int _filtro = 0; // 0 Todas, 1 No leídas, 2 Préstamos, 3 Pagos

  static const _tabs = ['Todas', 'No leídas', 'Préstamos', 'Pagos'];

  List<_Notif> _items = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarNotificaciones();
  }

  Future<void> _cargarNotificaciones() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final datos = await ApiService.obtenerNotificaciones();
      if (!mounted) return;
      setState(() {
        _items = datos.map(_desdeApi).toList();
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.mensaje);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  _Notif _desdeApi(Map<String, dynamic> dato) {
    final tipo = dato['tipo']?.toString() ?? 'info';
    final cuerpo =
        dato['mensaje']?.toString() ?? 'Tienes una nueva notificación.';
    final fecha = DateTime.tryParse(dato['fecha']?.toString() ?? '');
    return _Notif(
      id: dato['id_notificacion']?.toString() ?? '',
      titulo: cuerpo.toLowerCase().contains('aprob')
          ? 'Solicitud aprobada'
          : cuerpo.toLowerCase().contains('rechaz')
          ? 'Actualización de solicitud'
          : tipo == 'pago'
          ? 'Actualización de pago'
          : 'Actualización de solicitud',
      cuerpo: cuerpo,
      tiempo: fecha == null
          ? ''
          : '${fecha.toLocal().day.toString().padLeft(2, '0')}/${fecha.toLocal().month.toString().padLeft(2, '0')}/${fecha.toLocal().year} · ${fecha.toLocal().hour.toString().padLeft(2, '0')}:${fecha.toLocal().minute.toString().padLeft(2, '0')}',
      icono: tipo == 'pago'
          ? Icons.payments_outlined
          : Icons.account_balance_wallet_outlined,
      categoria: tipo == 'pago' ? 'pagos' : 'prestamos',
      leida: dato['leida'] == true,
    );
  }

  Future<void> _marcarLeida(_Notif notificacion) async {
    if (notificacion.leida || notificacion.id.isEmpty) return;
    try {
      await ApiService.marcarNotificacionLeida(notificacion.id);
      if (!mounted) return;
      setState(() {
        _items = _items
            .map(
              (item) => item.id == notificacion.id
                  ? _Notif(
                      id: item.id,
                      titulo: item.titulo,
                      cuerpo: item.cuerpo,
                      tiempo: item.tiempo,
                      icono: item.icono,
                      categoria: item.categoria,
                      leida: true,
                    )
                  : item,
            )
            .toList();
      });
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.mensaje)));
      }
    }
  }

  List<_Notif> get _filtradas {
    switch (_filtro) {
      case 1:
        return _items.where((n) => !n.leida).toList();
      case 2:
        return _items.where((n) => n.categoria == 'prestamos').toList();
      case 3:
        return _items.where((n) => n.categoria == 'pagos').toList();
      default:
        return _items;
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final lista = _filtradas;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, top + 6, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BotonVolver(
                        alPresionar: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PantallaPerfil(),
                              ),
                              (_) => false,
                            );
                          }
                        },
                      ),
                      Text(
                        'TU ACTIVIDAD',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: ColoresApp.textoContexto,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Notificaciones',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Mantente al día con lo importante.',
                    style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
                  ),
                  const SizedBox(height: 16),
                  // Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_tabs.length, (i) {
                        final activo = _filtro == i;
                        return Padding(
                          padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                          child: GestureDetector(
                            onTap: () => setState(() => _filtro = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: activo
                                    ? const Color(0xFF285FE8)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: activo
                                      ? const Color(0xFF285FE8)
                                      : const Color(0xFFE1E8F3),
                                ),
                              ),
                              child: Text(
                                _tabs[i],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: activo
                                      ? Colors.white
                                      : const Color(0xFF66758D),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _cargando
                        ? const Center(child: CircularProgressIndicator())
                        : _error != null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _error!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF66758D),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _cargarNotificaciones,
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          )
                        : lista.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay notificaciones',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF66758D),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: lista.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              final n = lista[i];
                              return GestureDetector(
                                onTap: () => _marcarLeida(n),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: n.leida
                                        ? Colors.white
                                        : const Color(0xFFEDF3FF),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFE1E8F3),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEDF3FF),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          n.icono,
                                          size: 20,
                                          color: const Color(0xFF285FE8),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    n.titulo,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF17243C),
                                                    ),
                                                  ),
                                                ),
                                                if (!n.leida)
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Color(
                                                            0xFF285FE8,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              n.cuerpo,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF66758D),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              n.tiempo,
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
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          const BarraNavegacion(actual: DestinoNav.perfil),
        ],
      ),
    );
  }
}
