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
    return _produtosCollection.orderBy('nome').snapshots().map((snapshot) {
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