import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../nucleo/colores_app.dart';

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
              color: ColoresApp.blanco,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: enfocado || lleno
                    ? ColoresApp.primario
                    : ColoresApp.bordeSuave,
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
              style: const TextStyle(fontSize: 24, color: ColoresApp.primario),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: '–',
                hintStyle: TextStyle(fontSize: 24, color: ColoresApp.textoSuave),
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
