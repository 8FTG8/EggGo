import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/venda_model.dart';
import '../services/service_venda.dart';
import '../services/local_sql_service.dart';
import 'sincronizacao_controller.dart';

class VendaController with ChangeNotifier {
  final SincronizacaoController _sincronizacaoController;
  final LocalStorageService _localStorageService;
  final VendaService _vendaService;
  List<Venda> _vendas = [];
  bool _isLoading = false;

  VendaController(this._vendaService, this._sincronizacaoController, this._localStorageService) {
    _ouvirVendas();
  }

  List<Venda> get vendas => _vendas;
  bool get isLoading => _isLoading;

  List<Venda> get vendasOrdenadasPorData {
    final sortedList = List<Venda>.from(_vendas);
    sortedList.sort((a, b) => b.data.compareTo(a.data));
    return sortedList;
  }

  void _ouvirVendas() {
    _isLoading = true;
    notifyListeners();
    _vendaService.getVendas().listen((firebaseVendas) async { // Carrega as vendas pendentes do banco de dados local
      if (kIsWeb) {
        _vendas = firebaseVendas;
      } else {
        final pendingVendasMap = await _localStorageService.getPendingVendas();
        final pendingVendas = pendingVendasMap.map((map) => Venda.fromDbMap(map)).toList();
        _vendas = {...pendingVendas, ...firebaseVendas}.toList(); // Combina as listas usando um Set para remover duplicados e depois converte para lista.
      }
      _isLoading = false;
      notifyListeners();
    }, 
    onError: (error) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Erro ao carregar vendas: $error");
    });
  }

  Future<void> adicionarVenda(Venda venda) async {
    // Atualização otimista da UI
    _vendas.insert(0, venda);
    notifyListeners();

    try {
      // A chamada é feita apenas uma vez para evitar duplicidade.
      await _vendaService.adicionarVenda(venda);
      _sincronizacaoController.startSync(); // Inicia a sincronização em segundo plano após salvar localmente
    } catch (e) {
      // Reverte a UI em caso de falha
      _vendas.remove(venda);
      notifyListeners();
      debugPrint("Erro ao adicionar venda: $e");
      rethrow;
    }
  }

  Future<void> deletarVenda(String id) async {
    final vendaIndex = _vendas.indexWhere((v) => v.id == id);
    if (vendaIndex == -1) return;

    final vendaParaDeletar = _vendas[vendaIndex];
    // Exclusão otimista da UI
    _vendas.removeAt(vendaIndex);
    notifyListeners();

    try {
      if (kIsWeb) {
        await _vendaService.deletarVenda(id);
      } else {
        final deletedFromLocal = await _localStorageService.deletePendingByUuid('pending_vendas', id);
        if (!deletedFromLocal) {
          await _vendaService.deletarVenda(id);
        }
      }
    } catch (e) {
      // Reverte a UI em caso de falha
      _vendas.insert(vendaIndex, vendaParaDeletar);
      notifyListeners();
      debugPrint("Erro ao deletar venda: $e");
      rethrow;
    }
  }

  List<Venda> _getVendasNoPeriodo(DateTimeRange periodo) {
    return _vendas.where((v) => 
      !v.data.isBefore(periodo.start) && v.data.isBefore(periodo.end)
    ).toList();
  }

  // Métodos para o CardVendas
  int getTotalVendas(DateTimeRange periodo) {
    return _getVendasNoPeriodo(periodo).length;
  }

  double getValorTotal(DateTimeRange periodo) {
    return _getVendasNoPeriodo(periodo).fold(0.0, (sum, v) => sum + v.total);
  }

  // Método otimizado para o CardVendas
  ({int totalVendas, double valorTotal}) getResumoVendas(DateTimeRange periodo) {
    final vendasNoPeriodo = _getVendasNoPeriodo(periodo);
    final valorTotal = vendasNoPeriodo.fold(0.0, (sum, v) => sum + v.total);
    return (totalVendas: vendasNoPeriodo.length, valorTotal: valorTotal);
  }

}