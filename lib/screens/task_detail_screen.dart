import 'package:flutter/material.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/repositories/task_repository.dart';
import 'package:todo_app/repositories/interface/i_task_repository.dart';
import 'package:todo_app/utils/validator.dart';
import 'package:todo_app/screens/home_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel? task;
  final UserModel user;

  const TaskDetailScreen({super.key, this.task, required this.user}) : super();

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ITaskRepository _taskRepository = TaskRepository();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.task == null ? 'Nueva Tarea' : 'Editar Tarea'),
          actions: [
            if (widget.task != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await _taskRepository.deleteTask(widget.task!.id!);
                  Navigator.pop(context);
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration:
                      const InputDecoration(labelText: 'Título de la tarea'),
                  validator: Validator.validateTitle,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Descripción de la tarea'),
                  validator: Validator.validateDescription,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      TaskModel task = TaskModel(
                        id: widget.task?.id,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        userId: widget.user.id!,
                      );
                      if (widget.task == null) {
                        await _taskRepository.createTask(task);
                      } else {
                        await _taskRepository.updateTask(task);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.task == null ? 'Crear' : 'Actualizar'),
                )
              ],
            ),
          ),
        ));
  }
}
