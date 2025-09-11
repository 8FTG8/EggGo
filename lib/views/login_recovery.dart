// ignore_for_file: prefer_const_constructors
import 'package:egg_go/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egg_go/core/widgets/button_text.dart';
import 'package:egg_go/core/widgets/button_elevated.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

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

      content: SizedBox(
        width: double.infinity,
        height: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Informe seu email e te enviaremos um link com um código para redefinir sua senha.',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            // EMAIL \\
            SizedBox(height: 18),
            CustomTextField(
              titleText: 'Email', 
              hintText: 'Digite seu email',
            ),

            // ENVIAR EMAIL \\
            SizedBox(height: 12),
            CustomElevatedButton(
              onPressed: () {},
              height: 40,
              foregroundColor: AppColors.primary,
              child: Text('Enviar email',
                style: GoogleFonts.inter(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
