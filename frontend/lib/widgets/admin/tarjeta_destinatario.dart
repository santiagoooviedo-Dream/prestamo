import 'package:flutter/material.dart';
import '../../nucleo/colores_app.dart';

class TarjetaDestinatario extends StatelessWidget {
  final String nombre;
  final String correo;
  final String? foto;
  final bool seleccionado;
  final bool mostrarPunto;
  final VoidCallback onTap;

  const TarjetaDestinatario({
    super.key,
    required this.nombre,
    required this.correo,
    required this.seleccionado,
    required this.onTap,
    this.foto,
    this.mostrarPunto = false,
  });

  @override
  Widget build(BuildContext context) {
    final inicial = nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
    final fotoUrl = foto?.trim();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ColoresApp.blanco,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seleccionado
                ? ColoresApp.primario
                : ColoresApp.bordeTarjeta,
            width: seleccionado ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipOval(
                    child: fotoUrl != null && fotoUrl.isNotEmpty
                        ? Image.network(
                            fotoUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _avatarInicial(inicial, seleccionado),
                          )
                        : _avatarInicial(inicial, seleccionado),
                  ),
                  if (mostrarPunto)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: ColoresApp.errorFuerte,
                          shape: BoxShape.circle,
                          border: Border.all(color: ColoresApp.blanco, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                  Text(
                    correo,
                    style: const TextStyle(
                      fontSize: 13,
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
            if (seleccionado)
              const Icon(
                Icons.check_circle,
                color: ColoresApp.primario,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _avatarInicial(String inicial, bool seleccionado) => Container(
    width: 40,
    height: 40,
    color: seleccionado ? ColoresApp.primario : ColoresApp.fondoSeleccionado,
    alignment: Alignment.center,
    child: Text(
      inicial,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: seleccionado ? ColoresApp.blanco : ColoresApp.primario,
      ),
    ),
  );
}
