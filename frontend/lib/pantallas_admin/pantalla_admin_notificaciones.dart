import 'package:flutter/material.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';

/// Notificaciones: usuarios que tienen solicitud o actividad (no todos)
class PantallaAdminNotificaciones extends StatefulWidget {
  const PantallaAdminNotificaciones({super.key});

  @override
  State<PantallaAdminNotificaciones> createState() =>
      _PantallaAdminNotificacionesState();
}

class _PantallaAdminNotificacionesState
    extends State<PantallaAdminNotificaciones> {
  final _titulo = TextEditingController();
  final _mensaje = TextEditingController();
  int? _usuarioSel;

  /// Solo usuarios con solicitud / actividad relevante
  // (nombre, detalle, id_usuario) — se puede reemplazar por carga real
  static const _destinatarios = [
    ('Carlos Ruiz', 'Solicitud pendiente', 0),
    ('Ana Pérez', 'Solicitud pendiente', 0),
    ('María López', 'Préstamo completado', 0),
  ];

  @override
  void dispose() {
    _titulo.dispose();
    _mensaje.dispose();
    super.dispose();
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
                  'ADMINISTRADOR',
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
              'Notificaciones',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Elige un usuario con solicitud o actividad para enviarle un mensaje.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: teclado > 0 ? 12 : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Destinatario',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(_destinatarios.length, (i) {
                      final d = _destinatarios[i];
                      final sel = _usuarioSel == i;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () => setState(() => _usuarioSel = i),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: sel
                                    ? const Color(0xFF285FE8)
                                    : const Color(0xFFE1E8F3),
                                width: sel ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(0xFFE8F0FE),
                                  child: Text(
                                    d.$1[0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF285FE8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d.$1,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF17243C),
                                        ),
                                      ),
                                      Text(
                                        d.$2,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF66758D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (sel)
                                  const Icon(Icons.check_circle,
                                      color: Color(0xFF285FE8), size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    CampoTexto(
                      etiqueta: 'Título',
                      pista: 'Ej. Recordatorio de pago',
                      controlador: _titulo,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mensaje',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(minHeight: 120),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE1E8F3)),
                      ),
                      child: TextField(
                        controller: _mensaje,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Escribe el mensaje…',
                          hintStyle: TextStyle(
                              fontSize: 15, color: Color(0xFF94A0B3)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: 'Enviar notificación',
              alPresionar: _usuarioSel == null
                  ? null
                  : () async {
                      final d = _destinatarios[_usuarioSel!];
                      try {
                        // id de demo embebido en el texto si no hay id real
                        final id = d.$3;
                        await ApiService.crearNotificacion(
                          idUsuario: id,
                          mensaje: _mensaje.text.trim().isEmpty
                              ? _titulo.text.trim()
                              : '${_titulo.text.trim()}: ${_mensaje.text.trim()}',
                          tipo: 'info',
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Notificación enviada a ${d.$1}'),
                          ),
                        );
                      } on ApiException catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.mensaje)),
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
