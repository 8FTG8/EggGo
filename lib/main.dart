import 'package:egg_go/services/vendas_model.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase/firebase_options.dart';
import 'firebase/auth_checker.dart';

import 'views/nota_fiscal.dart';
import 'views/novo_cliente.dart';
import 'views/nova_venda.dart';
import 'views/home.dart';

import 'views/login.dart';

import 'views/settings.dart';
import 'views/lista_produtos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => VendasModel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthChecker(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      routes: {
        'LoginPage'       : (context) => LoginPage(),
        'HomePage'        : (context) => HomePage(),
        'SettingsPage'    : (context) => SettingsPage(),
        'NovaVendaPage'   : (context) => NovaVendaPage(),
        'NotaFiscalPage'  : (context) => NotaFiscalPage(),
        'NovoClientePage' : (context) => NovoClientePage(),
        'ProdutosPage'    : (context) => ProdutosPage(),
      },
    );
  }
}