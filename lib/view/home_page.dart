// ignore_for_file: prefer_const_constructors

import 'package:app_frontend/components/appbar_drawer.dart';
import 'package:app_frontend/view/boleto_page.dart';
import 'package:app_frontend/view/cupom_fiscal_page.dart';
import 'package:app_frontend/view/home_page_body.dart';
import 'package:app_frontend/view/nota_fiscal_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> currentBody = [
    HomePageBody(),
    NotaFiscalPage(),
    BoletoPage(),
    CupomFiscalPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff000C39),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Color(0xffFDB014),
                ));
          }),
          actions: [
            Image.asset(
              'images/logo.png',
              width: 100,
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        drawer: MyDrawer(),
        body: currentBody[_selectedIndex],

        // ----Essa parte do bottomNavigationBar poderia ficar em outro arquivo para n deixar o codigo tão grande----
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xffFDB014),
          unselectedItemColor: Color(0xff000C39),
          selectedLabelStyle: TextStyle(
            color: Color(0xffFDB014),
          ),
          unselectedLabelStyle: TextStyle(
            color: Color(0xff000C39),
          ),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Nota Fiscal',
              icon: Icon(Icons.receipt),
            ),
            BottomNavigationBarItem(
              label: 'Boleto',
              icon: Icon(Icons.qr_code),
            ),
            BottomNavigationBarItem(
              label: 'Cupom Fiscal',
              icon: Icon(Icons.home),
            ),
          ],
        ));
  }
}
