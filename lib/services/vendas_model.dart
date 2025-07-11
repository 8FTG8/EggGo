import 'package:flutter/material.dart';
import 'models.dart';

class VendasModel extends ChangeNotifier {
  final List<Venda> _vendas = [];

  List <Venda> get vendas => _vendas;

  void adicionarVenda(Venda venda) {
    _vendas.add(venda);
    notifyListeners();
  }

  // Método para filtrar vendas por período
  List<Venda> filtrarVendas(DateTimeRange periodo) {
    return _vendas.where((v) => v.data.isAfter(periodo.start) && v.data.isBefore(periodo.end)).toList();
  }

  // Métodos para calcular o total de vendas
  int getTotalVendas(DateTimeRange periodo) {
    return _vendas.where((v) => v.data.isAfter(periodo.start) && v.data.isBefore(periodo.end)).length;
  }

  // Métodos para calcular o valor total
  double getValorTotal(DateTimeRange periodo) {
    return _vendas.where((v) => v.data.isAfter(periodo.start) && v.data.isBefore(periodo.end)).fold(0, (sum, v) => sum + v.total);
  }
}