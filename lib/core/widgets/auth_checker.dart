import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../views/home.dart';
import '../../views/login.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // Enquanto espera pelo estado de autenticação inicial, mostra um indicador de carregamento.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Se o snapshot tiver um erro, mostra uma tela de erro.
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Ocorreu um erro. Tente novamente mais tarde.'),
            ),
          );
        }

        // Se o usuário estiver logado, redireciona para a HomePage.
        if (snapshot.hasData) {
          return const Home();
        }

        // Se o usuário não estiver logado, redireciona para a LoginPage.
        return const Login();
      },
    );
  }
}