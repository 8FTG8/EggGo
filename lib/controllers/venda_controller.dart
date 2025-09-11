import 'package:flutter/material.dart';
import '../models/venda_model.dart';
import '../services/venda_service.dart';

class VendaController with ChangeNotifier {
  final VendaService _vendaService;
  List<Venda> _vendas = [];
  bool _isLoading = false;

  VendaController(this._vendaService) {
    _carregarVendas();
  }

  List<Venda> get vendas => _vendas;
  bool get isLoading => _isLoading;

  Future<void> _carregarVendas() async {
    _isLoading = true;
    notifyListeners();
    _vendas = await _vendaService.listarVendas();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> adicionarVenda(Venda venda) async {
    await _vendaService.adicionarVenda(venda);
    // Recarrega a lista de vendas para refletir a adição.
    await _carregarVendas();
  }

  List<Venda> _getVendasNoPeriodo(DateTimeRange periodo) {
    // Garante que a data de início seja inclusiva e a de fim exclusiva.
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

  @override
  void dispose() {
    super.dispose();
  }
}