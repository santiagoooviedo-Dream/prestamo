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
  /// Si es true, el valor va debajo (mejor para correos largos).
  final bool valorAbajo;

  const FilaDatoAdmin({
    super.key,
    required this.etiqueta,
    required this.valor,
    this.ultimo = false,
    this.valorAbajo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: ultimo
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF0F3F8))),
      ),
      child: valorAbajo
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF66758D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF17243C),
                    height: 1.3,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    etiqueta,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF66758D),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    valor,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
