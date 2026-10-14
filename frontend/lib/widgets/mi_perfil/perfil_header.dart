import 'package:flutter/material.dart';
import '../../core/colores.dart';
import '../../models/usuario.dart';

class PerfilHeader extends StatelessWidget {
  final double width;
  final double height;
  final Usuario usuario;
  final VoidCallback onBack;
  final VoidCallback? onEditPhoto;

  const PerfilHeader({
    super.key,
    required this.width,
    required this.height,
    required this.usuario,
    required this.onBack,
    this.onEditPhoto,
  });

  String get _iniciales {
    final n = usuario.nombre.isNotEmpty ? usuario.nombre[0] : 'J';
    final a = usuario.apellido.isNotEmpty ? usuario.apellido[0] : 'S';
    return ('$n$a').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = width * 0.30;

    return Stack(
      children: [
        Positioned(
          left: width * 0.05,
          top: height * 0.015,
          child: GestureDetector(
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colores.negro,
              size: 26,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: height * 0.08,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: Colores.blanco,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colores.azul.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _iniciales,
                    style: TextStyle(
                      fontFamily: "Poly",
                      color: Colores.azul,
                      fontSize: avatarSize * 0.32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: GestureDetector(
                    onTap: onEditPhoto,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colores.azul,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colores.blanco,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: width * 0.08,
          right: width * 0.08,
          top: height * 0.08 + avatarSize + height * 0.025,
          child: Text(
            '${usuario.nombre} ${usuario.apellido}'.trim().isEmpty
                ? 'Nombre usuario'
                : '${usuario.nombre} ${usuario.apellido}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Poly",
              color: Colores.negro,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          left: width * 0.08,
          right: width * 0.08,
          top: height * 0.08 + avatarSize + height * 0.065,
          child: Text(
            usuario.correo.isEmpty ? 'correo@ejemplo.com' : usuario.correo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Poly_Regular",
              color: Colores.azul,
              fontSize: 13,
              decoration: TextDecoration.underline,
              decorationColor: Colores.azul,
            ),
          ),
        ),
      ],
    );
  }
}
