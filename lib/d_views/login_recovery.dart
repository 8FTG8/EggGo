// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../a_core/widgets/button_text.dart';
import '../a_core/widgets/button_elevated.dart';
import '../a_core/utils/validators.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with MixinValidations {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendRecoveryEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Link de recuperação enviado para ${_emailController.text.trim()}.')),
      );
      navigator.pop();
    } on FirebaseAuthException catch (e) {
      String message = "Ocorreu um erro. Tente novamente.";
      if (e.code == 'user-not-found') {
        message = 'Nenhum usuário encontrado para este e-mail.';
      }
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Erro inesperado: $e'), 
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Center(
        child: Text('Esqueceu a senha?',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Informe seu email e te enviaremos um link para redefinir sua senha.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              // EMAIL \\
              SizedBox(height: 18),
              CustomTextField(
                controller: _emailController,
                titleText: 'Email',
                hintText: 'Digite seu email',
                validator: (v) => combineValidators([() => isEmpty(v), () => validateEmail(v)]),
                keyboardType: TextInputType.emailAddress,
              ),
              // ENVIAR EMAIL \\
              SizedBox(height: 16),
              CustomElevatedButton(
                onPressed: _sendRecoveryEmail,
                isLoading: _isLoading,
                height: 45,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Text('Enviar',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
