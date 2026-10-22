import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeccionVerificacionRegistro extends StatelessWidget {
  final String correo;
  final List<TextEditingController> digitos;
  final List<FocusNode> focos;

  const SeccionVerificacionRegistro({
    super.key,
    required this.correo,
    required this.digitos,
    required this.focos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Código enviado a:',
                style: TextStyle(fontSize: 13, color: Color(0xFF66758D)),
              ),
              const SizedBox(height: 4),
              Text(
                correo,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF285FE8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Código de 6 dígitos',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF17243C),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (indice) {
            return SizedBox(
              width: 46,
              height: 52,
              child: TextField(
                controller: digitos[indice],
                focusNode: focos[indice],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF17243C),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  border: _borde(),
                  enabledBorder: _borde(),
                  focusedBorder: _borde(enfocado: true),
                ),
                onChanged: (valor) {
                  if (valor.isNotEmpty && indice < 5) {
                    focos[indice + 1].requestFocus();
                  } else if (valor.isEmpty && indice > 0) {
                    focos[indice - 1].requestFocus();
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, size: 18, color: Color(0xFF285FE8)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '¿No lo ves? Revisa spam o espera unos minutos y vuelve a intentarlo.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5B7AA8),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _borde({bool enfocado = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: enfocado ? const Color(0xFF285FE8) : const Color(0xFFD5DFEF),
        width: enfocado ? 1.5 : 1,
      ),
    );
  }
}
