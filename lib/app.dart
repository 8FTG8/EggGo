// Dart & Flutter
import 'package:egg_go/views/sincronizacao.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
 
// Core -> Recursos compartilhados
import 'core/widgets/auth_checker.dart';

// Services -> Integração com serviços externos
import 'services/cliente_service.dart';
import 'services/produto_service.dart';
import 'services/venda_service.dart';
 
// Controllers -> Controladores da lógica de negócio
import 'controllers/cliente_controller.dart';
import 'controllers/produto_controller.dart';
import 'controllers/venda_controller.dart';

// Views -> Telas de usuário
import 'views/cliente.dart';
import 'views/cliente_add.dart';
import 'views/home.dart';
import 'views/login.dart';
import 'views/produto.dart';
import 'views/produto_add.dart';
import 'views/settings.dart';
import 'views/venda_add.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<VendaService>(create: (_) => VendaServiceImpl()),
        ChangeNotifierProvider<VendaController>(
          create: (context) => VendaController(
            context.read<VendaService>(),
          ),
        ),

        Provider<ClienteService>(create: (_) => ClienteServiceImpl()),
        ChangeNotifierProvider<ClienteController>(
          create: (context) => ClienteController(
            context.read<ClienteService>(),
          ),
        ),
        
        Provider<ProdutoService>(create: (_) => ProdutoServiceImpl()),
        ChangeNotifierProvider<ProdutoController>(
          create: (context) => ProdutoController(
            context.read<ProdutoService>(),
          ),
        ),
      ],
      child: MaterialApp(
        home: const AuthChecker(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
        routes: {
          Login.routeName:         (context) => const Login(),
          Home.routeName:          (context) => const Home(),
          Settings.routeName:      (context) => const Settings(),
          Sincronizacao.routeName: (context) => const Sincronizacao(),
          NovaVenda.routeName:     (context) => const NovaVenda(),
          Clientes.routeName:      (context) => const Clientes(),
          NovoCliente.routeName:   (context) => const NovoCliente(),
          Produtos.routeName:      (context) => const Produtos(),
          NovoProduto.routeName:   (context) => const NovoProduto(),
        },
      ),
    );
  }
}