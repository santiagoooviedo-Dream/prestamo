import 'package:flutter/material.dart';

import '../models/prestamo_model.dart';
import '../widgets/comunes/barra_navegacion.dart';
import '../widgets/prestamos/lista_mis_prestamos.dart';

class PantallaMisPrestamos extends StatefulWidget {
  const PantallaMisPrestamos({super.key});

  @override
  State<PantallaMisPrestamos> createState() => _PantallaMisPrestamosState();
}

class _PantallaMisPrestamosState extends State<PantallaMisPrestamos> {
  final _modelo = const PrestamoModel();
  late Future<PrestamosUsuario> _datos;

  @override
  void initState() {
    super.initState();
    _datos = _modelo.obtenerMisPrestamos();
  }

  void _recargar() => setState(() => _datos = _modelo.obtenerMisPrestamos());

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<PrestamosUsuario>(
              future: _datos,
              builder: (context, snapshot) => ListaMisPrestamos(
                top: top,
                datos: snapshot.data,
                cargando: snapshot.connectionState == ConnectionState.waiting,
                error: snapshot.error,
                alReintentar: _recargar,
              ),
            ),
          ),
          const BarraNavegacion(actual: DestinoNav.prestamos),
        ],
      ),
    );
  }
}
