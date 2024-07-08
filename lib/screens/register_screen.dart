import 'task_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/utils/validator.dart';
import 'package:todo_app/utils/alert_dialog.dart';
import 'package:todo_app/repositories/user_repository.dart';
import 'package:todo_app/repositories/interface/i_user_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key}) : super();
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final IUserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre de usuario'),
                validator: Validator.validateusername,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: Validator.validatepassword,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Check if username already exists
                    List<UserModel> users = await _userRepository.getAllUsers();
                    bool usernameExists = users.any(
                        (user) => user.username == _usernameController.text);

                    if (usernameExists) {
                      showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                          title: 'Error',
                          content: 'El nombre de usuario ya está registrado.',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    } else {
                      // Register user if username is not taken
                      UserModel user = UserModel(
                        username: _usernameController.text,
                        password: _passwordController.text,
                      );
                      int userId = await _userRepository.createUser(user);
                      user = UserModel(
                        id: userId,
                        username: user.username,
                        password: user.password,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskListScreen(user: user),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
