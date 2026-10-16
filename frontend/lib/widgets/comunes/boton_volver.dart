import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class BotonVolver extends StatelessWidget {
  final VoidCallback? alPresionar;

  const BotonVolver({super.key, this.alPresionar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alPresionar ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: ColoresApp.blanco,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColoresApp.bordeVolver),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A17243C),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          size: 20,
          color: ColoresApp.textoPrincipal,
        ),
      ),
    );
  }
}
