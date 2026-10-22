import 'package:flutter/material.dart';

import '../../models/calendario_pagos_model.dart';

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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1E8F3)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: pagada
                    ? const Color(0xFFE8F9F0)
                    : const Color(0xFFEDF3FF),
                child: Icon(
                  pagada ? Icons.check : Icons.calendar_today_outlined,
                  color: pagada
                      ? const Color(0xFF168261)
                      : const Color(0xFF285FE8),
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
                        color: Color(0xFF17243C),
                      ),
                    ),
                    Text(
                      cuota.fecha == null
                          ? 'Fecha no disponible'
                          : '${cuota.fecha!.day}/${cuota.fecha!.month}/${cuota.fecha!.year}',
                      style: const TextStyle(color: Color(0xFF66758D)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${cuota.monto.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  Text(
                    pagada ? 'Pagada' : cuota.estado,
                    style: TextStyle(
                      fontSize: 12,
                      color: pagada
                          ? const Color(0xFF168261)
                          : const Color(0xFF285FE8),
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
