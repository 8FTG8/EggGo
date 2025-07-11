import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:egg_go/widgets/header.dart';
import 'package:egg_go/utilis/app_colors.dart';
import 'package:egg_go/widgets/elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_logado');

    if (mounted) {
      Navigator.pushReplacementNamed(context, 'LoginPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(pageTitle: 'Configurações', showBackButton: false),
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
            child: Text('Dados da empresa',
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
            child: Text('Produtos',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ), 
            onPressed: () {
              Navigator.pushNamed(context, 'ProdutosPage');
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
            child: Text('Sincronização',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ), 
            onPressed: () {},
          ),

          SizedBox(height: 16),
          CustomElevatedButton(
            height: 50.0,
            foregroundColor: AppColors.primary,
            mainAxisAlignment: MainAxisAlignment.start,
            borderRadius: BorderRadius.circular(12),
            icon: Icons.logout_outlined,
            iconColor: AppColors.primary,
            child: Text('Sair',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ), 
            onPressed: logout,
          ),
        ],
      )
    );
  } 
}