import 'package:flutter/material.dart';

import '../../models/cuenta_model.dart';
import '../../pantallas/pantalla_actividad_cuenta.dart';
import '../../pantallas/pantalla_calendario_pagos.dart';
import '../comunes/boton_primario.dart';
import '../../nucleo/colores_app.dart';

class ContenidoEstadoCuenta extends StatelessWidget {
  final CuentaEstado estado;

  const ContenidoEstadoCuenta({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final proxima = estado.proximaCuota;
    final fechaProx =
        DateTime.tryParse(proxima?['fecha_pago']?.toString() ?? '');
    final recientes = estado.movimientosRecientes;

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              // Tarjeta azul resumen
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColoresApp.primario,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: ColoresApp.sombraBotonMedia,
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monto total',
                      style: TextStyle(
                        fontSize: 13,
                        color: ColoresApp.chipAzul,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${formatoMontoCuenta(estado.montoTotal)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: ColoresApp.blanco,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Cuotas pagadas',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColoresApp.chipAzul,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                estado.totalCuotas == 0
                                    ? '—'
                                    : '${estado.cuotasPagadas} de ${estado.totalCuotas}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColoresApp.blanco,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Próximo pago',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColoresApp.chipAzul,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                fechaProx == null
                                    ? 'Sin pendientes'
                                    : formatoFechaCortaCuenta(fechaProx),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColoresApp.blanco,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              // Actividad reciente
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Actividad reciente',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColoresApp.textoPrincipal,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PantallaActividadCuenta(),
                        ),
                      );
                    },
                    child: const Text(
                      'Ver todo',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: ColoresApp.primario,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (recientes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Aún no hay movimientos en tu cuenta.',
                    style: TextStyle(fontSize: 14, color: ColoresApp.textoSecundario),
                  ),
                )
              else
                ...recientes.map((m) => _ItemActividad(movimiento: m)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ColoresApp.fondoAzulClaro,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ColoresApp.bordeAviso),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 18,
                      color: ColoresApp.primario,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Consulta el calendario de pagos para ver todas tus fechas importantes.',
                        style: TextStyle(
                          fontSize: 13,
                          color: ColoresApp.textoSecundario,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        BotonPrimario(
          texto: 'Ver calendario de pagos',
          alPresionar: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PantallaCalendarioPagos(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ItemActividad extends StatelessWidget {
  final MovimientoCuenta movimiento;

  const _ItemActividad({required this.movimiento});

  @override
  Widget build(BuildContext context) {
    final colorMonto = movimiento.positivo
        ? ColoresApp.exitoProfundo
        : ColoresApp.advertenciaOscuro;
    final signo = movimiento.positivo ? '+' : '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: ColoresApp.fondoInicio,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconoMovimiento(movimiento.tipoIcono),
              size: 20,
              color: ColoresApp.primario,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movimiento.titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  movimiento.descripcion,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColoresApp.textoSecundario,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$signo\$${formatoMontoCuenta(movimiento.monto)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorMonto,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formatoFechaCortaCuenta(movimiento.fechaDate),
                style: const TextStyle(
                  fontSize: 11,
                  color: ColoresApp.textoSuave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

IconData iconoMovimiento(String tipoIcono) {
  switch (tipoIcono) {
    case 'pago':
      return Icons.calendar_today_outlined;
    case 'interes':
      return Icons.percent_rounded;
    case 'desembolso':
      return Icons.south_west_rounded;
    default:
      return Icons.receipt_long_outlined;
  }
}

