import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_solicitudes.dart';

/// Figma: Detalle de solicitud · Administrador
class PantallaAdminDetalleSolicitud extends StatelessWidget {
  final SolicitudAdmin solicitud;

  const PantallaAdminDetalleSolicitud({
    super.key,
    required this.solicitud,
  });

  static String fmt(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }

  String _fFecha(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final s = solicitud;
    final interes = (s.monto * 0.10).round();
    final total = s.monto + interes;
    final base = total ~/ s.cuotas;
    final resto = total - base * s.cuotas;
    final ahora = DateTime.now();
    final inicio = DateTime(ahora.year, ahora.month + 1, 15);
    final primerVenc = DateTime(inicio.year, inicio.month + 1, 15);
    final ultimoVenc =
        DateTime(inicio.year, inicio.month + s.cuotas, 15);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top + 6, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BotonVolver(
                        alPresionar: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const Text(
                        'ADMINISTRADOR',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: ColoresApp.textoContexto,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Préstamo solicitado',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Revisa la información enviada antes de tomar una decisión.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF66758D),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4E5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      s.pendiente
                          ? 'Pendiente de revisión'
                          : s.estado,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: s.pendiente
                            ? const Color(0xFFA65B0B)
                            : const Color(0xFF168261),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card azul monto
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF285FE8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monto solicitado',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFD6E4FF),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${fmt(s.monto)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${s.cuotas} cuotas mensuales',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFD6E4FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Datos de la solicitud
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Datos de la solicitud',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF17243C),
                                ),
                              ),
                            ),
                            Text(
                              'Solo lectura',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A0B3),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _fila('Tipo', 'Préstamo personal'),
                        const SizedBox(height: 12),
                        const Text(
                          'Motivo del préstamo',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A0B3),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.motivo,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF17243C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Resumen estimado
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Resumen estimado',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF17243C),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F0FE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${s.cuotas} cuotas',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF285FE8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Simulación con interés simple del 10 % sobre el monto solicitado.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF66758D),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _fila('Monto solicitado', '\$${fmt(s.monto)}'),
                        _fila('Periodicidad', 'Mensual'),
                        _fila('Interés total estimado',
                            '10 % · \$${fmt(interes)}'),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F5FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total a pagar',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF94A0B3),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${fmt(total)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF17243C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Cuota mensual',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF94A0B3),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${fmt(base)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF17243C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _fechaCol(
                                  'Inicio previsto', _fFecha(inicio)),
                            ),
                            Expanded(
                              child: _fechaCol('Primer vencimiento',
                                  _fFecha(primerVenc)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _fila(
                            'Último vencimiento', _fFecha(ultimoVenc)),
                        const SizedBox(height: 12),
                        const Text(
                          'Tasa y condiciones por confirmar',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF17243C),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Debe confirmarse la tasa, si su alcance es total, mensual o anual y las condiciones. Esta simulación no es un contrato definitivo.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A0B3),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Calendario de pagos
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Calendario de pagos',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF17243C),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F0FE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${s.cuotas} pagos',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF285FE8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(s.cuotas, (i) {
                          final valor =
                              i == s.cuotas - 1 ? base + resto : base;
                          final fecha = DateTime(
                              primerVenc.year, primerVenc.month + i, 15);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F9FC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFFE8EEF6)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cuota ${i + 1}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF17243C),
                                        ),
                                      ),
                                      Text(
                                        _fFecha(fecha),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF94A0B3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${fmt(valor)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF17243C),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        _fila('Total estimado', '\$${fmt(total)}'),
                        const SizedBox(height: 4),
                        Text(
                          resto > 0
                              ? 'La última cuota incluye un ajuste de \$$resto por redondeo para completar el total estimado.'
                              : 'Valores estimados. Tasa y condiciones por confirmar.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A0B3),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Pie: Aprobar / Rechazar
          if (s.pendiente)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottom),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE1E8F3)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Revisión de la solicitud',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Revisa los datos enviados y las condiciones pendientes de confirmación antes de decidir.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF66758D),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Solicitud de ${s.nombre} aprobada'),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF285FE8),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Aprobar',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Solicitud de ${s.nombre} rechazada'),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFF0F2),
                              foregroundColor: const Color(0xFFBC4351),
                              side: const BorderSide(
                                  color: Color(0xFFF0D5DB)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Rechazar',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: child,
    );
  }

  Widget _fila(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: const TextStyle(fontSize: 13, color: Color(0xFF94A0B3)),
            ),
          ),
          Text(
            v,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF17243C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fechaCol(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A0B3))),
        const SizedBox(height: 2),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF17243C),
          ),
        ),
      ],
    );
  }
}
