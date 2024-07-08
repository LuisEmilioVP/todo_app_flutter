import 'task_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/repositories/task_repository.dart';
import 'package:todo_app/repositories/interface/i_task_repository.dart';
import 'package:todo_app/screens/home_screen.dart';

class TaskListScreen extends StatefulWidget {
  final UserModel user;

  const TaskListScreen({super.key, required this.user}) : super();

  @override
  State<TaskListScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskListScreen> {
  final ITaskRepository _taskRepository = TaskRepository();
  late Future<List<TaskModel>> _tasks;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() {
    setState(() {
      _tasks = _taskRepository.getTasksByUserId(widget.user.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas de Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(user: widget.user),
                ),
              ).then((_) {
                _fetchTasks();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Implementar lógica para cerrar sesión y navegar a la pantalla inicial
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<TaskModel>>(
        future: _tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron tareas.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                TaskModel task = snapshot.data![index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(
                            task: task,
                            user: widget.user,
                          ),
                        ),
                      ).then((_) {
                        _fetchTasks();
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
