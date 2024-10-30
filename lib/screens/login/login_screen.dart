import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/validators.dart';
import '../../models/data_user.dart';
import '../../models/user/user_manager.dart';
import 'common/reset_password_dialog.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Entrar"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            child: const Text(
              "Criar conta",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email) {
                        if (!emailValid(email!)) return "Email inválido";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: "Senha"),
                      autocorrect: false,
                      obscureText: true,
                      validator: (password) {
                        if (password != null && (password.isEmpty || password.length < 6)) return "Senha inválida";
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);

                          showDialog(
                            context: context,
                            builder: (_) => SendPasswordDialog(),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text("Esqueci minha senha"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  userManager.signIn(
                                      DataUser(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      ), onFail: (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          error,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }, onSuccess: () {
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 73, 5, 182),
                          disabledBackgroundColor: Colors.black54,
                        ),
                        child: userManager.loading
                            ? const CircularProgressIndicator(color: Color.fromARGB(255, 73, 5, 182))
                            : const Text(
                                "Entrar",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // SignInButton(
                    //   Buttons.Google,
                    //   text: "Entrar com o Google",
                    //   onPressed: () {
                    //     userManager.googleLogin();
                    //   },
                    // ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
