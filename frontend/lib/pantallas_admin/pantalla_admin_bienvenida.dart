import 'package:flutter/material.dart';

import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/logo_app_bytes.dart';
import 'pantalla_admin_menu.dart';

class PantallaAdminBienvenida extends StatelessWidget {
  const PantallaAdminBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 8, 24, 20 + bottom),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Préstamos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ColoresApp.primario,
                  ),
                ),
                Text(
                  'ADMINISTRADOR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 28),
              decoration: BoxDecoration(
                color: ColoresApp.fondoInicio,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColoresApp.blanco,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: ColoresApp.sombraBotonMedia,
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image(
                      image: MemoryImage(logoAppBytes),
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'PRESTAMOS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColoresApp.primario,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Bienvenido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Gestiona usuarios, préstamos y la actividad de la aplicación desde aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: ColoresApp.textoSecundario,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [ColoresApp.blobSuave, ColoresApp.fondoAzulClaro2],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColoresApp.bordeAviso),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined,
                      size: 20, color: ColoresApp.primario),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tu seguridad es importante para nosotros. Cuidamos tu información en cada paso.',
                      style: TextStyle(
                        fontSize: 13,
                        color: ColoresApp.textoSecundario,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            BotonPrimario(
              texto: 'Ingresar',
              alPresionar: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PantallaAdminMenu(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
