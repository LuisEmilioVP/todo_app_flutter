import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/utils/validator.dart';

void main() {
  group('Username and password validation(login)', () {
    test('Username validation', () {
      expect(Validator.validateusername(null),
          'Por favor ingresa un nombre de usuario');
      expect(Validator.validateusername(''),
          'Por favor ingresa un nombre de usuario');
      expect(Validator.validateusername('user123'), null);
    });

    test('Password validation', () {
      expect(
          Validator.validatepassword(null), 'Por favor ingresa una contraseña');
      expect(
          Validator.validatepassword(''), 'Por favor ingresa una contraseña');
      expect(Validator.validatepassword('password123'), null);
    });
  });
}
