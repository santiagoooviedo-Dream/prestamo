import 'package:flutter/material.dart';

import '../../models/solicitud_admin.dart';
import 'tarjeta_blanca_admin.dart';
import '../../nucleo/colores_app.dart';

class ContenidoDetalleSolicitud extends StatelessWidget {
  final SolicitudAdmin solicitud;

  const ContenidoDetalleSolicitud({super.key, required this.solicitud});

  String _fFecha(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final s = solicitud;
    final interes = (s.monto * 0.10).round();
    final total = s.monto + interes;
    final base = total ~/ (s.cuotas == 0 ? 1 : s.cuotas);
    final ahora = DateTime.now();
    final inicio = DateTime(ahora.year, ahora.month + 1, 15);
    final metodo = s.metodoDesembolso == 'nequi'
        ? 'Nequi${s.telefonoNequi != null ? ' (${s.telefonoNequi})' : ''}'
        : 'Efectivo / recogida';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ColoresApp.advertenciaFondo,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            s.pendiente ? 'Pendiente de revisión' : s.estado,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: s.pendiente
                  ? ColoresApp.advertenciaProfundo2
                  : ColoresApp.exitoProfundo,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColoresApp.primario,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monto solicitado',
                style: TextStyle(fontSize: 13, color: ColoresApp.chipAzul),
              ),
              const SizedBox(height: 6),
              Text(
                '\$${SolicitudAdmin.formatoMonto(s.monto)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: ColoresApp.blanco,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${s.cuotas} cuotas mensuales',
                style: const TextStyle(fontSize: 14, color: ColoresApp.chipAzul),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TarjetaBlancaAdmin(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Datos de la solicitud',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: ColoresApp.textoPrincipal,
                ),
              ),
              const SizedBox(height: 8),
              FilaDatoAdmin(
                etiqueta: 'Solicitante',
                valor: '${s.nombre} ${s.apellidos}'.trim(),
              ),
              FilaDatoAdmin(etiqueta: 'Motivo', valor: s.motivo.isEmpty ? '—' : s.motivo),
              FilaDatoAdmin(etiqueta: 'Método de desembolso', valor: metodo),
              FilaDatoAdmin(
                etiqueta: 'Cuotas',
                valor: '${s.cuotas}',
                ultimo: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TarjetaBlancaAdmin(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen estimado',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: ColoresApp.textoPrincipal,
                ),
              ),
              const SizedBox(height: 8),
              FilaDatoAdmin(
                etiqueta: 'Interés (10 %)',
                valor: '\$${SolicitudAdmin.formatoMonto(interes)}',
              ),
              FilaDatoAdmin(
                etiqueta: 'Total a pagar',
                valor: '\$${SolicitudAdmin.formatoMonto(total)}',
              ),
              FilaDatoAdmin(
                etiqueta: 'Cuota aproximada',
                valor: '\$${SolicitudAdmin.formatoMonto(base)}',
                ultimo: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TarjetaBlancaAdmin(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Primeras fechas estimadas',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: ColoresApp.textoPrincipal,
                ),
              ),
              const SizedBox(height: 8),
              FilaDatoAdmin(
                etiqueta: 'Primera cuota',
                valor: _fFecha(inicio),
              ),
              FilaDatoAdmin(
                etiqueta: 'Última cuota',
                valor: _fFecha(
                  DateTime(inicio.year, inicio.month + s.cuotas - 1, 15),
                ),
                ultimo: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Revisa los datos antes de aprobar o rechazar.',
          style: TextStyle(fontSize: 13, color: ColoresApp.textoSecundario, height: 1.4),
        ),
      ],
    );
  }
}
