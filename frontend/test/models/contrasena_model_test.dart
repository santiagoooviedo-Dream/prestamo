import 'package:flutter_test/flutter_test.dart';
import 'package:front_prestamo/models/contrasena_model.dart';

void main() {
  group('ContrasenaModel', () {
    test('acepta contraseñas que cumplen todos los requisitos', () {
      expect(ContrasenaModel.esValida('Prestamo9!'), isTrue);
    });

    test('rechaza contraseñas sin cada requisito de seguridad', () {
      expect(ContrasenaModel.esValida('Pr9!'), isFalse);
      expect(ContrasenaModel.esValida('Prestamo!'), isFalse);
      expect(ContrasenaModel.esValida('prestamo9!'), isFalse);
      expect(ContrasenaModel.esValida('Prestamo9'), isFalse);
    });

    test('el puntaje representa los requisitos satisfechos', () {
      expect(ContrasenaModel.puntaje('Prestamo9!'), 4);
      expect(ContrasenaModel.puntaje('prestamo9'), 2);
    });
  });
}
