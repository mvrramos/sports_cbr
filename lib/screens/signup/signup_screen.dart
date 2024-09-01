import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/helpers/validators.dart';
import 'package:sportscbr/models/data_user.dart';
import 'package:sportscbr/models/user_manager.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DataUser user = DataUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Criar conta",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
              key: formKey,
              child: Consumer<UserManager>(
                builder: (_, userManager, __) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(hintText: "Nome completo"),
                        enabled: !userManager.loading,
                        validator: (name) {
                          if (name!.isEmpty) {
                            return "Campo obrigatório";
                          } else if (name.trim().split(' ').length <= 1) {
                            return "Preencha seu nome completo";
                          }
                          return null;
                        },
                        onSaved: (name) => user.name = name,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        enabled: !userManager.loading,
                        decoration: const InputDecoration(hintText: "E-mail"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) {
                          if (email!.isEmpty) {
                            return "Campo obrigatório";
                          } else if (!emailValid(email)) {
                            return "Email inválido";
                          }
                          return null;
                        },
                        onSaved: (email) => user.email = email,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        enabled: !userManager.loading,
                        decoration: const InputDecoration(hintText: "Senha"),
                        obscureText: true,
                        validator: (password) {
                          if (password!.isEmpty) {
                            return "Campo obrigatório";
                          } else if (password.length < 6) {
                            return "Senha deve conter 6 ou mais caracteres";
                          }
                          return null;
                        },
                        onSaved: (password) => user.password = password,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        enabled: !userManager.loading,
                        decoration: const InputDecoration(hintText: "Repita sua senha"),
                        obscureText: true,
                        validator: (password) {
                          if (password!.isEmpty) {
                            return "Campo obrigatório";
                          } else if (password.length < 6) {
                            return "Senha deve conter 6 ou mais caracteres";
                          }
                          return null;
                        },
                        onSaved: (password) => user.confirmPassword = password,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: userManager.isLoggedIn
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();

                                    if (user.password != user.confirmPassword) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "As senhas precisam ser iguais",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    userManager.signUp(
                                      dataUser: user,
                                      onSuccess: () {},
                                      onFail: (error) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Falha ao cadastrar: $error',
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 73, 5, 182),
                            disabledBackgroundColor: Colors.black54,
                          ),
                          child: userManager.loading
                              ? const CircularProgressIndicator(
                                  color: Color.fromARGB(100, 73, 5, 182),
                                )
                              : const Text(
                                  "Cadastrar",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                        ),
                      )
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
