import 'package:egg_go/views/login.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 1.0; // Controle da opacidade

  @override
  void initState() {
    super.initState();

    // Aguarda 1 segundo antes de iniciar o desaparecimento
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        _opacity = 0.0; // Reduz a opacidade para 0
      });

      // Aguarda o término da animação antes de navegar
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6B6),
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(microseconds: 50), // Duração do fade
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