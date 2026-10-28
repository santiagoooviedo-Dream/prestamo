import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';

/// Figma: Chat (soporte)
class PantallaAdminChat extends StatefulWidget {
  final String nombreUsuario;
  final String? mensajeInicialUsuario;

  const PantallaAdminChat({
    super.key,
    this.nombreUsuario = 'Usuario',
    this.mensajeInicialUsuario,
  });

  @override
  State<PantallaAdminChat> createState() => _PantallaAdminChatState();
}

class _PantallaAdminChatState extends State<PantallaAdminChat> {
  final _ctrl = TextEditingController();
  late final List<_Msg> _msgs;

  @override
  void initState() {
    super.initState();
    _msgs = [
      _Msg(
        widget.mensajeInicialUsuario ??
            'Tuve un problema al realizar el pago,¿me pueden ayudar?',
        deUsuario: true,
      ),
      const _Msg(
        'si claro digame con mas detalle que paso',
        deUsuario: false,
      ),
    ];
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _enviar() {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _msgs.add(_Msg(t, deUsuario: false));
      _ctrl.clear();
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
              'Chat',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: teclado > 0 ? 8 : 0),
                itemCount: _msgs.length,
                itemBuilder: (_, i) {
                  final m = _msgs[i];
                  return Align(
                    alignment: m.deUsuario
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.72,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: m.deUsuario
                            ? Colors.white
                            : const Color(0xFF285FE8),
                        borderRadius: BorderRadius.circular(16),
                        border: m.deUsuario
                            ? Border.all(color: const Color(0xFFE1E8F3))
                            : null,
                        boxShadow: m.deUsuario
                            ? const [
                                BoxShadow(
                                  color: Color(0x0A17243C),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        m.texto,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: m.deUsuario
                              ? const Color(0xFF17243C)
                              : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Input
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
                        hintText: 'Escribe tu mensaje',
                        hintStyle:
                            TextStyle(fontSize: 14, color: Color(0xFF94A0B3)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _enviar,
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
                      size: 20,
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

class _Msg {
  final String texto;
  final bool deUsuario;
  const _Msg(this.texto, {required this.deUsuario});
}
