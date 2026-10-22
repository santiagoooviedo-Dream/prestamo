import 'package:flutter/material.dart';

import '../models/calendario_pagos_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/cuenta/lista_cuotas_pendientes.dart';

class PantallaCalendarioPagos extends StatefulWidget {
  const PantallaCalendarioPagos({super.key});

  @override
  State<PantallaCalendarioPagos> createState() =>
      _PantallaCalendarioPagosState();
}

class _PantallaCalendarioPagosState extends State<PantallaCalendarioPagos> {
  final _modelo = const CalendarioPagosModel();
  late Future<List<CuotaPrestamoModel>> _cuotas;

  @override
  void initState() {
    super.initState();
    _cuotas = _modelo.obtenerCuotas();
  }

  void _reintentar() => setState(() => _cuotas = _modelo.obtenerCuotas());

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'MI CUENTA / CALENDARIO',
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
              'Calendario de pagos',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Consulta las fechas y el estado de tus cuotas.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<CuotaPrestamoModel>>(
                future: _cuotas,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            snapshot.error is ApiException
                                ? (snapshot.error as ApiException).mensaje
                                : 'No se pudieron cargar tus cuotas.',
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
                  return ListaCuotasPendientes(cuotas: snapshot.data!);
                },
              ),
            ),
            const AvisoSeguridad(
              texto: 'Los pagos en línea aún no están disponibles. Consulta soporte para registrar un pago.',
            ),
          ],
        ),
      ),
    );
  }
}
