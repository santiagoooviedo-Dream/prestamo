import 'package:flutter/material.dart';

import '../models/conversacion_model.dart';
import '../nucleo/api_service.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/soporte/chat_widgets.dart';
import 'pantalla_inicio.dart';

/// Figma: Asistente virtual (SOPORTE)
class PantallaAsistenteVirtual extends StatefulWidget {
  const PantallaAsistenteVirtual({super.key});

  @override
  State<PantallaAsistenteVirtual> createState() =>
      _PantallaAsistenteVirtualState();
}

class _PantallaAsistenteVirtualState extends State<PantallaAsistenteVirtual> {
  final _modelo = const ConversacionModel();
  final _ctrl = TextEditingController();
  final _mensajes = <_Msg>[
    _Msg(
      texto:
          'Hola, soy tu asistente virtual. Estoy aquí para resolver tus dudas.',
      propio: false,
    ),
  ];
  String? _idConversacion;
  String? _errorConversacion;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _crearConversacion();
  }

  Future<void> _crearConversacion() async {
    try {
      final id = await _modelo.crear();
      if (mounted) setState(() => _idConversacion = id);
    } on ApiException catch (error) {
      if (mounted) setState(() => _errorConversacion = error.mensaje);
    }
  }

  Future<void> _enviar([String? texto]) async {
    final t = (texto ?? _ctrl.text).trim();
    if (t.isEmpty || _enviando) return;
    final id = _idConversacion;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _errorConversacion ??
                'Conectando con el asistente. Inténtalo de nuevo.',
          ),
        ),
      );
      return;
    }
    setState(() {
      _mensajes.add(_Msg(texto: t, propio: true));
      _ctrl.clear();
      _enviando = true;
    });
    try {
      final respuesta = await _modelo.enviarMensaje(id, t);
      if (mounted) {
        setState(() => _mensajes.add(_Msg(texto: respuesta, propio: false)));
      }
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.mensaje)));
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
                  CabeceraAsistente(
                    alVolver: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const PantallaInicio()),
                      (_) => false,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ..._mensajes.map(
                          (m) => BurbujaChat(texto: m.texto, propio: m.propio),
                        ),
                        const SizedBox(height: 12),
                        SugerenciasChat(alSeleccionar: _enviar),
                      ],
                    ),
                  ),
                  // Input
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFE1E8F3),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: _ctrl,
                              enabled: _idConversacion != null && !_enviando,
                              decoration: const InputDecoration(
                                hintText: 'Escribe tu mensaje',
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
                          onTap: _idConversacion == null || _enviando
                              ? null
                              : () => _enviar(),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFF285FE8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const BarraNavegacion(actual: DestinoNav.soporte),
        ],
      ),
    );
  }
}

class _Msg {
  final String texto;
  final bool propio;
  _Msg({required this.texto, required this.propio});
}
