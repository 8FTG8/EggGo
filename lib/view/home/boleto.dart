//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:app_frontend/widgets/bottom_bar.dart';

class BoletoPage extends StatefulWidget {
  const BoletoPage({super.key});

  @override 
  _BoletoPageState createState() => _BoletoPageState();
}

class _BoletoPageState extends State<BoletoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F1F5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}