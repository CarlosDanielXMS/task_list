import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {

  TextEditingController txtNome = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtSenha = TextEditingController();
  
  Future registrar(BuildContext context) async {
    var credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: txtEmail.text,
        password: txtSenha.text
    );

    await credential.user?.updateDisplayName(txtNome.text);

    txtNome.clear();
    txtEmail.clear();
    txtSenha.clear();

    if (!context.mounted) return;
    context.go('/tasks');
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
                controller: txtNome,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nome",
                ),
                maxLength: 200,
              ),
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
              ElevatedButton(onPressed: () {registrar(context);}, child: Text("Salvar")),
              TextButton(onPressed: () {context.go('/login');}, child: Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}
