import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_perfil.dart';

/// Figma: Usuarios / listado admin
class PantallaAdminUsuarios extends StatefulWidget {
  const PantallaAdminUsuarios({super.key});

  @override
  State<PantallaAdminUsuarios> createState() => _PantallaAdminUsuariosState();
}

class _PantallaAdminUsuariosState extends State<PantallaAdminUsuarios> {
  final _busqueda = TextEditingController();

  final _usuarios = const [
    ('Ana Pérez', 'ana@correo.com', 'Activo'),
    ('Carlos Ruiz', 'carlos@correo.com', 'Activo'),
    ('María López', 'maria@correo.com', 'Inactivo'),
    ('Juan Gómez', 'juan@correo.com', 'Activo'),
  ];

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final q = _busqueda.text.toLowerCase();
    final filtrados = _usuarios
        .where((u) =>
            q.isEmpty ||
            u.$1.toLowerCase().contains(q) ||
            u.$2.toLowerCase().contains(q))
        .toList();

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
              'Usuarios',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Busca y gestiona las cuentas registradas.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 16),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE1E8F3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF94A0B3), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _busqueda,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Buscar por nombre o correo',
                        hintStyle:
                            TextStyle(fontSize: 14, color: Color(0xFF94A0B3)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: filtrados.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final u = filtrados[i];
                  final activo = u.$3 == 'Activo';
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            final partes = u.$1.split(' ');
                            final nom = partes.isNotEmpty ? partes.first : u.$1;
                            final ape = partes.length > 1
                                ? partes.sublist(1).join(' ')
                                : 'Usuario';
                            return PantallaAdminPerfil(
                              nombre: nom,
                              apellidos: ape,
                              correo: u.$2,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE1E8F3)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFFE8F0FE),
                          child: Text(
                            u.$1.isNotEmpty ? u.$1[0] : '?',
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
                                u.$1,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF17243C),
                                ),
                              ),
                              Text(
                                u.$2,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF66758D),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: activo
                                ? const Color(0xFFEAF7F0)
                                : const Color(0xFFF0F3F8),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            u.$3,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: activo
                                  ? const Color(0xFF168261)
                                  : const Color(0xFF66758D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
