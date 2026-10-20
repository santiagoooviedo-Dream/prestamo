import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_inicio.dart';

/// Figma: Asistente virtual (SOPORTE)
class PantallaAsistenteVirtual extends StatefulWidget {
  const PantallaAsistenteVirtual({super.key});

  @override
  State<PantallaAsistenteVirtual> createState() =>
      _PantallaAsistenteVirtualState();
}

class _PantallaAsistenteVirtualState extends State<PantallaAsistenteVirtual> {
  final _ctrl = TextEditingController();
  final _mensajes = <_Msg>[
    _Msg(
      texto: 'Hola, soy tu asistente virtual. Estoy aquí para resolver tus dudas.',
      propio: false,
    ),
  ];

  void _enviar([String? texto]) {
    final t = (texto ?? _ctrl.text).trim();
    if (t.isEmpty) return;
    setState(() {
      _mensajes.add(_Msg(texto: t, propio: true));
      _ctrl.clear();
      // Respuesta simple demo
      if (t.toLowerCase().contains('préstamo') ||
          t.toLowerCase().contains('solicitar')) {
        _mensajes.add(_Msg(
          texto:
              'Es muy fácil. Ve a Inicio y selecciona "Solicitar préstamo". Allí encontrarás un formulario que debes completar para tu préstamo.',
          propio: false,
        ));
      } else {
        _mensajes.add(_Msg(
          texto:
              'Gracias por tu mensaje. Un agente te ayudará pronto si lo necesitas.',
          propio: false,
        ));
      }
    });
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BotonVolver(
                      alPresionar: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const PantallaInicio()),
                          (_) => false,
                        );
                      },
                    ),
                      Text(
                        'SOPORTE',
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
                    'Asistente virtual',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Estamos aquí para resolver tus dudas.',
                    style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        ..._mensajes.map((m) => _Burbuja(m)),
                        const SizedBox(height: 12),
                        // Sugerencias
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Chip(
                              '¿Cómo puedo solicitar un préstamo?',
                              onTap: () =>
                                  _enviar('¿Cómo puedo solicitar un préstamo?'),
                            ),
                            _Chip(
                              'Quiero saber sobre mis cuotas',
                              onTap: () =>
                                  _enviar('Quiero saber sobre mis cuotas'),
                            ),
                            _Chip(
                              '¿Cómo hago un pago?',
                              onTap: () => _enviar('¿Cómo hago un pago?'),
                            ),
                            _Chip(
                              'Hablar con un agente',
                              onTap: () => _enviar('Hablar con un agente'),
                            ),
                          ],
                        ),
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
                              border:
                                  Border.all(color: const Color(0xFFE1E8F3)),
                            ),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: _ctrl,
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
                          onTap: () => _enviar(),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFF285FE8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send_rounded,
                                color: Colors.white, size: 22),
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

class _Burbuja extends StatelessWidget {
  final _Msg m;
  const _Burbuja(this.m);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: m.propio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: m.propio ? const Color(0xFF285FE8) : Colors.white,
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
            color: m.propio ? Colors.white : const Color(0xFF17243C),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;
  const _Chip(this.texto, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF3FF),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: const Color(0xFFD5E3FF)),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF285FE8),
          ),
        ),
      ),
    );
  }
}
