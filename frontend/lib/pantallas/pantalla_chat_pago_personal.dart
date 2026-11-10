import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';

/// Chat con administrador para coordinar un pago personal / presencial.
class PantallaChatPagoPersonal extends StatefulWidget {
  final int? idPrestamo;
  final int? idCuota;
  final num? monto;

  const PantallaChatPagoPersonal({
    super.key,
    this.idPrestamo,
    this.idCuota,
    this.monto,
  });

  @override
  State<PantallaChatPagoPersonal> createState() =>
      _PantallaChatPagoPersonalState();
}

class _PantallaChatPagoPersonalState extends State<PantallaChatPagoPersonal> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _msgs = [];
  String? _idConversacion;
  bool _cargando = true;
  bool _enviando = false;
  String? _error;

  String get _resumenMonto {
    final m = widget.monto;
    if (m == null) return 'tu cuota';
    final entero = m.round().toString();
    final b = StringBuffer();
    for (var i = 0; i < entero.length; i++) {
      if (i > 0 && (entero.length - i) % 3 == 0) b.write('.');
      b.write(entero[i]);
    }
    return '\$${b.toString()}';
  }

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _iniciar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final creada = await ApiService.crearConversacion();
      final conv = creada['conversacion'] is Map
          ? creada['conversacion'] as Map
          : creada;
      final id = conv['id_conversacion']?.toString() ??
          creada['id_conversacion']?.toString();
      if (id == null || id.isEmpty) {
        throw const ApiException('No se pudo abrir el chat con soporte.');
      }

      // Pasar a administrador (importante para que aparezca en el panel admin)
      try {
        await ApiService.transferirConversacionAAdmin(id);
      } catch (_) {
        // Reintento único si la primera falla
        try {
          await Future.delayed(const Duration(milliseconds: 400));
          await ApiService.transferirConversacionAAdmin(id);
        } catch (_) {}
      }

      final ref =
          'REF_PAGO id_prestamo=${widget.idPrestamo ?? 0} id_cuota=${widget.idCuota ?? 0} monto=${widget.monto ?? 0}';
      final intro =
          'Hola, quiero realizar un pago personal de $_resumenMonto. '
          '¿Me pueden indicar cuándo y dónde puedo acercarme a pagar? '
          '($ref)';

      try {
        await ApiService.enviarMensajeConversacion(
          idConversacion: id,
          mensaje: intro,
        );
      } catch (_) {
        // Si el endpoint de mensajes falla, igual mostramos el mensaje local
      }

      if (!mounted) return;
      setState(() {
        _idConversacion = id;
        _cargando = false;
      });
      await _cargarMensajes();
      if (!mounted) return;
      if (_msgs.isEmpty) {
        setState(() {
          _msgs.add(_Msg(intro, propio: true));
          _msgs.add(
            const _Msg(
              'Un administrador revisará tu solicitud de pago personal y te responderá aquí. Indica el día y la hora en que puedes acercarte.',
              propio: false,
            ),
          );
        });
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.mensaje;
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo iniciar el chat. Inténtalo de nuevo.';
        _cargando = false;
      });
    }
  }


  Future<void> _cargarMensajes() async {
    final id = _idConversacion;
    if (id == null) return;
    try {
      final lista = await ApiService.obtenerMensajesConversacion(id);
      if (!mounted || lista.isEmpty) return;
      final nuevos = <_Msg>[];
      for (final raw in lista) {
        final texto = raw['mensaje']?.toString() ??
            raw['respuesta']?.toString() ??
            raw['contenido']?.toString() ??
            '';
        if (texto.isEmpty) continue;
        final remitente =
            (raw['remitente'] ?? '').toString().toLowerCase().trim();
        // usuario = derecha (azul); admin/bot = izquierda (blanco)
        final propio = remitente == 'usuario' || remitente == 'user';
        nuevos.add(_Msg(texto, propio: propio));
      }
      if (nuevos.isEmpty) return;
      setState(() {
        _msgs
          ..clear()
          ..addAll(nuevos);
      });
      _scrollAlFinal();
    } catch (_) {}
  }

  Future<void> _enviar() async {
    final t = _ctrl.text.trim();
    if (t.isEmpty || _enviando) return;
    final id = _idConversacion;
    if (id == null) return;

    setState(() {
      _msgs.add(_Msg(t, propio: true));
      _ctrl.clear();
      _enviando = true;
    });
    _scrollAlFinal();

    try {
      await ApiService.enviarMensajeConversacion(
        idConversacion: id,
        mensaje: t,
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.mensaje)));
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _scrollAlFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final teclado = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
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
                  'PAGO PERSONAL',
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
              'Chat con administrador',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Coordina tu pago personal de $_resumenMonto.',
              style: const TextStyle(fontSize: 14, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 16),
            if (_cargando)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _iniciar,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: EdgeInsets.only(bottom: teclado > 0 ? 8 : 0),
                  itemCount: _msgs.length,
                  itemBuilder: (_, i) {
                    final m = _msgs[i];
                    return Align(
                      alignment: m.propio
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: m.propio
                              ? const Color(0xFF285FE8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: m.propio
                              ? null
                              : Border.all(color: const Color(0xFFE1E8F3)),
                        ),
                        child: Text(
                          m.texto,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: m.propio
                                ? Colors.white
                                : const Color(0xFF17243C),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
                      child: TextField(
                        controller: _ctrl,
                        onSubmitted: (_) => _enviar(),
                        decoration: const InputDecoration(
                          hintText: 'Escribe cuándo puedes pagar…',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A0B3),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _enviando ? null : _enviar,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF285FE8),
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
                              size: 20,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Msg {
  final String texto;
  final bool propio;
  const _Msg(this.texto, {required this.propio});
}
