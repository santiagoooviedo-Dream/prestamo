import 'package:flutter/material.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_admin_perfil.dart';

class PantallaAdminUsuarios extends StatefulWidget {
  const PantallaAdminUsuarios({super.key});

  @override
  State<PantallaAdminUsuarios> createState() => _PantallaAdminUsuariosState();
}

class _PantallaAdminUsuariosState extends State<PantallaAdminUsuarios> {
  final _busqueda = TextEditingController();
  bool _cargando = true;
  String? _error;
  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargar();
    _busqueda.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final lista = await ApiService.obtenerUsuarios();
      // filtrar solo rol usuario si existe
      final filtrados = lista.where((u) {
        final rol = u['rol']?.toString().toLowerCase();
        return rol == null || rol == 'usuario';
      }).toList();
      if (mounted) {
        setState(() {
          _usuarios = filtrados;
          _cargando = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.mensaje;
          _cargando = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No se pudieron cargar los usuarios.';
          _cargando = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filtrados {
    final q = _busqueda.text.trim().toLowerCase();
    if (q.isEmpty) return _usuarios;
    return _usuarios.where((u) {
      final nombre = '${u['nombre'] ?? ''} ${u['apellido'] ?? ''}'.toLowerCase();
      final correo = (u['correo'] ?? '').toString().toLowerCase();
      final cedula = (u['cedula'] ?? '').toString().toLowerCase();
      return nombre.contains(q) || correo.contains(q) || cedula.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final lista = _filtrados;

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
              'Usuarios',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Consulta y gestiona las cuentas registradas.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _busqueda,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, correo o cédula',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A0B3)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE1E8F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE1E8F3)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_error!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color(0xFFDC2626))),
                              TextButton(
                                  onPressed: _cargar,
                                  child: const Text('Reintentar')),
                            ],
                          ),
                        )
                      : lista.isEmpty
                          ? const Center(
                              child: Text('No hay usuarios.',
                                  style: TextStyle(color: Color(0xFF66758D))))
                          : RefreshIndicator(
                              onRefresh: _cargar,
                              child: ListView.separated(
                                itemCount: lista.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (_, i) {
                                  final u = lista[i];
                                  final nombre =
                                      '${u['nombre'] ?? ''} ${u['apellido'] ?? ''}'
                                          .trim();
                                  final correo =
                                      u['correo']?.toString() ?? '';
                                  final iniciales = () {
                                    final n = (u['nombre'] ?? '').toString();
                                    final a = (u['apellido'] ?? '').toString();
                                    return '${n.isNotEmpty ? n[0] : ''}${a.isNotEmpty ? a[0] : ''}'
                                        .toUpperCase();
                                  }();
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            final partes =
                                                nombre.split(' ');
                                            final nom = partes.isNotEmpty
                                                ? partes.first
                                                : nombre;
                                            final ape = partes.length > 1
                                                ? partes.sublist(1).join(' ')
                                                : '';
                                            return PantallaAdminPerfil(
                                              nombre: nom,
                                              apellidos: ape,
                                              correo: correo,
                                              telefono:
                                                  u['telefono']?.toString() ??
                                                      '',
                                              cedula:
                                                  u['cedula']?.toString() ??
                                                      '',
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16),
                                        border: Border.all(
                                            color: const Color(0xFFE1E8F3)),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundColor:
                                                const Color(0xFFE8F0FE),
                                            child: Text(
                                              iniciales.isEmpty
                                                  ? '?'
                                                  : iniciales,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF285FE8),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  nombre.isEmpty
                                                      ? 'Usuario'
                                                      : nombre,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: Color(0xFF17243C),
                                                  ),
                                                ),
                                                Text(
                                                  correo,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFF66758D)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.chevron_right,
                                              color: Color(0xFF94A0B3)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
