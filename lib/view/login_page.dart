// ignore_for_file: prefer_const_constructors
import 'package:app_frontend/view/home_page.dart';
import 'package:app_frontend/widgets/text_field.dart';
import 'package:app_frontend/widgets/elevated_button.dart';
import 'package:app_frontend/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // LOGIN
          Text('Login',
            style: TextStyle(
                color: Colors.black,
                fontSize: 48, 
                fontWeight: FontWeight.bold,
            ),
          ),

          // EMAIL
          SizedBox(height: 36),
          CustomTextField(titleText: 'Email', hintText: 'Digite seu email'),

          // SENHA
          SizedBox(height: 18),
          CustomTextField(titleText: 'Senha', hintText: 'Digite sua senha'),

          // ENTRAR
          SizedBox(height: 24),
          CustomElevatedButton(
            labelText: 'Entrar', 
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            //onPressed: () {Navigator.pushNamed(context, /HomePage)}
          ),
          
          TextButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => ForgotPassword());
              },
              child: Text('Esqueceu a senha?',
                  style: TextStyle(decoration: TextDecoration.underline))),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Divider(
                  color: Color(0xff000C39),
                  thickness: 0.8,
                )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text('ou'),
                ),
                Expanded(
                    child: Divider(
                  color: Color(0xff000C39),
                  thickness: 0.8,
                ))
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/logo_google.png',
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Continue com o Google',
                  style: TextStyle(
                      color: Color(0xff000C39), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 58, vertical: 20)),
          ),
          SizedBox(
            height: 50,
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: 'By clicking continue, you agree to our  ',
            ),
            TextSpan(
                text: ' Terms & Conditions ',
                style: TextStyle(
                    color: Color(0xff000C39), fontWeight: FontWeight.bold)),
          ])),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: 'and',
            ),
            TextSpan(
                text: ' Privacy Policy',
                style: TextStyle(
                    color: Color(0xff000C39), fontWeight: FontWeight.bold)),
          ])),
          SizedBox(
            height: 20,
          ),
          Icon(
            Icons.fingerprint,
            color: Color(0xff3629B7),
            size: 80,
          )
        ],
      ),
    );
  }
}
