import 'package:flutter/material.dart';

import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';
import 'pantalla_contrasena_lista.dart';

class PantallaConfirmarContrasena extends StatefulWidget {
  final String? contrasenaAnterior;

  const PantallaConfirmarContrasena({super.key, this.contrasenaAnterior});

  @override
  State<PantallaConfirmarContrasena> createState() =>
      _PantallaConfirmarContrasenaState();
}

class _PantallaConfirmarContrasenaState
    extends State<PantallaConfirmarContrasena> {
  final _ctrl = TextEditingController();
  bool _ocultar = true;

  String? get _anterior {
    // Argumentos de ruta o parámetro del constructor
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) return args;
    return widget.contrasenaAnterior;
  }

  bool get _tieneTexto => _ctrl.text.isNotEmpty;

  bool get _coinciden {
    final ant = _anterior;
    if (ant == null || ant.isEmpty) {
      // Sin referencia: basta con que haya escrito algo
      return _tieneTexto;
    }
    return _ctrl.text == ant;
  }

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _continuar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PantallaContrasenaLista()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 20 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'RECUPERACIÓN / 2 DE 3',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Confirma tu contraseña',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: ColoresApp.textoPrincipal,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vuelve a ingresar tu nueva contraseña para confirmar.',
              style: TextStyle(
                fontSize: 15,
                color: ColoresApp.textoSecundario,
                height: 1.4,
              ),
            ),

            // Progreso 2/3 — línea continua
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: const LinearProgressIndicator(
                value: 2 / 3,
                minHeight: 4,
                backgroundColor: ColoresApp.chipAzul,
                valueColor: AlwaysStoppedAnimation(ColoresApp.primario),
              ),
            ),

            const SizedBox(height: 28),

            CampoTexto(
              etiqueta: 'Confirmar contraseña',
              pista: '••••••••',
              controlador: _ctrl,
              ocultarTexto: _ocultar,
              iconoIzquierdo: const Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: ColoresApp.textoSuave,
              ),
              iconoDerecho: IconButton(
                onPressed: () => setState(() => _ocultar = !_ocultar),
                icon: Icon(
                  _ocultar
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: ColoresApp.textoSuave,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_tieneTexto)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: _coinciden
                      ? ColoresApp.exitoClaro
                      : ColoresApp.errorFondo3,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _coinciden
                        ? ColoresApp.exitoBorde2
                        : ColoresApp.errorFondo4,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _coinciden ? Icons.check_circle : Icons.error_outline,
                      size: 20,
                      color: _coinciden
                          ? ColoresApp.exito
                          : ColoresApp.error,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _coinciden
                          ? 'Las contraseñas coinciden.'
                          : 'Las contraseñas no coinciden.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _coinciden
                            ? ColoresApp.exitoOscuro
                            : ColoresApp.errorOscuro,
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            BotonPrimario(
              texto: 'Continuar',
              alPresionar: _coinciden ? _continuar : null,
            ),
          ],
        ),
      ),
    );
  }
}