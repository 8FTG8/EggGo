import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import '../models/cliente_model.dart';
import 'local_sql_service.dart';

abstract class ClienteService {
  Future<void> adicionarCliente(Cliente cliente);
  Future<void> sincronizarCliente(Cliente cliente);
  Future<void> atualizarCliente(Cliente cliente);
  Future<void> deletarCliente(String id);
  Stream<List<Cliente>> getClientes();
}

class ClienteServiceImpl implements ClienteService {
  final CollectionReference _clientesCollection = FirebaseFirestore.instance.collection('clientes');
  final LocalStorageService _localStorageService;
  ClienteServiceImpl(this._localStorageService);

  @override
  Stream<List<Cliente>> getClientes() {
    return _clientesCollection.orderBy('nome').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Cliente.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  @override
  Future<void> adicionarCliente(Cliente cliente) async {
    if (kIsWeb) { // Na web, salva diretamente no Firebase.
      await _clientesCollection.doc(cliente.id).set(cliente.toMap()); 
    } else {
      await _localStorageService.addPendingCliente(cliente);
    }
  }

  @override // Lógica original de salvar no Firebase
  Future<void> sincronizarCliente(Cliente cliente) async {
    await _clientesCollection.doc(cliente.id).set(cliente.toMap());
  }

  @override
  Future<void> atualizarCliente(Cliente cliente) async {
    if (kIsWeb) { // Na web, atualiza diretamente no Firebase.
      await _clientesCollection.doc(cliente.id).update(cliente.toMap()); 
    } else {
      await _localStorageService.upsertPendingCliente(cliente);
    }
  }

  @override
  Future<void> deletarCliente(String id) {
    return _clientesCollection.doc(id).delete();
  }
}