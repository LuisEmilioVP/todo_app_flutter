import 'package:todo_app/models/task_model.dart';

abstract class ITaskRepository {
  Future<TaskModel?> getTask(int id);
  Future<List<TaskModel>> getTasksByUserId(int userId);
  Future<int> createTask(TaskModel task);
  Future<int> updateTask(TaskModel task);
  Future<int> deleteTask(int id);
}
