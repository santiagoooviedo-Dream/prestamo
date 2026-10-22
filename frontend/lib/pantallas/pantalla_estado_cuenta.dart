import 'package:flutter/material.dart';

import '../models/cuenta_model.dart';
import '../nucleo/api_service.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/cuenta/contenido_estado_cuenta.dart';

class PantallaEstadoCuenta extends StatefulWidget {
  const PantallaEstadoCuenta({super.key});

  @override
  State<PantallaEstadoCuenta> createState() => _PantallaEstadoCuentaState();
}

class _PantallaEstadoCuentaState extends State<PantallaEstadoCuenta> {
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
            BotonVolver(alPresionar: () => Navigator.pop(context)),
            const SizedBox(height: 20),
            const Text(
              'Estado de cuenta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Un resumen de tus préstamos y movimientos.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 20),
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
                                : 'No se pudo cargar el estado de cuenta.',
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
                  return ContenidoEstadoCuenta(estado: snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
