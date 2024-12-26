// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 20,bottom: 10),
      title: Text(
        'Esqueceu a senha ?',
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: double.infinity,
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                'Informe o email associado à sua conta e te enviaremos um link para redefinir sua senha ',
                style: TextStyle(
                  fontSize: 12
                ),
                ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Digite o seu email',
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  // label: Text('Senha'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xffFDB014)),
                  )),
            ),
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Enviar Email'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff000C39),
                  foregroundColor: Color(0xffFDB014),
                  padding: EdgeInsets.symmetric(horizontal: 90,vertical: 18)
              )
            ),
          ],
        ),
      ),
    );
  }
}
