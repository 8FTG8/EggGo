import '../models/venda_model.dart';

abstract class VendaService {
  Future<void> adicionarVenda(Venda venda);
  Future<List<Venda>> listarVendas(); // Adicione este método
}

class VendaServiceImpl implements VendaService {
  final List<Venda> _vendas = [];
  
  @override
  Future<void> adicionarVenda(Venda venda) async {
    if (!_vendas.any((v) => 
      v.cliente == venda.cliente &&
      v.data == venda.data &&
      v.total ==venda.total
    )) {
      _vendas.add(venda);
    }
  }

  @override
  Future<List<Venda>> listarVendas() async {
    return List.unmodifiable(_vendas);
  }
}