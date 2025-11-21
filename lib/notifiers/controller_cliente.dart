import 'package:flutter/foundation.dart';
import '../models/cliente_model.dart';
import '../services/service_cliente.dart';
import '../services/local_sql_service.dart';
import 'controller_sincronizacao.dart';

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
        List<Cliente> combinedList;
        if (kIsWeb) {
          combinedList = firebaseClientes;
        } else {
          final pendingClientesMap = await _localStorageService.getPendingClientes();
          final pendingClientes = pendingClientesMap.map((map) => Cliente.fromDbMap(map)).toList();
          combinedList = {...pendingClientes, ...firebaseClientes}.toList(); // Combina as listas usando um Set para remover duplicados automaticamente
        }
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
    _clientes.removeAt(clienteIndex);
    notifyListeners();
    try {
      if (kIsWeb) {
        await _clienteService.deletarCliente(id);
      } else {
        final deletedFromLocal = await _localStorageService.deletePendingByUuid('pending_clientes', id);
        if (!deletedFromLocal) {
          await _clienteService.deletarCliente(id);
        }
      }
    } catch (e) {
      _clientes.insert(clienteIndex, clienteParaDeletar);
      notifyListeners();
      debugPrint("Erro ao deletar cliente: $e");
      rethrow;
    }
  }
}
