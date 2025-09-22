import 'package:uuid/uuid.dart';

class Produto {
  final String id;
  final String codigo;
  final String nome;
  final String cor;
  final String tamanho;
  final String embalagem;
  final String tipoQuantidade;
  final double duz;

  Produto({
    String? id,
    required this.codigo,
    required this.nome,
    required this.cor,
    required this.tamanho,
    required this.embalagem,
    required this.tipoQuantidade,
    required this.duz,
  }) : id = id ?? const Uuid().v4();

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

  factory Produto.fromDbMap(Map<String, dynamic> map) {
    return Produto(
      id: map['uuid'], // Usa o UUID salvo no banco local
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

  Map<String, dynamic> toDbMap() {
    return {
      'uuid': id, // Salva o UUID no banco local
      'codigo': codigo,
      'nome': nome,
      'cor': cor,
      'tamanho': tamanho,
      'embalagem': embalagem,
      'tipoQuantidade': tipoQuantidade,
      'duz': duz,
    };
  }

  // Usa o ID único para garantir a correta de-duplicação.
  @override
  bool operator ==(Object other) => identical(this, other) || other is Produto && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}