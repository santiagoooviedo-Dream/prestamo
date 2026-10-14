import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/fondos/widgetsFondoColor.dart';
import '../widgets/mi_perfil/perfil_header.dart';
import '../widgets/mi_perfil/perfil_menu.dart';


class MiPerfilScreen extends StatelessWidget {
  final Sesion sesion;

  const MiPerfilScreen({super.key, required this.sesion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        tipo: TipoFondo.azulBlancoTotalA,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              return SizedBox(
                width: w,
                height: h,
                child: Stack(
                  children: [
                    PerfilHeader(
                      width: w,
                      height: h,
                      usuario: sesion.usuario,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    PerfilMenu(
                      width: w,
                      height: h,
                      onCambiarContrasena: () {
                        // TODO: navegar a cambiar contraseña
                      },
                      onCambiarCorreo: () {
                        // TODO: navegar a cambiar correo
                      },
                      onEstadoCuenta: () {
                     
                      },
                      onNotificaciones: () {
                        // TODO: navegar a notificaciones
                      },
                      onCerrarSesion: () {
                      
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
