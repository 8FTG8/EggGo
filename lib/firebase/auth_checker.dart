import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/home.dart';
import '../views/login.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  Future<bool> _checkLoginStatus() async {
    FirebaseAuth.instance.setLanguageCode('pt');
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    final isLogged = prefs.getBool('usuario_logado') ?? false;
    return user != null && isLogged;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder:(context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final isLoggedIn = snapshot.data!;
        return isLoggedIn ? HomePage() : LoginPage();
      },
    );
  }
}