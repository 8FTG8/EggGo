 // ignore_for_file: prefer_const_constructors

 import 'package:app_frontend/view/home_page.dart';
import 'package:app_frontend/view/login_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => const MyApp())
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/homePage' : (context) => HomePage()
      },
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: LoginPage()
      ),
    );
  }
}

