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

  testWidgets('muestra errores junto a los campos que faltan', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PantallaRegistro()));

    await tester.tap(find.text('Crear cuenta'));
    await tester.pump();

    expect(find.text('Ingresa tu nombre y apellido.'), findsOneWidget);
    expect(find.text('Ingresa tu número de cédula.'), findsOneWidget);
    expect(find.text('Ingresa tu correo electrónico.'), findsOneWidget);
    expect(find.text('Ingresa tu número de teléfono.'), findsOneWidget);
    expect(
      find.text('Cumple todos los requisitos indicados para la contraseña.'),
      findsOneWidget,
    );
    expect(
      find.text('Debes aceptar los términos y condiciones.'),
      findsOneWidget,
    );
  });
}
