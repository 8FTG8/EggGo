import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egg_go/core/constants/app_colors.dart';
import 'package:egg_go/views/cliente.dart';
import 'package:egg_go/views/settings.dart';
import 'package:egg_go/views/venda_add.dart';
import 'package:egg_go/core/widgets/button_elevated.dart';
import 'package:egg_go/views/card_vendas.dart';
import 'package:egg_go/core/widgets/bottom_bar.dart';

class Home extends StatefulWidget {
  static const routeName = 'HomePage';
  const Home({super.key});
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  static final List<Widget> _widgetOptions = <Widget>[
    Settings(),
    _HomePageContent(),
    NovaVenda(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // HEADER \\
      appBar: _selectedIndex == 1 ? AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 138,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Image.asset('lib/core/images/logo.png', width: 120),
        ),
      ) : null,

      // BODY \\
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex, 
        children: _widgetOptions
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex, 
        onTap: _onItemTapped
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [

          // RESUMO DE VENDAS \\
          SizedBox(height: 18),
          CardVendas(),

          // CLIENTES \\
          SizedBox(height: 12),
          CustomElevatedButton(
            height: 50,
            borderRadius: BorderRadius.circular(10),
            mainAxisAlignment: MainAxisAlignment.start,
            icon: Icons.groups_sharp,
            child: Text('Clientes',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ), 
            onPressed: () {
              Navigator.pushNamed(context, Clientes.routeName);
            },
          ),

          // HISTÓRICO DE VENDAS \\
          SizedBox(height: 12),
          CustomElevatedButton(
            height: 50,
            borderRadius: BorderRadius.circular(10),
            mainAxisAlignment: MainAxisAlignment.start,
            icon: Icons.history,
            child: Text('Histórico de Vendas',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ), 
            onPressed: () {
              print('Botão Histórico de Venda pressionado');
            },
          ),

          // RELATÓRIOS \\
          SizedBox(height: 12),
          CustomElevatedButton(
            height: 50,
            borderRadius: BorderRadius.circular(10),
            mainAxisAlignment: MainAxisAlignment.start,
            icon: Icons.analytics_rounded,
            child: Text('Relatórios',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ), 
            onPressed: () {
              print('Botão Relatórios pressionado');
            },
          ),
        ],
      ),
    );
  }
}