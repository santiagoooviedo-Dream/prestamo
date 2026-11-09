import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/soporte/chat_widgets.dart';

/// Lista de conversaciones anteriores del usuario actual.
/// Solo muestra las que estuvieron/están con el administrador.
class PantallaMisConversaciones extends StatefulWidget {
  const PantallaMisConversaciones({super.key});

  @override
  State<PantallaMisConversaciones> createState() =>
      _PantallaMisConversacionesState();
}

class _PantallaMisConversacionesState extends State<PantallaMisConversaciones> {
  bool _cargando = true;
  String? _error;
  List<_ItemConv> _items = [];

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
      final raw = await ApiService.obtenerMisConversaciones();

      // Solo las que el usuario tuvo con el administrador
      final conAdmin = raw.where((c) {
        final modo = (c['modo'] ?? '').toString().toLowerCase().trim();
        final modoAtencion =
            (c['modo_atencion'] ?? '').toString().toLowerCase().trim();
        final estado = (c['estado'] ?? '').toString().toLowerCase().trim();
        if (modo == 'admin') return true;
        if (modoAtencion == 'admin' || modoAtencion == 'humano') return true;
        if (estado == 'transferida' || estado == 'admin') return true;
        return false;
      }).toList();

      final items = <_ItemConv>[];
      for (final c in conAdmin) {
        final id = c['id_conversacion']?.toString() ?? c['id']?.toString() ?? '';
        if (id.isEmpty) continue;

        var preview = c['ultimo_mensaje']?.toString() ??
            c['mensaje']?.toString() ??
            c['preview']?.toString() ??
            '';
        if (preview.isEmpty) {
          try {
            final msgs = await ApiService.obtenerMensajesConversacion(id);
            if (msgs.isNotEmpty) {
              final last = msgs.last;
              preview = last['mensaje']?.toString() ??
                  last['respuesta']?.toString() ??
                  last['contenido']?.toString() ??
                  '';
            }
          } catch (_) {}
        }
        if (preview.isEmpty) preview = 'Sin mensajes';

        final fecha = c['fecha_creacion']?.toString() ??
            c['created_at']?.toString() ??
            '';

        items.add(_ItemConv(
          id: id,
          preview: preview,
          fecha: fecha,
        ));
      }

      // Más recientes primero
      items.sort((a, b) => b.fecha.compareTo(a.fecha));

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
          _error = 'No se pudieron cargar tus conversaciones.';
          _cargando = false;
        });
      }
    }
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
                BotonVolver(alPresionar: () => Navigator.pop(context)),
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
              'Conversaciones anteriores',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Solo tus chats con el administrador.',
              style: TextStyle(fontSize: 14, color: Color(0xFF66758D)),
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
          'Aún no tienes conversaciones con el administrador.',
          style: TextStyle(color: Color(0xFF66758D)),
          textAlign: TextAlign.center,
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
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _PantallaVerConversacion(
                    idConversacion: it.id,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE1E8F3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: Color(0xFF285FE8),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chat con administrador',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF17243C),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          it.preview,
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
                  const Icon(Icons.chevron_right, color: Color(0xFF94A0B3)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ItemConv {
  final String id;
  final String preview;
  final String fecha;
  _ItemConv({required this.id, required this.preview, required this.fecha});
}

/// Chat completo para que el usuario continúe escribiendo con el administrador.
class _PantallaVerConversacion extends StatefulWidget {
  final String idConversacion;

  const _PantallaVerConversacion({required this.idConversacion});

  @override
  State<_PantallaVerConversacion> createState() =>
      _PantallaVerConversacionState();
}

class _PantallaVerConversacionState extends State<_PantallaVerConversacion> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _cargando = true;
  bool _enviando = false;
  String? _error;
  final List<_MsgSimple> _msgs = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final lista =
          await ApiService.obtenerMensajesConversacion(widget.idConversacion);
      final nuevos = <_MsgSimple>[];
      for (final raw in lista) {
        final texto = raw['mensaje']?.toString() ??
            raw['respuesta']?.toString() ??
            raw['contenido']?.toString() ??
            '';
        if (texto.isEmpty) continue;

        // 1. Prioridad: campo remitente / rol
        final remitente = (raw['remitente'] ??
                raw['rol'] ??
                raw['tipo'] ??
                raw['sender'] ??
                '')
            .toString()
            .toLowerCase()
            .trim();

        bool deUsuario = remitente == 'usuario' ||
            remitente == 'user' ||
            remitente == 'cliente' ||
            raw['de_usuario'] == true ||
            raw['es_usuario'] == true;

        // 2. Si el backend no manda remitente, usar heurística por contenido
        if (remitente.isEmpty && !deUsuario) {
          final lower = texto.toLowerCase();
          // Mensajes típicos del usuario
          if (lower.contains('ref_pago') ||
              lower.contains('quiero realizar un pago') ||
              lower.contains('quiero pagar') ||
              lower.contains('pagar en persona') ||
              lower.contains('me pueden indicar') ||
              lower.startsWith('hola, quiero')) {
            deUsuario = true;
          }
          // Mensajes típicos del administrador
          if (lower.contains('fue validado') ||
              lower.contains('queda registrada') ||
              lower.contains('un administrador revisará') ||
              lower.contains('te responderá aquí')) {
            deUsuario = false;
          }
        }

        nuevos.add(_MsgSimple(texto: texto, propio: deUsuario));
      }
      if (!mounted) return;
      setState(() {
        _msgs
          ..clear()
          ..addAll(nuevos);
        _cargando = false;
      });
      _scrollAlFinal();
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No se pudieron cargar los mensajes.';
          _cargando = false;
        });
      }
    }
  }

  void _scrollAlFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _enviar() async {
    final texto = _ctrl.text.trim();
    if (texto.isEmpty || _enviando) return;

    // Agregar localmente como mensaje del usuario (azul, derecha)
    setState(() {
      _msgs.add(_MsgSimple(texto: texto, propio: true));
      _ctrl.clear();
      _enviando = true;
    });
    _scrollAlFinal();

    try {
      await ApiService.enviarMensajeConversacion(
        idConversacion: widget.idConversacion,
        mensaje: texto,
      );
      // No recargamos inmediatamente para no perder el estilo azul del mensaje
      // recién enviado. Solo se refresca si el usuario vuelve a entrar o tira
      // hacia abajo en el futuro.
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.mensaje)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo enviar el mensaje.')),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 12 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
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
            const SizedBox(height: 16),
            const Text(
              'Conversación con administrador',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Puedes seguir escribiendo. El administrador te responderá aquí.',
              style: TextStyle(fontSize: 13, color: Color(0xFF66758D)),
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
                              Text(_error!),
                              TextButton(
                                onPressed: _cargar,
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        )
                      : _msgs.isEmpty
                          ? const Center(
                              child: Text(
                                'No hay mensajes todavía.\nEscribe el primero.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF66758D)),
                              ),
                            )
                          : ListView.builder(
                              controller: _scroll,
                              itemCount: _msgs.length,
                              itemBuilder: (_, i) {
                                final m = _msgs[i];
                                return BurbujaChat(
                                  texto: m.texto,
                                  propio: m.propio,
                                );
                              },
                            ),
            ),
            // Input para seguir escribiendo
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE1E8F3)),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _ctrl,
                      enabled: !_enviando && !_cargando,
                      decoration: const InputDecoration(
                        hintText: 'Escribe tu mensaje...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF94A0B3),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: (_) => _enviar(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _enviando || _cargando ? null : _enviar,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _enviando
                          ? const Color(0xFF94A0B3)
                          : const Color(0xFF285FE8),
                      shape: BoxShape.circle,
                    ),
                    child: _enviando
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MsgSimple {
  final String texto;
  final bool propio;
  _MsgSimple({required this.texto, required this.propio});
}
