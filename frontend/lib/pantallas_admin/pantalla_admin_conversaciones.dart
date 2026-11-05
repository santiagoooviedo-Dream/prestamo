import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_chat.dart';

/// Conversaciones de soporte (admin) — incluye pagos personales
class PantallaAdminConversaciones extends StatefulWidget {
  const PantallaAdminConversaciones({super.key});

  @override
  State<PantallaAdminConversaciones> createState() =>
      _PantallaAdminConversacionesState();
}

class _PantallaAdminConversacionesState
    extends State<PantallaAdminConversaciones> {
  late Future<List<Map<String, dynamic>>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = ApiService.obtenerConversacionesAdmin();
  }

  void _recargar() =>
      setState(() => _futuro = ApiService.obtenerConversacionesAdmin());

  bool _esPagoPersonal(Map<String, dynamic> c) {
    final texto = [
      c['ultimo_mensaje'],
      c['mensaje'],
      c['preview'],
      c['asunto'],
      c['descripcion'],
    ].whereType<Object>().map((e) => e.toString().toLowerCase()).join(' ');
    return texto.contains('pago personal') ||
        texto.contains('ref_pago') ||
        texto.contains('id_prestamo');
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
            const Text(
              'Conversaciones',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Revisa chats y valida pagos personales.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futuro,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            snap.error is ApiException
                                ? (snap.error as ApiException).mensaje
                                : 'No se pudieron cargar las conversaciones.',
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: _recargar,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final lista = snap.data!;
                  if (lista.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay conversaciones por ahora.',
                        style: TextStyle(color: Color(0xFF66758D)),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => _recargar(),
                    child: ListView.separated(
                      itemCount: lista.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final c = lista[i];
                        final nombre = c['nombre']?.toString() ??
                            c['nombre_usuario']?.toString() ??
                            c['usuario']?.toString() ??
                            'Usuario';
                        final preview = c['ultimo_mensaje']?.toString() ??
                            c['mensaje']?.toString() ??
                            c['preview']?.toString() ??
                            'Sin mensajes';
                        final id = c['id_conversacion']?.toString() ??
                            c['id']?.toString() ??
                            '';
                        final pago = _esPagoPersonal(c);

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PantallaAdminChat(
                                  idConversacion: id,
                                  nombreUsuario: nombre,
                                  mensajeInicialUsuario: preview,
                                  esPagoPersonal: pago,
                                ),
                              ),
                            ).then((_) => _recargar());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: pago
                                    ? const Color(0xFFBFD4FF)
                                    : const Color(0xFFE1E8F3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: pago
                                        ? const Color(0xFF285FE8)
                                        : const Color(0xFFEDF3FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    pago
                                        ? Icons.payments_outlined
                                        : Icons.chat_bubble_outline,
                                    color: pago
                                        ? Colors.white
                                        : const Color(0xFF285FE8),
                                    size: 22,
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
                                              nombre,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF17243C),
                                              ),
                                            ),
                                          ),
                                          if (pago)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE8F0FE),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                'Pago personal',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF285FE8),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        preview,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF66758D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF94A0B3),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
