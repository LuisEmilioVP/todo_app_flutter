import 'package:todo_app/models/user_model.dart';

abstract class IUserRepository {
  Future<int> createUser(UserModel user);
  Future<UserModel?> getUser(String username, String password);
  Future<List<UserModel>> getAllUsers();
}
