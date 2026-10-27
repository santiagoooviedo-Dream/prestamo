import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_detalle_solicitud.dart';

/// Modelo demo de solicitud (usuario que pidió el préstamo)
class SolicitudAdmin {
  final String nombre;
  final String apellidos;
  final int monto;
  final String estado;
  final String fecha;
  final bool pendiente;
  final String motivo;
  final int cuotas;

  const SolicitudAdmin({
    required this.nombre,
    required this.apellidos,
    required this.monto,
    required this.estado,
    required this.fecha,
    required this.pendiente,
    required this.motivo,
    required this.cuotas,
  });
}

/// Solo usuarios que hicieron solicitud de préstamo
class PantallaAdminSolicitudes extends StatelessWidget {
  const PantallaAdminSolicitudes({super.key});

  static const _solicitudes = [
    SolicitudAdmin(
      nombre: 'Carlos Ruiz',
      apellidos: 'Ruiz Gómez',
      monto: 1000000,
      estado: 'Pendiente',
      fecha: 'Enviado el 18 mayo 2026',
      pendiente: true,
      motivo: 'Gastos médicos y estabilización familiar',
      cuotas: 6,
    ),
    SolicitudAdmin(
      nombre: 'Ana Pérez',
      apellidos: 'Pérez López',
      monto: 500000,
      estado: 'Pendiente',
      fecha: 'Enviado el 2 junio 2026',
      pendiente: true,
      motivo: 'Arreglos del hogar',
      cuotas: 4,
    ),
    SolicitudAdmin(
      nombre: 'María López',
      apellidos: 'López Díaz',
      monto: 1000000,
      estado: 'Completado',
      fecha: 'Enviado el 18 abril 2026',
      pendiente: false,
      motivo: 'Educación',
      cuotas: 12,
    ),
  ];

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
                BotonVolver(
                  alPresionar: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
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
              'Solicitudes de préstamo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Solo usuarios que enviaron una solicitud.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _solicitudes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _tarjeta(context, _solicitudes[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, SolicitudAdmin s) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PantallaAdminDetalleSolicitud(solicitud: s),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE1E8F3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A17243C),
              blurRadius: 16,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFE8F0FE),
                  child: Text(
                    s.nombre.isNotEmpty ? s.nombre[0] : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF285FE8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF17243C),
                        ),
                      ),
                      Text(
                        s.apellidos,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF66758D),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: s.pendiente
                        ? const Color(0xFFFFF4E5)
                        : const Color(0xFFEAF7F0),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    s.estado,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: s.pendiente
                          ? const Color(0xFFA65B0B)
                          : const Color(0xFF168261),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Préstamo solicitado',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A0B3)),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${_fmt(s.monto)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${s.cuotas} cuotas · ${s.fecha}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF66758D)),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}
