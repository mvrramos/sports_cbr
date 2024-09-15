import 'package:flutter/material.dart';

class SendPasswordDialog extends StatelessWidget {
  const SendPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Email enviado"),
      content: Text("O link para redefinir sua senha foi enviado ao e-mail cadastrado"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }
}
