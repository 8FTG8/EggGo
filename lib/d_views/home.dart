
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../a_core/widgets/bottom_bar.dart';
import '../a_core/widgets/button_elevated.dart';
import '../c_controllers/sincronizacao_controller.dart';
import '../c_controllers/theme_controller.dart';
import '../d_views/settings.dart';
import '../d_views/cliente.dart';
import '../d_views/venda_add.dart';
import '../d_views/venda_resumo_card.dart';
import '../d_views/venda_historico.dart';

class Home extends StatefulWidget {
  static const routeName = 'HomePage';
  const Home({super.key});
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[_HomePageContent(), NovaVenda()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override // Inicia a primeira sincronização automática ao entrar na home.
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SincronizacaoController>(context, listen: false).startSync();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override // Sincroniza novamente sempre que o app volta para o primeiro plano.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Provider.of<SincronizacaoController>(context, listen: false).startSync();
    }
  }

  // HEADER \\
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 
        ? AppBar(
            leadingWidth: 136,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Image.asset('lib/a_core/images/logo.png', width: 120)),
            actions: [
              Consumer<ThemeController>(
                builder: (context, themeController, child) {
                  final isDark = themeController.isDarkMode;
                  return IconButton(
                    iconSize: 27.0,
                    icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                    tooltip: isDark ? 'Ativar tema claro' : 'Ativar tema escuro',
                    onPressed: () {
                      themeController.toggleTheme();
                    },
                  );
                },
              ),
              IconButton(
                iconSize: 27.0,
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Configurações',
                onPressed: () {
                  Navigator.pushNamed(context, Settings.routeName);
                },
              ),
              const SizedBox(width: 16), // Espaçamento à direita
            ],
          )
        : null,

      // BODY \\
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
              Navigator.pushNamed(context, VendaHistorico.routeName);
            },
          ),
        ],
      ),
    );
  }
}