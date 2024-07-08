import 'package:todo_app/database/db_helper.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/repositories/interface/i_user_repository.dart';

class UserRepository implements IUserRepository {
  final DbHelper _dbHelper = DbHelper();

  @override
  Future<int> createUser(UserModel user) async {
    final db = await _dbHelper.database;
    int id = await db.insert('users', user.toMap());

    return id;
  }

  @override
  Future<UserModel?> getUser(String username, String password) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMa(result.first);
    }
    return null;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final db = await _dbHelper.database;
    final result = await db.query('users');
    return List.generate(result.length, (i) {
      return UserModel.fromMa(result[i]);
    });
  }
}
