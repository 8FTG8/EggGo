// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Login',
          style: TextStyle(
              color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15,right: 15,top: 50,bottom: 20),
          child: TextFormField(
            decoration: InputDecoration(
                hintText: 'Digite o seu email',
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                // label: Text('Email'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffFDB014)),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: TextFormField(
            decoration: InputDecoration(
                hintText: 'Digite a sua senha',
                suffixIcon: Icon(Icons.remove_red_eye_outlined),
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                // label: Text('Senha'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffFDB014)),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 15),
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Entrar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff000C39),
                foregroundColor: Color(0xffFDB014),
                padding: EdgeInsets.symmetric(horizontal: 130, vertical: 20)),
          ),
        ),
        Text('Esqueceu a senha?',
            style: TextStyle(decoration: TextDecoration.underline)),
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
    );
  }
}
