import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/comunes/boton_volver.dart';

class PantallaNotificaciones extends StatefulWidget {
  const PantallaNotificaciones({super.key});

  @override
  State<PantallaNotificaciones> createState() =>
      _PantallaNotificacionesState();
}

class _Notif {
  final String titulo;
  final String cuerpo;
  final String tiempo;
  final IconData icono;
  final String categoria; // pagos | prestamos | info
  final bool leida;

  const _Notif({
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

  final _items = const [
    _Notif(
      titulo: 'Pago recibido',
      cuerpo: 'Tu pago de \$200.000 fue procesado.',
      tiempo: 'Hace 1 hora',
      icono: Icons.check_circle_outline,
      categoria: 'pagos',
      leida: false,
    ),
    _Notif(
      titulo: 'Recordatorio de cuota',
      cuerpo: 'Tu próxima cuota vence el 20 de mayo.',
      tiempo: 'Ayer, 12:00 p. m.',
      icono: Icons.calendar_today_outlined,
      categoria: 'pagos',
      leida: false,
    ),
    _Notif(
      titulo: 'Préstamo aprobado',
      cuerpo: 'Tu préstamo de \$1.000.000 fue aprobado.',
      tiempo: '10 mayo · 02:15 p. m.',
      icono: Icons.account_balance_wallet_outlined,
      categoria: 'prestamos',
      leida: true,
    ),
    _Notif(
      titulo: 'Nuevo mensaje',
      cuerpo: 'Tienes un nuevo mensaje de soporte.',
      tiempo: '9 mayo · 11:12 a. m.',
      icono: Icons.chat_bubble_outline,
      categoria: 'info',
      leida: true,
    ),
  ];

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
      backgroundColor: const Color(0xFFF5F8FD),
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
                      BotonVolver(alPresionar: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/perfil');
                        }
                      }),
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
                                  horizontal: 14, vertical: 8),
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
                    child: lista.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay notificaciones',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF66758D)),
                            ),
                          )
                        : ListView.separated(
                            itemCount: lista.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              final n = lista[i];
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: n.leida
                                      ? Colors.white
                                      : const Color(0xFFEDF3FF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: const Color(0xFFE1E8F3)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEDF3FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(n.icono,
                                          size: 20,
                                          color: const Color(0xFF285FE8)),
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
                                                    fontWeight: FontWeight.w600,
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
                                                    color: Color(0xFF285FE8),
                                                    shape: BoxShape.circle,
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
