class Cliente {
  String? id;
  final String nome;
  final String? apelido;
  final String? telefone;
  final String? cpfCnpj;
  final String? cep;
  final String? numero;
  final String? logradouro;
  final String? bairro;
  final String? municipio;
  final String? observacoes;

  Cliente({
    this.id,
    required this.nome,
    this.apelido,
    this.telefone,
    this.cpfCnpj,
    this.cep,
    this.numero,
    this.logradouro,
    this.bairro,
    this.municipio,
    this.observacoes,
  });

  factory Cliente.fromMap(Map<String, dynamic> map, String documentId) {
    return Cliente(
      id: documentId,
      nome: map['nome'] ?? '',
      apelido: map['apelido'],
      telefone: map['telefone'],
      cpfCnpj: map['cpfCnpj'],
      cep: map['cep'],
      numero: map['numero'],
      logradouro: map['logradouro'],
      bairro: map['bairro'],
      municipio: map['municipio'],
      observacoes: map['observacoes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'apelido': apelido,
      'telefone': telefone,
      'cpfCnpj': cpfCnpj,
      'cep': cep,
      'numero': numero,
      'logradouro': logradouro,
      'bairro': bairro,
      'municipio': municipio,
      'observacoes': observacoes,
    };
  }
}
