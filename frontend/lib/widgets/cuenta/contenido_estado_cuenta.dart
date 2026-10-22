import 'package:flutter/material.dart';

import '../../models/cuenta_model.dart';
import '../../pantallas/pantalla_actividad_cuenta.dart';
import '../../pantallas/pantalla_calendario_pagos.dart';
import '../comunes/aviso_seguridad.dart';
import '../comunes/boton_primario.dart';

class ContenidoEstadoCuenta extends StatelessWidget {
  final CuentaEstado estado;

  const ContenidoEstadoCuenta({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final proxima = estado.proximaCuota;
    final fecha = DateTime.tryParse(proxima?['fecha_pago']?.toString() ?? '');
    final proximaTexto = fecha == null
        ? 'Sin pagos pendientes'
        : '${fecha.day}/${fecha.month}/${fecha.year}';
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF214EC4), Color(0xFF2865D8)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monto total de préstamos',
                      style: TextStyle(fontSize: 13, color: Color(0xFFE4EDFF)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _monto(estado.montoTotal),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _DatoResumen(
                            etiqueta: 'Cuotas pagadas',
                            valor:
                                '${estado.cuotasPagadas} de ${estado.totalCuotas}',
                          ),
                        ),
                        Expanded(
                          child: _DatoResumen(
                            etiqueta: 'Próximo pago',
                            valor: proximaTexto,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Actividad reciente',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PantallaActividadCuenta(),
                      ),
                    ),
                    child: const Text('Ver todo'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (estado.movimientos.isEmpty)
                const Text(
                  'Todavía no hay movimientos registrados.',
                  style: TextStyle(color: Color(0xFF66758D)),
                )
              else
                for (final movimiento in estado.movimientos.take(3))
                  _MovimientoReciente(movimiento: movimiento),
              const SizedBox(height: 16),
              const AvisoSeguridad(
                texto: 'Consulta el calendario para ver las cuotas pendientes.',
              ),
            ],
          ),
        ),
        BotonPrimario(
          texto: 'Ver calendario de pagos',
          alPresionar: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PantallaCalendarioPagos()),
          ),
        ),
      ],
    );
  }

  String _monto(double monto) {
    final texto = monto.toInt().toString();
    final salida = StringBuffer();
    for (var i = 0; i < texto.length; i++) {
      if (i > 0 && (texto.length - i) % 3 == 0) salida.write('.');
      salida.write(texto[i]);
    }
    return '\$$salida';
  }
}

class _DatoResumen extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const _DatoResumen({required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: const TextStyle(color: Color(0xFFE4EDFF))),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _MovimientoReciente extends StatelessWidget {
  final MovimientoCuenta movimiento;

  const _MovimientoReciente({required this.movimiento});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(movimiento.icono, color: const Color(0xFF285FE8)),
        title: Text(movimiento.titulo),
        subtitle: Text(movimiento.descripcion),
        trailing: Text('\$${movimiento.monto.toStringAsFixed(0)}'),
      ),
    );
  }
}
