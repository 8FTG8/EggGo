// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:app_frontend/view/widgets/text_field_login.dart';
import 'package:app_frontend/view/widgets/elevated_button.dart';
import 'package:app_frontend/view/login/forgot_password.dart';
import 'package:app_frontend/validators/mixin_validations.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F1F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // LOGIN \\
                SizedBox(height: 120),
                Text('Login',
                  style: GoogleFonts.inter(
                    fontSize: 60, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                    
                // EMAIL \\
                const SizedBox(height: 60),
                CustomTextField(
                  titleText: 'Email', 
                  hintText: 'Digite seu email',
                  controller: _controllerEmail,
                  validator: validateEmail,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                    
                // SENHA \\
                const SizedBox(height: 18),
                CustomTextField(
                  titleText: 'Senha', 
                  hintText: 'Digite sua senha',
                  controller: _controllerPassword,
                  validator: validatePassword,
                  isPassword: _obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),

                // ENTRAR \\
                const SizedBox(height: 24),
                CustomElevatedButton(
                  height: 50,
                  child: Text('Entrar',
                    style: GoogleFonts.inter(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  isLoading: _isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _controllerEmail.text,
                          password: _controllerPassword.text,
                        );
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacementNamed(context, 'HomePage');
                        });
                        } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro de login: ${e.message}')),
                        );
                      }
                      setState(() => _isLoading = false);
                    }
                  },
                ),
                    
                // ESQUECEU A SENHA? \\
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) => ForgotPassword(),
                    );
                  },
                  child: Text('Esqueceu a senha?',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000C39),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff000C39),
                    ),
                  ),
                ),
                
                // TERMS & CONDITIONS AND PRIVACY POLICY \\
                const SizedBox(height: 24),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By clicking continue, you agree to our ',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff000C39), 
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff000C39), 
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
