// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_frontend/view/widgets/left_bar.dart';
import 'package:app_frontend/view/widgets/elevated_button.dart';
import 'package:app_frontend/view/widgets/card_vendas.dart';
import 'package:app_frontend/view/widgets/bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F1F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF000C39),
        leading: Builder(
            builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Color(0xFFFDB014),
              ),
            );
          },
        ),
        actions: [
          Image.asset('images/logo.png', 
          width: 120,
          ),
          SizedBox(width: 20),
        ],
      ),

      // DRAWER E BODY \\
      //drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [

            // RESUMO DE VENDAS \\
            SizedBox(height: 24),
            VendasResumoCard(),

            // NOVA VENDA \\
            SizedBox(height: 24),
            CustomElevatedButton(
              height: 50,
              backgroundColor: Colors.white,
              foregroundColor: Color(0xff000C39),
              border: BorderSide(color: Color(0xff000C39), width: 2.0),
              borderRadius: BorderRadius.circular(10),
              shadowColor: Colors.grey,
              elevation: 4.0,
              icon: Icons.add_circle,
              iconSize: 24,
              child: Text('Venda',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                )
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'NovaVendaPage');
              },
            ),

            // HISTÓRICO DE VENDAS \\
            SizedBox(height: 12),
            CustomElevatedButton(
              height: 50,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              borderRadius: BorderRadius.circular(10),
              shadowColor: Colors.grey,
              elevation: 4.0,
              padding: EdgeInsets.symmetric(horizontal: 12),
              mainAxisAlignment: MainAxisAlignment.start,
              icon: Icons.history,
              iconSize: 24,
              child: Text('Histórico de Vendas',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ), 
              onPressed: () {
                print('Botão pressionado');
              },
            ),

            // CLIENTES \\
            SizedBox(height: 12),
            CustomElevatedButton(
              height: 50,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              borderRadius: BorderRadius.circular(10),
              shadowColor: Colors.grey,
              elevation: 4.0,
              padding: EdgeInsets.symmetric(horizontal: 12),
              mainAxisAlignment: MainAxisAlignment.start,
              icon: Icons.groups_sharp,
              iconSize: 26,
              child: Text('Clientes',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ), 
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'NovoClientePage');
              },
            ),
          ],
        )
      ),
      //bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}