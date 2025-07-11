//ignore_for_file: prefer_const_constructors
import 'package:egg_go/utilis/app_colors.dart';
import 'package:flutter/material.dart';

class NotaFiscalPage extends StatefulWidget {
  const NotaFiscalPage({super.key});

  @override
  _NotaFiscalPageState createState() => _NotaFiscalPageState();
}

class _NotaFiscalPageState extends State<NotaFiscalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }
}