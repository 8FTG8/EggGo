import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String? id;
  final String codigo;
  final String nome;
  final String cor;
  final String tamanho;
  final String embalagem;
  final String tipoQuantidade;
  final double duz;

  Produto({
    this.id,
    required this.codigo,
    required this.nome,
    required this.cor,
    required this.tamanho,
    required this.embalagem,
    required this.tipoQuantidade,
    required this.duz,
  });

  factory Produto.fromMap(Map<String, dynamic> map, String documentId) {
    return Produto(
      id: documentId,
      codigo: map['codigo'] ?? '',
      nome: map['nome'] ?? '',
      cor: map['cor'] ?? '',
      tamanho: map['tamanho'] ?? '',
      embalagem: map['embalagem'] ?? '',
      tipoQuantidade: map['tipoQuantidade'] ?? '',
      duz: (map['duz'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nome': nome,
      'cor': cor,
      'tamanho': tamanho,
      'embalagem': embalagem,
      'tipoQuantidade': tipoQuantidade,
      'duz': duz,
    };
  }

  // ----------------------------------------- \\
  factory Produto.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Produto.fromMap(data, doc.id);
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }
}
