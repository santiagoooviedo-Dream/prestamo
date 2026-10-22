import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';
import '../comunes/boton_volver.dart';

class CabeceraAsistente extends StatelessWidget {
  final VoidCallback alVolver;

  const CabeceraAsistente({super.key, required this.alVolver});

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
        const SizedBox(height: 16),
      ],
    );
  }
}

class BurbujaChat extends StatelessWidget {
  final String texto;
  final bool propio;

  const BurbujaChat({super.key, required this.texto, required this.propio});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: propio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: propio ? const Color(0xFF285FE8) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: propio
              ? null
              : Border.all(color: const Color(0xFFE1E8F3)),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: propio ? Colors.white : const Color(0xFF17243C),
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
