// Dart & Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core -> Recursos compartilhados
import 'core/widgets/auth_checker.dart';
import 'core/constants/app_theme.dart';

// Models -> Modelos de dados
import 'models/cliente_model.dart';
import 'models/venda_model.dart';
 
// Controllers -> Controladores da lógica de negócio
import 'notifiers/controller_cliente.dart';
import 'notifiers/controller_produto.dart';
import 'notifiers/controller_venda.dart';
import 'notifiers/theme_controller.dart';
import 'notifiers/sincronizacao_controller.dart';

// Views -> Telas de usuário
import 'screens/sincronizacao.dart';
import 'screens/cliente.dart';
import 'screens/cliente_add.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/produto.dart';
import 'screens/produto_add.dart';
import 'screens/settings.dart';
import 'screens/venda_add.dart';
import 'screens/venda_historico.dart';
import 'screens/venda_comprovante.dart';

// Services -> Integração com serviços externos
import 'services/service_cliente.dart';
import 'services/service_produto.dart';
import 'services/service_venda.dart';
import 'services/local_sql_service.dart';

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