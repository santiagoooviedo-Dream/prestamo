import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';
import 'pantalla_contrasena_lista.dart';

/// Figma: Recuperación 1 de 2 — crear + confirmar en la misma pantalla
class PantallaNuevaContrasena extends StatefulWidget {
  const PantallaNuevaContrasena({super.key});

  @override
  State<PantallaNuevaContrasena> createState() =>
      _PantallaNuevaContrasenaState();
}

class _PantallaNuevaContrasenaState extends State<PantallaNuevaContrasena> {
  final _claveCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  bool _ocultar = true;
  bool _ocultarConfirmar = true;

  bool get _min8 => _claveCtrl.text.length >= 8;
  bool get _tieneNumero => RegExp(r'[0-9]').hasMatch(_claveCtrl.text);
  bool get _tieneMayuscula => RegExp(r'[A-Z]').hasMatch(_claveCtrl.text);
  bool get _tieneSimbolo =>
      RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;/]').hasMatch(_claveCtrl.text);

  int get _puntos {
    var n = 0;
    if (_min8) n++;
    if (_tieneNumero) n++;
    if (_tieneMayuscula) n++;
    if (_tieneSimbolo) n++;
    return n;
  }

  bool get _coinciden =>
      _claveCtrl.text.isNotEmpty &&
      _claveCtrl.text == _confirmarCtrl.text;

  bool get _valido => _puntos == 4 && _coinciden;

  String get _nivelSeguridad {
    switch (_puntos) {
      case 0:
      case 1:
        return 'Débil';
      case 2:
        return 'Media';
      case 3:
        return 'Buena';
      default:
        return 'Fuerte';
    }
  }

  Color get _colorSeguridad {
    switch (_puntos) {
      case 0:
      case 1:
        return const Color(0xFFEF4444);
      case 2:
        return const Color(0xFFF59E0B);
      case 3:
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF22C55E);
    }
  }

  @override
  void initState() {
    super.initState();
    _claveCtrl.addListener(() => setState(() {}));
    _confirmarCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _claveCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
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
                  'RECUPERACIÓN / 1 DE 2',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Una nueva contraseña',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C),
                        height: 1.18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Crea una contraseña segura para proteger tu cuenta.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF66758D),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Barra de progreso 1 de 2
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.5,
                        minHeight: 4,
                        backgroundColor: Color(0xFFE3E9F2),
                        valueColor:
                            AlwaysStoppedAnimation(Color(0xFF285FE8)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CampoTexto(
                      etiqueta: 'Nueva contraseña',
                      pista: 'Crea una contraseña',
                      controlador: _claveCtrl,
                      ocultarTexto: _ocultar,
                      iconoIzquierdo: const Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                      iconoDerecho: IconButton(
                        onPressed: () =>
                            setState(() => _ocultar = !_ocultar),
                        icon: Icon(
                          _ocultar
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: ColoresApp.textoSuave,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _Requisito(
                      texto: 'Mínimo 8 caracteres',
                      ok: _min8,
                    ),
                    _Requisito(
                      texto: 'Incluye un número',
                      ok: _tieneNumero,
                    ),
                    _Requisito(
                      texto: 'Incluye una mayúscula',
                      ok: _tieneMayuscula,
                    ),
                    _Requisito(
                      texto: 'Incluye un símbolo',
                      ok: _tieneSimbolo,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Seguridad: $_nivelSeguridad',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _colorSeguridad,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _puntos / 4,
                        minHeight: 4,
                        backgroundColor: const Color(0xFFE3E9F2),
                        valueColor: AlwaysStoppedAnimation(_colorSeguridad),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Confirma tu contraseña',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C),
                      ),
                    ),
                    const SizedBox(height: 14),
                    CampoTexto(
                      etiqueta: null,
                      pista: 'Repite la contraseña',
                      controlador: _confirmarCtrl,
                      ocultarTexto: _ocultarConfirmar,
                      iconoIzquierdo: const Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: ColoresApp.textoSuave,
                      ),
                      iconoDerecho: IconButton(
                        onPressed: () => setState(
                            () => _ocultarConfirmar = !_ocultarConfirmar),
                        icon: Icon(
                          _ocultarConfirmar
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: ColoresApp.textoSuave,
                        ),
                      ),
                    ),
                    if (_confirmarCtrl.text.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            _coinciden
                                ? Icons.check_circle
                                : Icons.error_outline,
                            size: 18,
                            color: _coinciden
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFEF4444),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _coinciden
                                ? 'Las contraseñas coinciden'
                                : 'Las contraseñas no coinciden',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _coinciden
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: 'Continuar',
              alPresionar: _valido
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PantallaContrasenaLista(),
                        ),
                      );
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Requisito extends StatelessWidget {
  final String texto;
  final bool ok;

  const _Requisito({required this.texto, required this.ok});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: ok ? const Color(0xFF22C55E) : const Color(0xFF94A0B3),
          ),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(
              fontSize: 13,
              color: ok ? const Color(0xFF17243C) : const Color(0xFF66758D),
            ),
          ),
        ],
      ),
    );
  }
}
