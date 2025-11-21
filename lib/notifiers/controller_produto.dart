import 'package:flutter/foundation.dart';
import '../models/produto_model.dart';
import '../services/service_produto.dart';
import '../services/local_sql_service.dart';
import 'controller_sincronizacao.dart';

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
        List<Produto> combinedList;
        if (kIsWeb) {
          combinedList = firebaseProdutos;
        } else {
          final pendingProdutosMap = await _localStorageService.getPendingProdutos();
          final pendingProdutos = pendingProdutosMap.map((map) => Produto.fromDbMap(map)).toList();
          combinedList = {...pendingProdutos, ...firebaseProdutos}.toList(); // Combina as listas usando um Set para remover duplicados automaticamente
        }

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
      if (kIsWeb) {
        await _produtoService.deletarProduto(id);
      } else {
        final deletedFromLocal = await _localStorageService.deletePendingByUuid('pending_produtos', id);
        if (!deletedFromLocal) {
          await _produtoService.deletarProduto(id);
        }
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