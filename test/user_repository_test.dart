import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/repositories/user_repository.dart';

void main() {
  group('UserRepository', () {
    test('Obtener usuario mediante credenciales válidas', () async {
      final repository = UserRepository();
      final user = await repository.getUser('user_test', 'pass_test');
      expect(user?.username, 'user_test');
      expect(user?.password, 'pass_test');
    });

    test('Obtener usuario con credenciales no válidas', () async {
      final repository = UserRepository();
      final user = await repository.getUser('ivalid_user', 'invalid_pass');
      expect(user, null);
    });
  });
}
