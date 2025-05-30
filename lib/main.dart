// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

import 'view/home/add_venda.dart';
import 'view/login/start.dart';
import 'view/login/login.dart';
import 'view/home/home.dart';
import 'view/home/nota_fiscal.dart';
import 'view/home/boleto.dart';
import 'view/home/add_cliente.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      initialRoute: 'StartPage',
      routes: {
        'StartPage'       : (context) => StartPage(),
        'LoginPage'       : (context) => LoginPage(),
        'HomePage'        : (context) => HomePage(),
        'NovaVendaPage'   : (context) => NovaVendaPage(),
        'NotaFiscalPage'  : (context) => NotaFiscalPage(),
        'BoletoPage'      : (context) => BoletoPage(),
        'NovoClientePage' : (context) => NovoClientePage(),
      },
    );
  }
}

