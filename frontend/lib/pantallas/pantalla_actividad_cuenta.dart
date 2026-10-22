import 'package:flutter/material.dart';

import '../models/cuenta_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/cuenta/lista_actividad_cuenta.dart';

class PantallaActividadCuenta extends StatefulWidget {
  const PantallaActividadCuenta({super.key});

  @override
  State<PantallaActividadCuenta> createState() =>
      _PantallaActividadCuentaState();
}

class _PantallaActividadCuentaState extends State<PantallaActividadCuenta> {
  final _modelo = const CuentaModel();
  late Future<CuentaEstado> _estado;

  @override
  void initState() {
    super.initState();
    _estado = _modelo.cargar();
  }

  void _reintentar() => setState(() => _estado = _modelo.cargar());

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'MI CUENTA / ACTIVIDAD',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Actividad de cuenta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Consulta los movimientos reales de tu cuenta.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<CuentaEstado>(
                future: _estado,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            snapshot.error is ApiException
                                ? (snapshot.error as ApiException).mensaje
                                : 'No se pudo cargar la actividad.',
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: _reintentar,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListaActividadCuenta(
                    movimientos: snapshot.data!.movimientos,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
