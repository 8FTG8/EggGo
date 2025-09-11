import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/produto_model.dart';

abstract class ProdutoService {
  Future<void> adicionarProduto(Produto produto);
  Stream<List<Produto>> getProdutos();
  Future<void> atualizarProduto(String id, Produto produto);
  Future<void> deletarProduto(String id);
}

class ProdutoDuplicadoException implements Exception {
  final String message;
  ProdutoDuplicadoException(this.message);

  @override
  String toString() => message;
}

class ProdutoServiceImpl implements ProdutoService {
  final CollectionReference _produtosCollection = 
    FirebaseFirestore.instance.collection('produtos');

  // Adiciona um novo produto ao Firestore.
  @override
  Future<void> adicionarProduto(Produto produto) async {
    final querySnapshot = await _produtosCollection
        .where('codigo', isEqualTo: produto.codigo)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      throw ProdutoDuplicadoException('Já existe um produto com o código ${produto.codigo}.');
    }

    await _produtosCollection.add(produto.toMap());
  }

  @override
  Stream<List<Produto>> getProdutos() {
    return _produtosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map<Produto>((doc) {
        return Produto.fromFirestore(doc);
      }).toList();
    });
  }

  // Atualiza um produto existente no Firestore.
  @override
  Future<void> atualizarProduto(String id, Produto produto) {
    return _produtosCollection.doc(id).update(produto.toMap());
  }

  // Deleta um produto do Firestore usando seu ID.
  @override
  Future<void> deletarProduto(String id) {
    return _produtosCollection.doc(id).delete();
  }
}

//----------------------------------------------\\
// --- IMPLEMENTAÇÃO MOCK PARA TESTES LOCAIS --- \\
class MockProdutoServiceImpl implements ProdutoService {
  final List<Produto> _produtos = [];
  final _streamController = StreamController<List<Produto>>.broadcast();
  int _nextId = 1;

  MockProdutoServiceImpl() {
    // Adiciona alguns dados iniciais para teste, sem passar pela validação
    _produtos.addAll([
      Produto(id: '1', codigo: '#01', nome: 'Branco Grande Estojo CX', cor: 'Branco', tamanho: 'Grande', embalagem: 'Estojo', tipoQuantidade: 'CX', duz: 30.0),
      Produto(id: '2', codigo: '#02', nome: 'Vermelho Extra Granel Dúzia', cor: 'Vermelho', tamanho: 'Extra', embalagem: 'Granel', tipoQuantidade: 'Dúzia', duz: 1.0),
    ]);
    _nextId = 3;
  }

  @override
  Future<void> adicionarProduto(Produto produto) async {
    if (_produtos.any((p) => p.codigo == produto.codigo)) {
      throw ProdutoDuplicadoException('Já existe um produto com o código ${produto.codigo}.');
    }

    await Future.delayed(const Duration(milliseconds: 200)); // Simula um delay de rede
    final novoProduto = Produto(
      id: _nextId.toString(),
      codigo: produto.codigo,
      nome: produto.nome,
      cor: produto.cor,
      tamanho: produto.tamanho,
      embalagem: produto.embalagem,
      tipoQuantidade: produto.tipoQuantidade,
      duz: produto.duz,
    );
    _produtos.add(novoProduto);
    _nextId++;
    _streamController.add(List.from(_produtos));
  }

  @override
  Stream<List<Produto>> getProdutos() {
    // Emite a lista atual para novos ouvintes
    Future.delayed(Duration.zero, () => _streamController.add(List.from(_produtos)));
    return _streamController.stream;
  }

  @override
  Future<void> atualizarProduto(String id, Produto produto) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _produtos.indexWhere((p) => p.id == id);
    if (index != -1) {
      _produtos[index] = Produto(
        id: id,
        codigo: produto.codigo,
        nome: produto.nome,
        cor: produto.cor,
        tamanho: produto.tamanho,
        embalagem: produto.embalagem,
        tipoQuantidade: produto.tipoQuantidade,
        duz: produto.duz,
      );
      _streamController.add(List.from(_produtos));
    }
  }

  @override
  Future<void> deletarProduto(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _produtos.removeWhere((p) => p.id == id);
    _streamController.add(List.from(_produtos));
  }
}