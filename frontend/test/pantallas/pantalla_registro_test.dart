import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_prestamo/pantallas/pantalla_registro.dart';

void main() {
  testWidgets('muestra los términos al tocar el enlace', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PantallaRegistro()));

    await tester.tap(find.text('términos y condiciones'));
    await tester.pumpAndSettle();

    expect(find.text('Términos y condiciones'), findsOneWidget);
    expect(find.textContaining('Ley 1581 de 2012'), findsOneWidget);
  });

  testWidgets('no permite crear la cuenta sin aceptar los términos', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PantallaRegistro()));

    await tester.tap(find.text('Crear cuenta'));
    await tester.pump();

    expect(
      find.text('Debes aceptar los términos y condiciones.'),
      findsOneWidget,
    );
  });
}
