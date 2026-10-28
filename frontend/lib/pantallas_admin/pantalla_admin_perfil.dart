import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_historial.dart';
import 'pantalla_admin_solicitudes.dart';
import 'pantalla_admin_conversaciones.dart';

/// Figma: Perfil de usuario (admin)
class PantallaAdminPerfil extends StatelessWidget {
  final String nombre;
  final String apellidos;
  final String correo;
  final String telefono;
  final String cedula;
  final String fechaRegistro;
  final int prestamosActivos;
  final int solicitudesRealizadas;

  const PantallaAdminPerfil({
    super.key,
    this.nombre = 'Nombre usuario',
    this.apellidos = 'Apellidos Usuario',
    this.correo = 'algo@gmail.com',
    this.telefono = '300 123 4567',
    this.cedula = '1.234.567.890',
    this.fechaRegistro = '15 mayo 2026',
    this.prestamosActivos = 2,
    this.solicitudesRealizadas = 5,
  });

  String get _iniciales {
    final a = nombre.isNotEmpty ? nombre[0] : '';
    final b = apellidos.isNotEmpty ? apellidos[0] : '';
    return ('$a$b').toUpperCase();
  }

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
                  'PERFIL DE USUARIO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar + nombre centrado
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F0FE),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _iniciales,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF285FE8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      nombre,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17243C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      apellidos,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF66758D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Registro: $fechaRegistro',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A0B3),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Datos
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE1E8F3)),
                      ),
                      child: Column(
                        children: [
                          _dato('Correo', correo, azul: true),
                          _dato('Teléfono', telefono),
                          _dato('Cédula', cedula),
                          _dato('Préstamos', '$prestamosActivos activos'),
                          _dato(
                            'Solicitudes',
                            '$solicitudesRealizadas realizadas',
                            ultimo: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Acciones rápidas
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Acciones rápidas',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17243C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _accion(
                      context,
                      Icons.bar_chart_rounded,
                      'Historial de préstamos',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PantallaAdminHistorial(
                              nombre: nombre,
                              apellidos: apellidos,
                            ),
                          ),
                        );
                      },
                    ),
                    _accion(
                      context,
                      Icons.mail_outline_rounded,
                      'Solicitudes de préstamo',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PantallaAdminSolicitudes(),
                          ),
                        );
                      },
                    ),
                    _accion(
                      context,
                      Icons.notifications_none_rounded,
                      'Soporte',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PantallaAdminConversaciones(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dato(String k, String v, {bool azul = false, bool ultimo = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: ultimo
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF0F3F8))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: const TextStyle(fontSize: 14, color: Color(0xFF66758D)),
            ),
          ),
          Text(
            v,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: azul ? const Color(0xFF285FE8) : const Color(0xFF17243C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accion(
    BuildContext context,
    IconData icono,
    String titulo,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1E8F3)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icono, color: const Color(0xFF285FE8), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF17243C),
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF94A0B3)),
            ],
          ),
        ),
      ),
    );
  }
}
