import 'package:flutter/foundation.dart';
import '../b_models/cliente_model.dart';
import '../f_services/service_cliente.dart';
import '../f_services/local_sql_service.dart';
import 'sincronizacao_controller.dart';

class ClienteController with ChangeNotifier {
  final SincronizacaoController _sincronizacaoController;
  final LocalStorageService _localStorageService;
  final ClienteService _clienteService;
  List<Cliente> _clientes = [];
  bool _isLoading = false;

  ClienteController(this._clienteService, this._sincronizacaoController, this._localStorageService) {
    _carregarClientes();
  }

  List<Cliente> get clientes => _clientes;
  bool get isLoading => _isLoading;

  void _carregarClientes() {
    _isLoading = true;
    notifyListeners();
    _clienteService.getClientes().listen((firebaseClientes) async { // Carrega os clientes pendentes do banco de dados local
        final pendingClientesMap = await _localStorageService.getPendingClientes();
        final pendingClientes = pendingClientesMap.map((map) => Cliente.fromDbMap(map)).toList();
        final combinedList = {...pendingClientes, ...firebaseClientes}.toList(); // Combina as listas usando um Set para remover duplicados automaticamente
        combinedList.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase())); 
        _clientes = combinedList;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        notifyListeners();
        debugPrint("Erro ao carregar clientes: $error");
      },
    );
  }

  Future<void> adicionarCliente(Cliente cliente) async {
    // Atualização otimista da UI
    _clientes.insert(0, cliente);
    notifyListeners();
    try {
      await _clienteService.adicionarCliente(cliente);
      _sincronizacaoController.startSync(); // Inicia a sincronização em segundo plano após salvar localmente
    } catch (e) {
      // Reverte a UI em caso de falha
      _clientes.remove(cliente);
      notifyListeners();
      debugPrint("Erro ao adicionar cliente: $e");
      rethrow;
    }
  }

  Future<void> atualizarCliente(Cliente cliente) async {
    final clienteIndex = _clientes.indexWhere((c) => c.id == cliente.id);
    if (clienteIndex == -1) return; // Cliente não encontrado na lista
    final originalCliente = _clientes[clienteIndex];
    // Atualização otimista da UI
    _clientes[clienteIndex] = cliente;
    notifyListeners();
    try {
      await _clienteService.atualizarCliente(cliente);
      // Inicia a sincronização em segundo plano
      _sincronizacaoController.startSync();
    } catch (e) {
      // Reverte a UI em caso de falha
      _clientes[clienteIndex] = originalCliente;
      notifyListeners();
      debugPrint("Erro ao atualizar cliente: $e");
      rethrow;
    }
  }

  Future<void> deletarCliente(String id) async {
    final clienteIndex = _clientes.indexWhere((c) => c.id == id);
    if (clienteIndex == -1) return;
    final clienteParaDeletar = _clientes[clienteIndex];
    // Exclusão otimista da UI
    _clientes.removeAt(clienteIndex);
    notifyListeners();
    try {
      // Verifica se o cliente está pendente de sincronização
      final pendingClientesMap = await _localStorageService.getPendingClientes();
      final pendingMatch = pendingClientesMap.firstWhere(
        (map) => map['uuid'] == id,
        orElse: () => <String, dynamic>{},
      );
      if (pendingMatch.isNotEmpty) {
        // Se estiver pendente, remove apenas do banco de dados local
        await _localStorageService.deletePendingCliente(pendingMatch['id'] as int);
      } else {
        // Se já estiver sincronizado, solicita a exclusão no Firebase
        await _clienteService.deletarCliente(id);
      }
    } catch (e) {
      // Reverte a UI em caso de falha
      _clientes.insert(clienteIndex, clienteParaDeletar);
      notifyListeners();
      debugPrint("Erro ao deletar cliente: $e");
      rethrow;
    }
  }
}
