import 'package:flutter/foundation.dart';
import '../b_models/produto_model.dart';
import '../f_services/service_produto.dart';
import '../f_services/local_sql_service.dart';
import 'sincronizacao_controller.dart';

class ProdutoController with ChangeNotifier {
  final SincronizacaoController _sincronizacaoController;
  final LocalStorageService _localStorageService;
  final ProdutoService _produtoService;
  List<Produto> _produtos = [];
  bool _isLoading = false;

  ProdutoController(this._produtoService, this._sincronizacaoController, this._localStorageService) {
    _carregarProdutos();
  }

  List<Produto> get produtos => _produtos;
  bool get isLoading => _isLoading;

  void _carregarProdutos() {
    _isLoading = true;
    notifyListeners();
    _produtoService.getProdutos().listen((firebaseProdutos) async { // Carrega os produtos pendentes do banco de dados local
        final pendingProdutosMap = await _localStorageService.getPendingProdutos();
        final pendingProdutos = pendingProdutosMap.map((map) => Produto.fromDbMap(map)).toList();
        final combinedList = {...pendingProdutos, ...firebaseProdutos}.toList(); // Combina as listas usando um Set para remover duplicados automaticamente
        combinedList.sort((a, b) => a.codigo.compareTo(b.codigo));
        _produtos = combinedList;
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
    // Atualização otimista da UI
    _produtos.insert(0, produto);
    notifyListeners();

    try {
      await _produtoService.adicionarProduto(produto);
      _sincronizacaoController.startSync(); // Inicia a sincronização em segundo plano após salvar localmente
    } catch (e) {
      // Reverte a UI em caso de falha
      _produtos.remove(produto);
      notifyListeners();
      debugPrint("Erro ao adicionar produto: $e");
      rethrow;
    }
  }

  Future<void> deletarProduto(String id) async {
    final produtoIndex = _produtos.indexWhere((p) => p.id == id);
    if (produtoIndex == -1) return;

    final produtoParaDeletar = _produtos[produtoIndex];
    // Exclusão otimista da UI
    _produtos.removeAt(produtoIndex);
    notifyListeners();

    try {
      // Verifica se o produto está pendente de sincronização
      final pendingProdutosMap = await _localStorageService.getPendingProdutos();
      final pendingMatch = pendingProdutosMap.firstWhere(
        (map) => map['uuid'] == id,
        orElse: () => <String, dynamic>{},
      );

      if (pendingMatch.isNotEmpty) {
        // Se estiver pendente, remove apenas do banco de dados local
        await _localStorageService.deletePendingProduto(pendingMatch['id'] as int);
      } else {
        // Se já estiver sincronizado, solicita a exclusão no Firebase
        await _produtoService.deletarProduto(id);
      }
    } catch (e) {
      // Reverte a UI em caso de falha
      _produtos.insert(produtoIndex, produtoParaDeletar);
      notifyListeners();
      debugPrint("Erro ao deletar produto: $e");
      rethrow;
    }
  }
}