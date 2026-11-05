import 'package:flutter/material.dart';

import '../../models/cuenta_model.dart';
import '../../pantallas/pantalla_actividad_cuenta.dart';
import '../../pantallas/pantalla_calendario_pagos.dart';
import '../comunes/boton_primario.dart';

/// Estado de cuenta — layout Figma
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
                  color: const Color(0xFF285FE8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33285FE8),
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
                        color: Color(0xFFD6E4FF),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${formatoMontoCuenta(estado.montoTotal)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
                                  color: Color(0xFFD6E4FF),
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
                                  color: Colors.white,
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
                                  color: Color(0xFFD6E4FF),
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
                                  color: Colors.white,
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
                        color: Color(0xFF17243C),
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
                        color: Color(0xFF285FE8),
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
                    style: TextStyle(fontSize: 14, color: Color(0xFF66758D)),
                  ),
                )
              else
                ...recientes.map((m) => _ItemActividad(movimiento: m)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD9E5FA)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 18,
                      color: Color(0xFF285FE8),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Consulta el calendario de pagos para ver todas tus fechas importantes.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF66758D),
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
        ? const Color(0xFF168261)
        : const Color(0xFFC47A00);
    final signo = movimiento.positivo ? '+' : '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconoMovimiento(movimiento.tipoIcono),
              size: 20,
              color: const Color(0xFF285FE8),
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
                    color: Color(0xFF17243C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  movimiento.descripcion,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF66758D),
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
                  color: Color(0xFF94A0B3),
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

