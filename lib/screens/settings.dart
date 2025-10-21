import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/widgets/header.dart';
import '/core/widgets/button_elevated.dart';
import 'produto.dart';
import 'sincronizacao.dart';
import 'login.dart';

class Settings extends StatefulWidget {
  static const routeName = 'SettingsPage';
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, Login.routeName); // Teste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomHeader(
            pageTitle: 'Configurações', showBackButton: true),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            const SizedBox(height: 24.0),
            CustomElevatedButton(
              height: 50.0,
              mainAxisAlignment: MainAxisAlignment.start,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              icon: Icons.storefront_outlined,
              child: Text(
                'Empresa',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {},
            ),
            SizedBox(height: 0.5),
            CustomElevatedButton(
              height: 50.0,
              mainAxisAlignment: MainAxisAlignment.start,
              borderRadius: BorderRadius.circular(0.0),
              icon: Icons.inventory_outlined,
              child: Text(
                'Produtos',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, Produtos.routeName);
              },
            ),
            SizedBox(height: 0.5),
            CustomElevatedButton(
              height: 50.0,
              mainAxisAlignment: MainAxisAlignment.start,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
              icon: Icons.sync,
              child: Text(
                'Sincronização',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, Sincronizacao.routeName);
              },
            ),
            SizedBox(height: 16),
            CustomElevatedButton(
              height: 50.0,
              foregroundColor: Theme.of(context).colorScheme.primary,
              mainAxisAlignment: MainAxisAlignment.start,
              borderRadius: BorderRadius.circular(12),
              icon: Icons.logout_outlined,
              iconColor: Theme.of(context).colorScheme.primary,
              child: Text(
                'Sair',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: logout,
            ),
          ],
        ));
  }
}
