import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import '../models/produto_model.dart';
import 'local_sql_service.dart';

abstract class ProdutoService {
  Future<void> adicionarProduto(Produto produto);
  Future<void> deletarProduto(String id);
  Future<void> sincronizarProduto(Produto produto);
  Stream<List<Produto>> getProdutos();
}

class ProdutoDuplicadoException implements Exception {
  final String message;
  ProdutoDuplicadoException(this.message);

  @override
  String toString() => message;
}

class ProdutoServiceImpl implements ProdutoService {
  final CollectionReference _produtosCollection = FirebaseFirestore.instance.collection('produtos');
  final LocalStorageService _localStorageService;
  ProdutoServiceImpl(this._localStorageService);
  
  @override // Apenas salva localmente. A verificação de duplicidade será feita na sincronização.
  Future<void> adicionarProduto(Produto produto) async {
    if (kIsWeb) {
      await sincronizarProduto(produto);
    } else {
      await _localStorageService.addPendingProduto(produto);
    }
  }

  @override
  Future<void> deletarProduto(String id) {
    return _produtosCollection.doc(id).delete();
  }

  @override
  Future<void> sincronizarProduto(Produto produto) async {
    final querySnapshot = await _produtosCollection
        .where('codigo', isEqualTo: produto.codigo)
        .limit(1)
        .get();

    // Se um produto com o mesmo código for encontrado, mas com um ID diferente, é uma duplicata.
    if (querySnapshot.docs.isNotEmpty && querySnapshot.docs.first.id != produto.id) {
      throw ProdutoDuplicadoException(
          'Sincronização falhou: Já existe um produto com o código ${produto.codigo}.');
    }

    // Usa o ID do produto como ID do documento no Firebase para consistência.
    // Isso funciona como um "upsert": cria se não existir, atualiza se existir.
    await _produtosCollection.doc(produto.id).set(produto.toMap());
  }

  @override
  Stream<List<Produto>> getProdutos() {
    return _produtosCollection.orderBy('codigo').snapshots().map((snapshot) {
      return snapshot.docs.map<Produto>((doc) {
        return Produto.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

}