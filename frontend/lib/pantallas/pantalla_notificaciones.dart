import 'package:flutter/material.dart';

import '../models/notificacion_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/notificaciones/lista_notificaciones.dart';
import 'pantalla_perfil.dart';

class PantallaNotificaciones extends StatefulWidget {
  const PantallaNotificaciones({super.key});

  @override
  State<PantallaNotificaciones> createState() => _PantallaNotificacionesState();
}

class _PantallaNotificacionesState extends State<PantallaNotificaciones> {
  final _modelo = const NotificacionesModel();
  int _filtro = 0;
  List<NotificacionModel> _items = [];
  bool _cargando = true;
  String? _error;

  static const _filtros = ['Todas', 'No leídas', 'Préstamos', 'Pagos'];

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
      final items = await _modelo.obtenerTodas();
      if (mounted) setState(() => _items = items);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.mensaje);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  List<NotificacionModel> get _filtradas => switch (_filtro) {
    1 => _items.where((item) => !item.leida).toList(),
    2 => _items.where((item) => item.categoria == 'prestamos').toList(),
    3 => _items.where((item) => item.categoria == 'pagos').toList(),
    _ => _items,
  };

  Future<void> _marcarLeida(NotificacionModel item) async {
    if (item.leida || item.id.isEmpty) return;
    try {
      await _modelo.marcarLeida(item.id);
      if (mounted) {
        setState(() {
          _items = _items
              .map(
                (actual) =>
                    actual.id == item.id ? actual.marcarComoLeida() : actual,
              )
              .toList();
        });
      }
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.mensaje)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
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
                  FiltrosNotificaciones(
                    filtros: _filtros,
                    seleccionado: _filtro,
                    alSeleccionar: (indice) => setState(() => _filtro = indice),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListaNotificaciones(
                      items: _filtradas,
                      cargando: _cargando,
                      error: _error,
                      alReintentar: _cargar,
                      alSeleccionar: _marcarLeida,
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
