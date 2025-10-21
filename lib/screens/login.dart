// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/core/widgets/button_elevated.dart';
import 'login_recovery.dart';
import '/core/utils/validators.dart';

class Login extends StatefulWidget {
  static const routeName = 'LoginPage';
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with MixinValidations {
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
            errorMessage =
                'Muitas tentativas de login. Tente novamente mais tarde.';
            break;
          case 'network-request-failed':
            errorMessage =
                'Erro de rede. Verifique sua conexão e tente novamente.';
            break;
          case 'invalid-credential':
            errorMessage = 'E-mail ou senha incorreto(s).';
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ligue para o Felipe! Erro inesperado: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(
                    'EggGo',
                    style: GoogleFonts.inter(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  // E-MAIL \\
                  SizedBox(height: 60),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Digite seu email',
                    ),
                    controller: _controllerEmail,
                    validator: validateEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  // SENHA \\
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      hintText: 'Digite sua senha',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(153), // Opacidade de 0.6
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
                    controller: _controllerPassword,
                    validator: validatePassword,
                    obscureText: _obscureText,
                  ),

                  // ENTRAR \\
                  SizedBox(height: 16),
                  CustomElevatedButton(
                    height: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    child: Text(
                      'Entrar',
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
                    child: Text(
                      'Esqueceu a senha?',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),

                  /*/ TERMOS E CONDIÇÕES \\
                  SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Ao continuar, você concorda com nossos ',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
                        ),
                        TextSpan(
                          text: 'Termos e Condições',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.secondary),
                        ),
                        TextSpan(
                          text: ' e com nossa ',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
                        ),
                        TextSpan(
                          text: 'Política de Privacidade.',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),*/
                ],
              ),
            ),
          ),

          // ÍCONE DE CARREGAMENTO \\
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(77),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
