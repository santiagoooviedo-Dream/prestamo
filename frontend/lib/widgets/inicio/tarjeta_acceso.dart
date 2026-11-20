import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class TarjetaAcceso extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const TarjetaAcceso({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 174,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: ColoresApp.blanco,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColoresApp.bordeTarjeta),
          boxShadow: const [
            BoxShadow(
              color: ColoresApp.sombraSuave,
              blurRadius: 16,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: ColoresApp.fondoInicio,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icono, color: ColoresApp.primario, size: 28),
            ),
            const Spacer(),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColoresApp.textoPrincipal,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitulo,
              style: const TextStyle(
                fontSize: 11,
                color: ColoresApp.textoSecundario,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
