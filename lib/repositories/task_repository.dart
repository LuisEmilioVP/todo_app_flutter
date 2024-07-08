import 'package:todo_app/database/db_helper.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/repositories/interface/i_task_repository.dart';

class TaskRepository implements ITaskRepository {
  final _dbHelper = DbHelper();

  @override
  Future<TaskModel?> getTask(int id) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return TaskModel.fromMap(result.first);
    }

    return null;
  }

  @override
  Future<List<TaskModel>> getTasksByUserId(int userId) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(result.length, (i) {
      return TaskModel.fromMap(result[i]);
    });
  }

  @override
  Future<int> createTask(TaskModel task) async {
    final db = await _dbHelper.database;
    return await db.insert('tasks', task.toMap());
  }

  @override
  Future<int> updateTask(TaskModel task) async {
    final db = await _dbHelper.database;

    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<int> deleteTask(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
