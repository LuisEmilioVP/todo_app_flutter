import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: onPressed,
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
