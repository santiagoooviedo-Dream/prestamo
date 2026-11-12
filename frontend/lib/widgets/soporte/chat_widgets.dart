import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';
import '../comunes/boton_volver.dart';

class CabeceraAsistente extends StatelessWidget {
  final VoidCallback alVolver;
  final VoidCallback? alVerAnteriores;

  const CabeceraAsistente({
    super.key,
    required this.alVolver,
    this.alVerAnteriores,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BotonVolver(alPresionar: alVolver),
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
        if (alVerAnteriores != null) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: alVerAnteriores,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF3FF),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: const Color(0xFFD6E4FF)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history_rounded, size: 16, color: Color(0xFF285FE8)),
                  SizedBox(width: 6),
                  Text(
                    'Ver conversaciones anteriores',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF285FE8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

final _urlImagenRe = RegExp(r'https?://[^\s)]+', caseSensitive: false);

bool _esUrlImagen(String u) {
  final l = u.toLowerCase();
  return l.contains('cloudinary') ||
      l.endsWith('.jpg') ||
      l.endsWith('.jpeg') ||
      l.endsWith('.png') ||
      l.endsWith('.webp') ||
      l.contains('/image/') ||
      l.contains('/upload/');
}

List<String> extraerUrlsImagen(String texto) {
  return _urlImagenRe
      .allMatches(texto)
      .map((m) => m.group(0)!)
      .where(_esUrlImagen)
      .toList();
}

String textoSinUrlsImagen(String texto) {
  var t = texto;
  for (final u in extraerUrlsImagen(texto)) {
    t = t
        .replaceAll(u, '')
        .replaceAll('Comprobante:', '')
        .replaceAll('Comprobante :', '');
  }
  return t.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
}

class BurbujaChat extends StatelessWidget {
  final String texto;
  final bool propio;

  const BurbujaChat({super.key, required this.texto, required this.propio});

  void _verImagen(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _VisorImagenChat(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = extraerUrlsImagen(texto);
    final textoLimpio = textoSinUrlsImagen(texto);

    return Align(
      alignment: propio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        decoration: BoxDecoration(
          color: propio ? const Color(0xFF285FE8) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: propio ? null : Border.all(color: const Color(0xFFE1E8F3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (textoLimpio.isNotEmpty)
              Text(
                textoLimpio,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: propio ? Colors.white : const Color(0xFF17243C),
                ),
              ),
            if (urls.isNotEmpty) ...[
              if (textoLimpio.isNotEmpty) const SizedBox(height: 8),
              ...urls.map((url) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: GestureDetector(
                    onTap: () => _verImagen(context, url),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 220,
                          minWidth: 120,
                        ),
                        child: Image.network(
                          url,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 120,
                              alignment: Alignment.center,
                              color: propio
                                  ? const Color(0x33214EC4)
                                  : const Color(0xFFF3F6FC),
                              child: const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            height: 80,
                            alignment: Alignment.center,
                            child: Text(
                              'No se pudo cargar la imagen',
                              style: TextStyle(
                                fontSize: 12,
                                color: propio
                                    ? Colors.white70
                                    : const Color(0xFF66758D),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Text(
                'Toca la imagen para ampliarla',
                style: TextStyle(
                  fontSize: 11,
                  color: propio ? Colors.white70 : const Color(0xFF94A0B3),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VisorImagenChat extends StatelessWidget {
  final String url;
  const _VisorImagenChat({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Comprobante', style: TextStyle(fontSize: 16)),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 4,
          child: Image.network(
            url,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Text(
              'No se pudo cargar la imagen',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}

class SugerenciaChat extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;

  const SugerenciaChat(this.texto, {super.key, required this.onTap});

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

class SugerenciasChat extends StatelessWidget {
  final ValueChanged<String> alSeleccionar;

  const SugerenciasChat({super.key, required this.alSeleccionar});

  static const _textos = [
    '¿Cómo puedo solicitar un préstamo?',
    'Quiero saber sobre mis cuotas',
    '¿Cómo hago un pago?',
    'Hablar con un agente',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _textos
          .map(
            (texto) => SugerenciaChat(
              texto,
              onTap: () => alSeleccionar(texto),
            ),
          )
          .toList(),
    );
  }
}
