// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:egg_go/utilis/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:egg_go/widgets/text_button.dart';
import 'package:egg_go/widgets/elevated_button.dart';
import 'package:egg_go/views/forgot_password.dart';
import 'package:egg_go/validators/mixin_validations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with MixinValidations {
  final _formKey = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  void _signIn() async {
    if (_isLoading) return;
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text,
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('usuario_logado', true);
        // AuthChecker cuidará da navegação
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Erro de login. Tente novamente.';
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Nenhum usuário encontrado para este e-mail';
            break;
          case 'wrong-password':
            errorMessage = 'Senha incorreta.';
            break;
          case 'invalid-email':
            errorMessage = 'O formato do e-mail é inválido.';
            break;
          case 'too-many-requests':
            errorMessage = 'Muitas tentativas de login. Tente novamente mais tarde.';
            break;
          case 'network-request-failed':
            errorMessage = 'Erro de rede. Verifique sua conexão e tente novamente.';
            break;
          case 'invalid-credential':
            errorMessage = 'E-mail ou senha incorreto(s).';
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ligue para o Felipe! Erro inesperado: $e')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  Text('Login',
                    style: GoogleFonts.inter(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  // E-MAIL \\
                  SizedBox(height: 60),
                  CustomTextField(
                    titleText: 'Email',
                    hintText: 'Digite seu email',
                    controller: _controllerEmail,
                    validator: validateEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  // SENHA \\
                  SizedBox(height: 8),
                  CustomTextField(
                    titleText: 'Senha',
                    hintText: 'Digite sua senha',
                    controller: _controllerPassword,
                    validator: validatePassword,
                    isPassword: _obscureText,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.black54,
                          semanticLabel: 'Mostrar ou ocultar senha',
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),

                  // ENTRAR \\
                  SizedBox(height: 16),
                  CustomElevatedButton(
                    height: 50,
                    foregroundColor: AppColors.primary,
                    child: Text('Entrar',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    isLoading: _isLoading,
                    onPressed: _signIn,
                  ),

                  // ESQUECEU A SENHA? \\
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ForgotPassword());
                    },
                    child: Text('Esqueceu a senha?',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.secondary,
                      ),
                    ),
                  ),

                  // TERMOS E CONDIÇÕES \\
                  SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Ao continuar, você concorda com nossos ',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ),
                        TextSpan(
                          text: 'Termos e Condições',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                        TextSpan(
                          text: ' e com nossa ',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ),
                        TextSpan(
                          text: 'Política de Privacidade.',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),

          // ÍCONE DE CARREGAMENTO \\
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}