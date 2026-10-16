import 'package:flutter/material.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/comunes/campo_texto.dart';

class PantallaNuevaContrasena extends StatefulWidget {
  const PantallaNuevaContrasena({super.key});

  @override
  State<PantallaNuevaContrasena> createState() =>
      _PantallaNuevaContrasenaState();
}

class _PantallaNuevaContrasenaState extends State<PantallaNuevaContrasena> {
  final _claveCtrl = TextEditingController();
  bool _ocultar = true;

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
  }

  @override
  void dispose() {
    _claveCtrl.dispose();
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
            // Cabecera
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'RECUPERACIÓN / 1 DE 3',
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
              'Una nueva contraseña',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Crea una contraseña segura para proteger tu cuenta.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.4,
              ),
            ),

            // Barra de progreso paso 1/3
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: const LinearProgressIndicator(
                value: 1 / 3,
                minHeight: 4,
                backgroundColor: Color(0xFFD6E4FF),
                valueColor: AlwaysStoppedAnimation(Color(0xFF285FE8)),
              ),
            ),

            const SizedBox(height: 28),

            // Campo nueva contraseña
            CampoTexto(
              etiqueta: 'Nueva contraseña',
              pista: '••••••••',
              controlador: _claveCtrl,
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

            const SizedBox(height: 20),

            // Requisitos
            _Requisito(cumplido: _min8, texto: 'Mínimo 8 caracteres'),
            const SizedBox(height: 10),
            _Requisito(cumplido: _tieneNumero, texto: 'Incluye un número'),
            const SizedBox(height: 10),
            _Requisito(cumplido: _tieneMayuscula, texto: 'Incluye una mayúscula'),
            const SizedBox(height: 10),
            _Requisito(cumplido: _tieneSimbolo, texto: 'Incluye un símbolo'),

            const SizedBox(height: 20),

            // Seguridad
            Text(
              'Seguridad: $_nivelSeguridad',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _colorSeguridad,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _puntos / 4,
                minHeight: 6,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation(_colorSeguridad),
              ),
            ),

            const Spacer(),

            BotonPrimario(
              texto: 'Continuar',
              alPresionar: () {
                Navigator.pushNamed(
                  context,
                  '/confirmar-contrasena',
                  arguments: _claveCtrl.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Requisito extends StatelessWidget {
  final bool cumplido;
  final String texto;

  const _Requisito({required this.cumplido, required this.texto});

  @override
  Widget build(BuildContext context) {
    final color =
        cumplido ? const Color(0xFF22C55E) : const Color(0xFF94A0B3);
    return Row(
      children: [
        Icon(
          cumplido ? Icons.check_circle : Icons.circle_outlined,
          size: 20,
          color: color,
        ),
        const SizedBox(width: 10),
        Text(
          texto,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: cumplido ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
