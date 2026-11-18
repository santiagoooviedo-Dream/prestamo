import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_prestamo/pantallas/pantalla_eliminar_cuenta.dart';

void main() {
  testWidgets('permite cancelar la confirmación de eliminación', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PantallaEliminarCuenta(),
                ),
              ),
              child: const Text('Abrir perfil'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir perfil'));
    await tester.pumpAndSettle();
    expect(find.text('¿Eliminar tu cuenta?'), findsOneWidget);

    await tester.tap(find.text('No, volver'));
    await tester.pumpAndSettle();

    expect(find.text('Abrir perfil'), findsOneWidget);
  });
}
