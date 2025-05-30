import 'package:app_frontend/view/login/login.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  double _opacity = 1.0; // Controle da opacidade

  @override
  void initState() {
    super.initState();

    // Aguarda 1 segundo antes de iniciar o desaparecimento
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 0.0; // Reduz a opacidade para 0
      });

      // Aguarda o término da animação antes de navegar
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000C39),
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500), // Duração do fade
          opacity: _opacity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
}