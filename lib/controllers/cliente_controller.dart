import 'package:flutter/foundation.dart';
import '../models/cliente_model.dart';
import '../services/cliente_service.dart';

class ClienteController with ChangeNotifier {
  final ClienteService _clienteService;
  List<Cliente> _clientes = [];
  bool _isLoading = false;

  ClienteController(this._clienteService) {
    _carregarClientes();
  }

  List<Cliente> get clientes => _clientes;
  bool get isLoading => _isLoading;

  void _carregarClientes() {
    _isLoading = true;
    notifyListeners();
    _clienteService.getClientes().listen(
      (clientes) {
        _clientes = clientes;
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
    try {
      // A lista será atualizada automaticamente pelo stream em _carregarClientes
      await _clienteService.adicionarCliente(cliente);
    } catch (e) {
      // Idealmente, você trataria o erro de forma mais robusta
      debugPrint("Erro ao adicionar cliente: $e");
      rethrow;
    }
  }
}
