import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/venda_model.dart';
import 'local_sql_service.dart';

abstract class VendaService {
  Future<void> adicionarVenda(Venda venda);
  Future<void> deletarVenda(String id);
  Future<void> sincronizarVenda(Venda venda);
  Stream<List<Venda>> getVendas();
}

class VendaServiceImpl implements VendaService {
  final CollectionReference _vendasCollection = FirebaseFirestore.instance.collection('vendas');
  final LocalStorageService _localStorageService;
  VendaServiceImpl(this._localStorageService);

  @override
  Future<void> adicionarVenda(Venda venda) async {
    if (kIsWeb) {
      await _vendasCollection.doc(venda.id).set(venda.toMap()); // Na web, salva diretamente no Firebase.
    } else {
      await _localStorageService.addPendingVenda(venda);
    }
  }

  @override
  Future<void> deletarVenda(String id) {
    return _vendasCollection.doc(id).delete();
  }

  @override // Lógica de salvar no Firebase
  Future<void> sincronizarVenda(Venda venda) async {
    await _vendasCollection.doc(venda.id).set(venda.toMap());
  }

   @override
  Stream<List<Venda>> getVendas() {
    return _vendasCollection.snapshots().map((snapshot) {
      return snapshot.docs
        .map((doc) => Venda.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    });
  }
}