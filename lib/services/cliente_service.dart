import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cliente_model.dart';
import 'dart:async';

abstract class ClienteService {
  Future<void> adicionarCliente(Cliente cliente);
  Stream<List<Cliente>> getClientes();
}

class ClienteServiceImpl implements ClienteService {
  final CollectionReference _clientesCollection =
      FirebaseFirestore.instance.collection('clientes');

  @override
  Future<void> adicionarCliente(Cliente cliente) async {
    await _clientesCollection.add(cliente.toMap());
  }

  @override
  Stream<List<Cliente>> getClientes() {
    return _clientesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Cliente.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}

// --- IMPLEMENTAÇÃO MOCK PARA TESTES LOCAIS --- \\

class MockClienteServiceImpl implements ClienteService {
  final List<Cliente> _clientes = [];
  final _streamController = StreamController<List<Cliente>>.broadcast();
  int _nextId = 1;

  MockClienteServiceImpl() {
    // Adiciona alguns dados iniciais para teste
    _clientes.addAll([
      Cliente(id: '1', nome: 'João da Silva', telefone: '(11) 98765-4321', municipio: 'São Paulo'),
      Cliente(id: '2', nome: 'Maria Oliveira', apelido: 'Lia', municipio: 'Rio de Janeiro'),
    ]);
    _nextId = 3;
  }

  @override
  Future<void> adicionarCliente(Cliente cliente) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simula delay
    final novoCliente = Cliente(
      id: _nextId.toString(),
      nome: cliente.nome,
      apelido: cliente.apelido,
      telefone: cliente.telefone,
      cpfCnpj: cliente.cpfCnpj,
      cep: cliente.cep,
      numero: cliente.numero,
      logradouro: cliente.logradouro,
      bairro: cliente.bairro,
      municipio: cliente.municipio,
      observacoes: cliente.observacoes,
    );
    _clientes.add(novoCliente);
    _nextId++;
    _streamController.add(List.from(_clientes));
  }

  @override
  Stream<List<Cliente>> getClientes() {
    // Emite a lista atual para novos ouvintes
    Future.delayed(Duration.zero, () => _streamController.add(List.from(_clientes)));
    return _streamController.stream;
  }
}

