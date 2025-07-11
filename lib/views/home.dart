import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egg_go/utilis/app_colors.dart';
import 'package:egg_go/views/settings.dart';
import 'package:egg_go/views/nova_venda.dart';
import 'package:egg_go/widgets/elevated_button.dart';
import 'package:egg_go/views/card_vendas.dart';
import 'package:egg_go/widgets/bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    // Aqui é configurado a ordem das telas
    SettingsPage(),
    _HomePageContent(),
    NovaVendaPage(),
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
        leadingWidth: 138, // Width (120) + padding esquerdo (18)
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Image.asset('assets/images/logo.png', width: 120),
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
  const _HomePageContent({Key? key});

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
              Navigator.pushNamed(context, 'NovoClientePage');
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
        ],
      ),
    );
  }
}