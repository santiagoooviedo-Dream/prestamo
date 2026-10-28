import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_chat.dart';

/// Figma: Conversaciones (soporte admin)
class PantallaAdminConversaciones extends StatelessWidget {
  const PantallaAdminConversaciones({super.key});

  static const _items = [
    _Conv(
      nombre: 'Nombre usuario',
      apellidos: 'Apellidos Usuario',
      asunto: 'Consulta sobre prestamo',
      preview: 'Hola queria saber cuando sera mi proximo pago',
      ultimo: 'Último mensaje: 12 mayo 2026',
      pendiente: true,
    ),
    _Conv(
      nombre: 'Nombre usuario',
      apellidos: 'Apellidos Usuario',
      asunto: 'Consulta sobre prestamo',
      preview: 'Gracias por la ayuda con el pago',
      ultimo: 'Último mensaje: 12 mayo 2026',
      pendiente: false,
    ),
  ];

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
              'Revisa y gestiona las conversaciones pendientes.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final c = _items[i];
                  final iniciales =
                      '${c.nombre.isNotEmpty ? c.nombre[0] : ''}${c.apellidos.isNotEmpty ? c.apellidos[0] : ''}'
                          .toUpperCase();

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PantallaAdminChat(
                            nombreUsuario: c.nombre,
                            mensajeInicialUsuario: c.preview,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE1E8F3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.nombre,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF17243C),
                                      ),
                                    ),
                                    Text(
                                      c.apellidos,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF66758D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: c.pendiente
                                      ? const Color(0xFFFFF4E5)
                                      : const Color(0xFFEAF7F0),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  c.pendiente ? 'Pendiente' : 'Cerrado',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: c.pendiente
                                        ? const Color(0xFFA65B0B)
                                        : const Color(0xFF168261),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F0FE),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    iniciales,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF285FE8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.asunto,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF17243C),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      c.ultimo,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF94A0B3),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      c.preview,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF66758D),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
    );
  }
}

class _Conv {
  final String nombre;
  final String apellidos;
  final String asunto;
  final String preview;
  final String ultimo;
  final bool pendiente;

  const _Conv({
    required this.nombre,
    required this.apellidos,
    required this.asunto,
    required this.preview,
    required this.ultimo,
    required this.pendiente,
  });
}
