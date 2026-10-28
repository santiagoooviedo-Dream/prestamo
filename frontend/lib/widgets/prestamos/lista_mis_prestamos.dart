import 'package:flutter/material.dart';

import '../../models/prestamo_model.dart';
import '../../nucleo/api_service.dart';
import '../../pantallas/pantalla_calendario_pagos.dart';
import '../../pantallas/pantalla_detalle_prestamo.dart';
import '../../pantallas/pantalla_inicio.dart';
import '../../pantallas/pantalla_prestamos_anteriores.dart';
import '../../pantallas/pantalla_solicitar_prestamo.dart';
import '../comunes/boton_primario.dart';
import '../comunes/boton_volver.dart';

class ListaMisPrestamos extends StatelessWidget {
  final double top;
  final PrestamosUsuario? datos;
  final bool cargando;
  final Object? error;
  final VoidCallback alReintentar;

  const ListaMisPrestamos({
    super.key,
    required this.top,
    required this.datos,
    required this.cargando,
    required this.error,
    required this.alReintentar,
  });

  @override
  Widget build(BuildContext context) {
    final actual = datos?.prestamosActivos;
    final prestamo = actual == null || actual.isEmpty ? null : actual.first;
    final prestamos = datos?.prestamos ?? const <Map<String, dynamic>>[];
    final solicitudesPendientes =
        datos?.solicitudes.where((solicitud) {
          final estado = solicitud['estado']?.toString().toLowerCase();
          if (estado != 'aceptada') return true;
          return !prestamos.any(
            (prestamo) =>
                prestamo['id_solicitud']?.toString() ==
                solicitud['id_solicitud']?.toString(),
          );
        }).toList() ??
        const <Map<String, dynamic>>[];

    return ListView(
      padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BotonVolver(
              alPresionar: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const PantallaInicio()),
                (_) => false,
              ),
            ),
            const Text(
              'PRÉSTAMOS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF41618E),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Mis préstamos',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF17243C),
          ),
        ),
        const SizedBox(height: 16),
        if (cargando)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (error != null)
          _EstadoCarga(
            mensaje: error is ApiException
                ? (error as ApiException).mensaje
                : 'No se pudo cargar la información.',
            accion: alReintentar,
          )
        else ...[
          if (prestamo != null)
            _TarjetaPrestamoActual(
              prestamo: prestamo,
              cuotas: datos!.cuotasDelPrestamo(prestamo['id_prestamo']),
            )
          else
            const _EstadoVacio(),
          for (final solicitud in solicitudesPendientes)
            _TarjetaSolicitud(solicitud: solicitud),
          const SizedBox(height: 12),
          _AccesoHistorial(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PantallaPrestamosAnteriores(),
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        if (prestamo != null)
          BotonPrimario(
            texto: 'Ver calendario de pagos',
            alPresionar: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PantallaCalendarioPagos(),
              ),
            ),
          )
        else
          BotonPrimario(
            texto: 'Solicitar un préstamo',
            alPresionar: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PantallaSolicitarPrestamo(),
              ),
            ),
          ),
      ],
    );
  }
}

class _TarjetaPrestamoActual extends StatelessWidget {
  final Map<String, dynamic> prestamo;
  final List<Map<String, dynamic>> cuotas;

  const _TarjetaPrestamoActual({required this.prestamo, required this.cuotas});

  @override
  Widget build(BuildContext context) {
    final total =
        int.tryParse(prestamo['coutas']?.toString() ?? '') ?? cuotas.length;
    final pagadas = cuotas.where(_estaPagada).length;
    final pendientes = (total - pagadas).clamp(0, total);
    final progreso = total == 0
        ? 0.0
        : (pagadas / total).clamp(0.0, 1.0).toDouble();
    return Column(
      children: [
        _TocablePrestamo(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PantallaDetallePrestamo(prestamo: prestamo, cuotas: cuotas),
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF285FE8), Color(0xFF214EC4)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Préstamo actual',
                  style: TextStyle(fontSize: 12, color: Color(0xFFE4EDFF)),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${formatoMontoPrestamo(prestamo['monto'])}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Divider(color: Color(0x66FFFFFF), height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cuotas pendientes',
                      style: TextStyle(fontSize: 11, color: Color(0xFFE4EDFF)),
                    ),
                    Text(
                      total == 0 ? '—' : '$pendientes de $total',
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _TocablePrestamo(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PantallaDetallePrestamo(prestamo: prestamo, cuotas: cuotas),
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E8F3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Préstamo personal',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF17243C),
                        ),
                      ),
                    ),
                    const _Etiqueta(texto: 'Activo'),
                  ],
                ),
                const SizedBox(height: 12),
                _FilaDato(
                  etiqueta: 'Fecha',
                  valor: formatoFechaPrestamo(prestamo['fecha_inicio']),
                ),
                const SizedBox(height: 10),
                _FilaDato(
                  etiqueta: 'Cuota mensual',
                  valor:
                      '\$${formatoMontoPrestamo(prestamo['coutas_mensual'])}',
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progreso,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFE3E9F2),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF285FE8)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  total == 0
                      ? 'Cuotas aún no disponibles'
                      : '$pagadas de $total cuotas pagadas',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF66758D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AccesoHistorial extends StatelessWidget {
  final VoidCallback onTap;

  const _AccesoHistorial({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E8F3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.history_rounded, color: Color(0xFF285FE8), size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Préstamos anteriores',
                  style: TextStyle(fontSize: 13, color: Color(0xFF17243C)),
                ),
              ),
              Icon(Icons.chevron_right, color: Color(0xFF94A0B3), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _TocablePrestamo extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _TocablePrestamo({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}

class _TarjetaSolicitud extends StatelessWidget {
  final Map<String, dynamic> solicitud;

  const _TarjetaSolicitud({required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final estado = solicitud['estado']?.toString() ?? 'pendiente';
    final metodo = solicitud['metodo_desembolso']?.toString();
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Solicitud #${solicitud['id_solicitud'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF17243C),
                  ),
                ),
              ),
              _Etiqueta(texto: estado),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${formatoMontoPrestamo(solicitud['monto_solicitado'])} · ${solicitud['coutas'] ?? '—'} cuotas',
            style: const TextStyle(fontSize: 14, color: Color(0xFF17243C)),
          ),
          const SizedBox(height: 4),
          Text(
            'Desembolso: ${metodo == 'nequi' ? 'Nequi · ${solicitud['telefono_nequi'] ?? ''}' : 'Efectivo'}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF66758D)),
          ),
        ],
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  final String texto;

  const _Etiqueta({required this.texto});

  @override
  Widget build(BuildContext context) {
    final normalizado = texto.isEmpty ? 'Pendiente' : texto;
    final completado = normalizado.toLowerCase() == 'completado';
    final color = completado
        ? const Color(0xFF168261)
        : const Color(0xFF285FE8);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '${normalizado[0].toUpperCase()}${normalizado.substring(1)}',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _FilaDato extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const _FilaDato({required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(fontSize: 11, color: Color(0xFF8090A7)),
        ),
        Text(
          valor,
          style: const TextStyle(fontSize: 11, color: Color(0xFF17243C)),
        ),
      ],
    );
  }
}

bool _estaPagada(Map<String, dynamic> cuota) {
  final estado = cuota['estado']?.toString().toLowerCase();
  return estado == 'pagada' || estado == 'pagado';
}

class _EstadoCarga extends StatelessWidget {
  final String mensaje;
  final VoidCallback accion;

  const _EstadoCarga({required this.mensaje, required this.accion});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      children: [
        Text(mensaje, textAlign: TextAlign.center),
        TextButton(onPressed: accion, child: const Text('Reintentar')),
      ],
    ),
  );
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 28),
    child: Center(
      child: Text(
        'Todavía no tienes préstamos activos.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Color(0xFF66758D)),
      ),
    ),
  );
}
