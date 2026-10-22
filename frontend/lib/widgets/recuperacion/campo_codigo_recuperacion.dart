import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoCodigoRecuperacion extends StatelessWidget {
  final List<TextEditingController> controladores;
  final List<FocusNode> focos;
  final void Function(int indice, String valor) alCambiar;

  const CampoCodigoRecuperacion({
    super.key,
    required this.controladores,
    required this.focos,
    required this.alCambiar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(6, (indice) {
        final lleno = controladores[indice].text.isNotEmpty;
        final enfocado = focos[indice].hasFocus;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: indice < 5 ? 8 : 0),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: enfocado || lleno
                    ? const Color(0xFF285FE8)
                    : const Color(0xFFE3E9F2),
                width: enfocado ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: controladores[indice],
              focusNode: focos[indice],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: const TextStyle(fontSize: 24, color: Color(0xFF285FE8)),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: '–',
                hintStyle: TextStyle(fontSize: 24, color: Color(0xFF94A0B3)),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (valor) => alCambiar(indice, valor),
            ),
          ),
        );
      }),
    );
  }
}
