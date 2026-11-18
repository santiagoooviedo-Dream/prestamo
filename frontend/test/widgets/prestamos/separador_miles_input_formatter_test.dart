import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_prestamo/widgets/prestamos/formulario_solicitud_prestamo.dart';

void main() {
  final formatter = SeparadorMilesInputFormatter();

  test('agrupa los dígitos en miles con puntos', () {
    final casos = {
      '100000': '100.000',
      '1000000': '1.000.000',
      '12345678': '12.345.678',
      '950': '950',
    };

    for (final caso in casos.entries) {
      final resultado = formatter.formatEditUpdate(
        const TextEditingValue(),
        TextEditingValue(
          text: caso.key,
          selection: TextSelection.collapsed(offset: caso.key.length),
        ),
      );

      expect(resultado.text, caso.value);
    }
  });

  test('mantiene el cursor junto a los mismos dígitos al formatear', () {
    final resultado = formatter.formatEditUpdate(
      const TextEditingValue(),
      const TextEditingValue(
        text: '1234567',
        selection: TextSelection.collapsed(offset: 4),
      ),
    );

    expect(resultado.text, '1.234.567');
    expect(resultado.selection, const TextSelection.collapsed(offset: 5));
  });
}
