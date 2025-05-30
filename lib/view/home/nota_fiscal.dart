//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:app_frontend/view/widgets/bottom_bar.dart';

class NotaFiscalPage extends StatefulWidget {
  const NotaFiscalPage({super.key});

  @override
  _NotaFiscalPageState createState() => _NotaFiscalPageState();
}

class _NotaFiscalPageState extends State<NotaFiscalPage> {
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