import 'package:flutter/foundation.dart';
import '../models/produto_model.dart';
import '../services/produto_service.dart';

class ProdutoController with ChangeNotifier {
  final ProdutoService _produtoService;
  List<Produto> _produtos = [];
  bool _isLoading = false;

  ProdutoController(this._produtoService) {
    _carregarProdutos();
  }

  List<Produto> get produtos => _produtos;
  bool get isLoading => _isLoading;

  void _carregarProdutos() {
    _isLoading = true;
    notifyListeners();
    _produtoService.getProdutos().listen(
      (produtos) {
        _produtos = produtos;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        notifyListeners();
        debugPrint("Erro ao carregar produtos: $error");
      },
    );
  }

  Future<void> adicionarProduto(Produto produto) async {
    try {
      await _produtoService.adicionarProduto(produto);
    } catch (e) {
      debugPrint("Erro ao adicionar produto: $e");
      rethrow;
    }
  }

  Future<void> deletarProduto(String id) async {
    try {
      await _produtoService.deletarProduto(id);
    } catch (e) {
      debugPrint("Erro ao deletar produto: $e");
      rethrow;
    }
  }
}