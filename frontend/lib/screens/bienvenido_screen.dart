import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../widgets/fondos/widgetsFondo1.dart';
import '../widgets/fondos/widgetsFondoColor.dart';
import '../widgets/bienvenido/bienvenido_header.dart';
import '../widgets/bienvenido/bienvenido_grid.dart';
import '../widgets/bienvenido/bienvenido_footer.dart';
import 'mi_perfil_screen.dart';
import 'estado_cuenta_screen.dart';
import 'actividad_cuenta_screen.dart';

class BienvenidoScreen extends StatelessWidget {
  final Sesion sesion;

  const BienvenidoScreen({super.key, required this.sesion});

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
                    BienvenidoHeader(width: w, height: h),
                    BienvenidoGrid(
                      width: w,
                      height: h,
                      onSolicitar: () {
                        // TODO: navegar a solicitar prestamo
                      },
                      onSoporte: () {
                        // TODO: navegar a asistente virtual
                      },
                      onHistorial: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ActividadCuentaScreen(
                              sesion: sesion,
                            ),
                          ),
                        );
                      },
                      onPerfil: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => MiPerfilScreen(sesion: sesion),
                          ),
                        );
                      },
                    ),
                    BienvenidoFooter(width: w, height: h),
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
