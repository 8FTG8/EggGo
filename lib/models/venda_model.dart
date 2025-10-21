import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class Venda {
  final String id;
  final String cliente;
  final List<ItemVendido> produtos;
  final double total;
  final DateTime data;
  final String? metodoPagamento;

  Venda({
    String? id,
    required this.cliente,
    required this.produtos,
    required this.total,
    required this.data,
    this.metodoPagamento,
  }) : id = id ?? const Uuid().v4();

  factory Venda.fromMap(Map<String, dynamic> map, String documentId) {
    return Venda(
      id: documentId,
      cliente: map['cliente'] ?? '',
      produtos: (map['produtos'] as List<dynamic>?)?.map((item) => ItemVendido.fromMap(item as Map<String, dynamic>)).toList() ?? [],
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      data: (map['data'] as Timestamp?)?.toDate() ?? DateTime.now(),
      metodoPagamento: map['metodoPagamento'],
    );
  }

  // Factory para criar uma Venda a partir de um mapa do DB local (SQLite)
  factory Venda.fromDbMap(Map<String, dynamic> map) {
    return Venda(
      id: map['uuid'], // Usa o UUID salvo no banco local
      cliente: map['cliente'],
      produtos: (jsonDecode(map['produtos']) as List).map((item) => ItemVendido.fromMap(item as Map<String, dynamic>)).toList(),
      total: map['total'],
      data: DateTime.parse(map['data']),
      metodoPagamento: map['metodoPagamento'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cliente': cliente,
      'produtos': produtos.map((p) => p.toMap()).toList(),
      'total': total,
      'data': Timestamp.fromDate(data),
      'metodoPagamento': metodoPagamento,
    };
  }

  // Converte a Venda para um mapa compatível com o DB local (SQLite)
  Map<String, dynamic> toDbMap() {
    return {
      'uuid': id, // Salva o UUID no banco local
      'cliente': cliente,
      'produtos': jsonEncode(produtos.map((p) => p.toMap()).toList()),
      'total': total,
      'data': data.toIso8601String(), // Salva a data como string
      'metodoPagamento': metodoPagamento,
    };
  }

  // Usa o ID único para garantir a correta de-duplicação.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Venda && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ItemVendido {
  final String nome;
  final int quantidade;
  final double precoUnitario;

  ItemVendido({
    required this.nome,
    required this.quantidade,
    required this.precoUnitario,
  });

  double get subtotal => quantidade * precoUnitario;

  factory ItemVendido.fromMap(Map<String, dynamic> map) {
    return ItemVendido(
      nome: map['nome'] ?? '',
      quantidade: map['quantidade'] ?? 0,
      precoUnitario: (map['precoUnitario'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'quantidade': quantidade,
      'precoUnitario': precoUnitario,
    };
  }
}