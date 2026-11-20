import 'package:flutter/material.dart';

import '../../models/calendario_pagos_model.dart';
import '../../nucleo/colores_app.dart';

class ListaCuotasPendientes extends StatelessWidget {
  final List<CuotaPrestamoModel> cuotas;

  const ListaCuotasPendientes({super.key, required this.cuotas});

  @override
  Widget build(BuildContext context) {
    if (cuotas.isEmpty) {
      return const Center(child: Text('No tienes cuotas registradas.'));
    }
    return ListView.separated(
      itemCount: cuotas.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, indice) {
        final cuota = cuotas[indice];
        final pagada = cuota.estado == 'pagada';
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColoresApp.blanco,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ColoresApp.bordeTarjeta),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: pagada
                    ? ColoresApp.exitoClaro
                    : ColoresApp.fondoInicio,
                child: Icon(
                  pagada ? Icons.check : Icons.calendar_today_outlined,
                  color: pagada
                      ? ColoresApp.exitoProfundo
                      : ColoresApp.primario,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cuota ${cuota.numero}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColoresApp.textoPrincipal,
                      ),
                    ),
                    Text(
                      cuota.fecha == null
                          ? 'Fecha no disponible'
                          : '${cuota.fecha!.day}/${cuota.fecha!.month}/${cuota.fecha!.year}',
                      style: const TextStyle(color: ColoresApp.textoSecundario),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${formatoMontoCuota(cuota.monto)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                  Text(
                    pagada ? 'Pagada' : cuota.estado,
                    style: TextStyle(
                      fontSize: 12,
                      color: pagada
                          ? ColoresApp.exitoProfundo
                          : ColoresApp.primario,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
