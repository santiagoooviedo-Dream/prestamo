import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_solicitudes.dart';

class PantallaAdminDetalleSolicitud extends StatelessWidget {
  final SolicitudAdmin solicitud;

  const PantallaAdminDetalleSolicitud({
    super.key,
    required this.solicitud,
  });

  static String _fmt(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final s = solicitud;
    final interes = (s.monto * 0.10).round();
    final total = s.monto + interes;
    final cuota = total ~/ s.cuotas;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16),
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
                        'ADMIN / DETALLE',
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
                    'Detalle de la solicitud',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Solicitud de ${s.nombre} ${s.apellidos}',
                    style: const TextStyle(
                        fontSize: 15, color: Color(0xFF66758D)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: s.pendiente
                          ? const Color(0xFFFFF4E5)
                          : const Color(0xFFEAF7F0),
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
                  const SizedBox(height: 20),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Monto solicitado',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF94A0B3))),
                        const SizedBox(height: 6),
                        Text(
                          '\$${_fmt(s.monto)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF17243C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Plan: ${s.cuotas} cuotas mensuales',
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF66758D)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detalle enviado',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF17243C),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _fila('Usuario', '${s.nombre} ${s.apellidos}'),
                        _fila('Tipo', 'Préstamo personal'),
                        const SizedBox(height: 4),
                        const Text('Motivo',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF94A0B3))),
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
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resumen estimado',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF17243C),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Simulación con interés simple del 10 %.',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF66758D)),
                        ),
                        const SizedBox(height: 14),
                        _fila('Monto', '\$${_fmt(s.monto)}'),
                        _fila('Interés (10 %)', '\$${_fmt(interes)}'),
                        _fila('Total a pagar', '\$${_fmt(total)}'),
                        _fila('Cuota mensual', '\$${_fmt(cuota)}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          if (s.pendiente)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottom),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFD),
                border: Border(top: BorderSide(color: Color(0xFFE1E8F3))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Decisión del administrador',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF17243C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Aprobar o rechazar la solicitud de ${s.nombre}.',
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF66758D)),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 54,
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
                              backgroundColor: const Color(0xFF22C55E),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Aprobar',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 54,
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
                              side: const BorderSide(
                                  color: Color(0xFFF0D5DB)),
                              backgroundColor: const Color(0xFFFFF0F2),
                              foregroundColor: const Color(0xFFBC4351),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Rechazar',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
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
            child: Text(k,
                style:
                    const TextStyle(fontSize: 13, color: Color(0xFF94A0B3))),
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
}
