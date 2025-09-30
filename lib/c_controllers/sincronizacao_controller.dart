import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../b_models/venda_model.dart';
import '../b_models/cliente_model.dart';
import '../b_models/produto_model.dart';

import '../f_services/local_sql_service.dart';
import '../f_services/service_venda.dart';
import '../f_services/service_cliente.dart';
import '../f_services/service_produto.dart';

// Enum para representar o status de cada tarefa de sincronização
enum SyncTaskStatus { pendente, sincronizando, sucesso, falha }

class SincronizacaoController with ChangeNotifier {
  final LocalStorageService _localStorageService;
  final VendaService _vendaService;
  final ClienteService _clienteService;
  final ProdutoService _produtoService;

  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  String _geralStatusMessage = "Pronto para sincronizar.";

  // Mapa para guardar o status de cada tarefa individual
  final Map<String, SyncTaskStatus> _taskStatus = {
    'Envio de Vendas Pendentes': SyncTaskStatus.pendente,
    'Envio de Clientes Pendentes': SyncTaskStatus.pendente,
    'Envio de Produtos Pendentes': SyncTaskStatus.pendente,
  };

  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;
  String get geralStatusMessage => _geralStatusMessage;
  Map<String, SyncTaskStatus> get taskStatus => _taskStatus;

  SincronizacaoController({
    required LocalStorageService localStorageService, 
    required VendaService vendaService, 
    required ClienteService clienteService, 
    required ProdutoService produtoService
  })  : _localStorageService = localStorageService,
        _vendaService = vendaService,
        _clienteService = clienteService,
        _produtoService = produtoService {
          _loadLastSyncTime();
        }

  // Carrega a data da última sincronização salva localmente
  Future<void> _loadLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('lastSyncTime');
    if (timestamp != null) {
      _lastSyncTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      notifyListeners();
    }
  }

  // Salva a data da sincronização atual
  Future<void> _saveLastSyncTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSyncTime', time.millisecondsSinceEpoch);
    _lastSyncTime = time;
  }

  // Inicia o processo de sincronização
  Future<void> startSync() async {
    if (_isSyncing) return;

    // Na web, não há sincronização de dados pendentes. Apenas atualiza o status.
    if (kIsWeb) {
      _isSyncing = true;
      notifyListeners();
      await _saveLastSyncTime(DateTime.now());
      _geralStatusMessage = "Conectado ao servidor";
      _isSyncing = false;
      notifyListeners();
      return;
    }

    _isSyncing = true;
    _geralStatusMessage = "Iniciando sincronização...";
    // Reseta todas as tarefas para 'pendente'
    _taskStatus.updateAll((key, value) => SyncTaskStatus.pendente);
    notifyListeners();

    bool anyTaskFailed = false;

    // Executa cada tarefa de sincronização individualmente para que uma falha não pare as outras.
    try {
      await _runSyncTask('Envio de Vendas Pendentes', _sincronizarVendas);
    } catch (e) {
      anyTaskFailed = true;
      debugPrint("Erro na tarefa de sincronização de vendas: $e");
    }

    try {
      await _runSyncTask('Envio de Clientes Pendentes', _sincronizarClientes);
    } catch (e) {
      anyTaskFailed = true;
      debugPrint("Erro na tarefa de sincronização de clientes: $e");
    }

    try {
      await _runSyncTask('Envio de Produtos Pendentes', _sincronizarProdutos);
    } catch (e) {
      anyTaskFailed = true;
      debugPrint("Erro na tarefa de sincronização de produtos: $e");
    }

    if (anyTaskFailed) {
      _geralStatusMessage = "Sincronização concluída com falhas.";
    } else {
      await _saveLastSyncTime(DateTime.now());
      _geralStatusMessage = "Sincronização concluída com sucesso!";
    }

    _isSyncing = false;
    notifyListeners();
  }

  Future<void> _runSyncTask(String taskName, Future<void> Function() task) async {
    try {
      _taskStatus[taskName] = SyncTaskStatus.sincronizando;
      _geralStatusMessage = "Sincronizando: $taskName...";
      notifyListeners();

      await task();

      _taskStatus[taskName] = SyncTaskStatus.sucesso;
      notifyListeners();
    } catch (e) {
      _taskStatus[taskName] = SyncTaskStatus.falha;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _sincronizarVendas() async {
    final pendingVendasMaps = await _localStorageService.getPendingVendas();
    if (pendingVendasMaps.isEmpty) return;

    bool hasErrors = false;
    for (final map in pendingVendasMaps) {
      try {
        final venda = Venda.fromDbMap(map);
        await _vendaService.sincronizarVenda(venda);
        await _localStorageService.deletePendingVenda(map['id'] as int);
      } catch (e) {
        hasErrors = true;
        debugPrint("Falha ao sincronizar venda ID ${map['id']}: $e");
      }
    }
    if (hasErrors) throw Exception('Uma ou mais vendas falharam ao sincronizar.');
  }

  Future<void> _sincronizarClientes() async {
    final pendingClientesMaps = await _localStorageService.getPendingClientes();
    if (pendingClientesMaps.isEmpty) return;

    bool hasErrors = false;
    for (final map in pendingClientesMaps) {
      try {
        final cliente = Cliente.fromDbMap(map);
        await _clienteService.sincronizarCliente(cliente);
        await _localStorageService.deletePendingCliente(map['id'] as int);
      } catch (e) {
        hasErrors = true;
        debugPrint("Falha ao sincronizar cliente ID ${map['id']}: $e");
      }
    }
    if (hasErrors) throw Exception('Um ou mais clientes falharam ao sincronizar.');
  }

  Future<void> _sincronizarProdutos() async {
    final pendingProdutosMaps = await _localStorageService.getPendingProdutos();
    if (pendingProdutosMaps.isEmpty) return;

    bool hasErrors = false;
    for (final map in pendingProdutosMaps) {
      try {
        final produto = Produto.fromDbMap(map);
        await _produtoService.sincronizarProduto(produto);
        await _localStorageService.deletePendingProduto(map['id'] as int);
      } catch (e) {
        hasErrors = true;
        debugPrint("Falha ao sincronizar produto ID ${map['id']}: $e");
      }
    }
    if (hasErrors) throw Exception('Um ou mais produtos falharam ao sincronizar.');
  }
}