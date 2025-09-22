// Dart & Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core -> Recursos compartilhados
import 'a_core/widgets/auth_checker.dart';
import 'a_core/constants/app_theme.dart';

// Models -> Modelos de dados
import '/b_models/cliente_model.dart';
import '/b_models/venda_model.dart';
 
// Controllers -> Controladores da lógica de negócio
import 'c_controllers/controller_cliente.dart';
import 'c_controllers/controller_produto.dart';
import 'c_controllers/controller_venda.dart';
import 'c_controllers/theme_controller.dart';
import 'c_controllers/sincronizacao_controller.dart';

// Views -> Telas de usuário
import 'd_views/sincronizacao.dart';
import 'd_views/cliente.dart';
import 'd_views/cliente_add.dart';
import 'd_views/home.dart';
import 'd_views/login.dart';
import 'd_views/produto.dart';
import 'd_views/produto_add.dart';
import 'd_views/settings.dart';
import 'd_views/venda_add.dart';
import 'd_views/venda_historico.dart';
import 'd_views/venda_comprovante.dart';

// Services -> Integração com serviços externos
import 'f_services/service_cliente.dart';
import 'f_services/service_produto.dart';
import 'f_services/service_venda.dart';
import 'f_services/local_sql_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // --- CORE & SINGLETONS --- //
        ChangeNotifierProvider<ThemeController>(create: (_) => ThemeController()),
        Provider<LocalStorageService>(create: (_) => LocalStorageService.instance),

        // --- SERVICES (dependem do LocalStorage) --- //
        Provider<VendaService>(create: (context) => VendaServiceImpl(context.read<LocalStorageService>())),
        Provider<ClienteService>(create: (context) => ClienteServiceImpl(context.read<LocalStorageService>())),
        Provider<ProdutoService>(create: (context) => ProdutoServiceImpl(context.read<LocalStorageService>())),

        // --- SINCRONIZAÇÃO (depende dos Services) --- //
        ChangeNotifierProvider<SincronizacaoController>(
          create: (context) => SincronizacaoController(
            localStorageService: context.read<LocalStorageService>(),
            vendaService: context.read<VendaService>(),
            clienteService: context.read<ClienteService>(),
            produtoService: context.read<ProdutoService>(),
          ),
        ),

        // --- CONTROLLERS (dependem dos Services e do SyncController) --- //
        ChangeNotifierProvider<VendaController>(
          create: (context) => VendaController(
            context.read<VendaService>(),
            context.read<SincronizacaoController>(),
            context.read<LocalStorageService>(),
          ),
        ),
        ChangeNotifierProvider<ClienteController>(
          create: (context) => ClienteController(
            context.read<ClienteService>(),
            context.read<SincronizacaoController>(),
            context.read<LocalStorageService>(),
          ),
        ),
        ChangeNotifierProvider<ProdutoController>(
          create: (context) => ProdutoController(
            context.read<ProdutoService>(),
            context.read<SincronizacaoController>(),
            context.read<LocalStorageService>(),
          ),
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            home: const AuthChecker(),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            routes: {
              Login.routeName:           (context) => const Login(),
              Home.routeName:            (context) => const Home(),
              Settings.routeName:        (context) => const Settings(),
              Sincronizacao.routeName:   (context) => const Sincronizacao(),
              NovaVenda.routeName:       (context) => const NovaVenda(),
              Clientes.routeName:        (context) => const Clientes(),
              Produtos.routeName:        (context) => const Produtos(),
              NovoProduto.routeName:     (context) => const NovoProduto(),
              VendaHistorico.routeName:  (context) => const VendaHistorico(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == NovoCliente.routeName) {
                final cliente = settings.arguments as Cliente?;
                return MaterialPageRoute(
                  builder: (context) => NovoCliente(cliente: cliente),
                );
              }
              if (settings.name == VendaComprovante.routeName) {
                final venda = settings.arguments as Venda;
                return MaterialPageRoute(
                  builder: (context) => VendaComprovante(venda: venda),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}