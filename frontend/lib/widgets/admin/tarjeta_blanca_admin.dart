import 'package:flutter/material.dart';

class TarjetaBlancaAdmin extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const TarjetaBlancaAdmin({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: child,
    );
  }
}

class FilaDatoAdmin extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final bool ultimo;

  const FilaDatoAdmin({
    super.key,
    required this.etiqueta,
    required this.valor,
    this.ultimo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: ultimo
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF0F3F8))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: const TextStyle(fontSize: 13, color: Color(0xFF66758D)),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
