import 'package:flutter/material.dart';

import '../models/perfil_model.dart';
import '../nucleo/api_service.dart';
import '../widgets/perfil/contenido_perfil.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  State<PantallaPerfil> createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  final _modelo = const PerfilModel();
  late Future<Map<String, dynamic>> _perfil;

  @override
  void initState() {
    super.initState();
    _perfil = _modelo.cargar();
  }

  void _reintentar() => setState(() => _perfil = _modelo.cargar());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _perfil,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ContenidoPerfil(usuario: snapshot.data!);
        }
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: snapshot.hasError
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        snapshot.error is ApiException
                            ? (snapshot.error as ApiException).mensaje
                            : 'No se pudo cargar el perfil.',
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: _reintentar,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
