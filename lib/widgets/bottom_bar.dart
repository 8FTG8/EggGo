import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view/home/home.dart';
import '../view/home/nota_fiscal.dart';
import '../view/home/boleto.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {

  // LÓGICA DE NAVEGAÇÃO ENTRE TELAS \\
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  final List<Widget> _pages = [
    HomePage(),
    NotaFiscalPage(),
    BoletoPage()
  ];

  // ESTILOS REUTILIZÁVEIS \\
  TextStyle _navBarTextStyle(Color color) => GoogleFonts.inter(
    color: color,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // BOTTOM NAVIGATION BAR \\
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, selectedIndex, _) {
          return IndexedStack(
            index: selectedIndex,
            children: _pages,
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, selectedIndex, _) {
          return BottomNavigationBar(
            selectedItemColor: const Color(0xffFDB014),
            unselectedItemColor: const Color(0xff000C39),
            selectedLabelStyle: _navBarTextStyle(const Color(0xffFDB014)),
            unselectedLabelStyle: _navBarTextStyle(const Color(0xff000C39)),
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (index) => _selectedIndex.value = index,
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home, size: 28),
              ),
              BottomNavigationBarItem(
                label: 'Nota Fiscal',
                icon: Icon(Icons.receipt, size: 28),
              ),
              BottomNavigationBarItem(
                label: 'Boleto',
                icon: Icon(Icons.document_scanner, size: 28),
              ),
            ],
          );
        },
      ),
    );
  }
}
