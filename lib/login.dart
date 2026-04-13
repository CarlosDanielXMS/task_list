import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtSenha = TextEditingController();

  Future login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: txtEmail.text,
        password: txtSenha.text,
      );

      txtEmail.clear();
      txtSenha.clear();

      if (!context.mounted) return;
      context.go('/tasks');
    } on FirebaseAuthException catch (e) {
      String message = "Erro ao logar";

      switch (e.code) {
        case 'invalid-credential':
          message = "E-mail ou senha inválidos";
          break;
        case 'invalid-email':
          message = "E-mail inválido";
          break;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(message),
            )
          );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text("Erro desconhecido: $e"),
            )
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              TextField(
                controller: txtEmail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: txtSenha,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Senha",
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              ElevatedButton(onPressed: () => login(context), child: Text("Entrar")),
              TextButton(onPressed: () => context.go('/register'), child: Text("Registrar")),
            ],
          ),
        ),
      ),
    );
  }
}
