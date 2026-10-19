import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';
import 'pantalla_solicitud_enviada.dart';

class PantallaDatosPersonales extends StatefulWidget {
  const PantallaDatosPersonales({super.key});

  @override
  State<PantallaDatosPersonales> createState() =>
      _PantallaDatosPersonalesState();
}

class _PantallaDatosPersonalesState extends State<PantallaDatosPersonales> {
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _documentoCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _telefonoCtrl.dispose();
    _documentoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColoresApp.fondoInicio, ColoresApp.fondoFin],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BotonVolver(),
                    Text(
                      'REGISTRO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ColoresApp.textoContexto,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Empecemos por ti',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoPrincipal,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Completa tus datos personales para crear tu cuenta de forma segura.',
                  style: TextStyle(
                    fontSize: 15,
                    color: ColoresApp.textoSecundario,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                CampoTexto(
                  etiqueta: 'Nombre',
                  pista: 'Tu nombre',
                  controlador: _nombreCtrl,
                ),
                const SizedBox(height: 16),
                CampoTexto(
                  etiqueta: 'Apellido',
                  pista: 'Tu apellido',
                  controlador: _apellidoCtrl,
                ),
                const SizedBox(height: 16),
                CampoTexto(
                  etiqueta: 'Teléfono',
                  pista: '+57 300 000 0000',
                  controlador: _telefonoCtrl,
                  tipoTeclado: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CampoTexto(
                  etiqueta: 'Documento de identidad',
                  pista: 'Número de documento',
                  controlador: _documentoCtrl,
                  tipoTeclado: TextInputType.number,
                ),
                const SizedBox(height: 40),
                BotonPrimario(
                  texto: 'Continuar',
                  alPresionar: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaSolicitudEnviada()),
                  );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
