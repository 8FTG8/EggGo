import 'package:uuid/uuid.dart';

/// Define o tipo de cliente, se é pessoa física ou jurídica.
enum TipoPessoa { fisica, juridica }

class Cliente {
  final String id;

  // --- DADOS CADASTRAIS ---
  final TipoPessoa tipoPessoa;
  final String nome;
  final String? apelido;
  final String? email;
  final String? telefone;
  final String? cpf;
  final String? cnpj;
  final String? inscricaoEstadual;

  // --- ENDEREÇO ---
  final String? cep;
  final String? logradouro;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? uf;

  // --- OUTROS ---
  final String? observacoes;

  Cliente({
    String? id,
    required this.nome,
    required this.tipoPessoa,
    this.apelido,
    this.email,
    this.telefone,
    this.cpf,
    this.cnpj,
    this.inscricaoEstadual,
    this.cep,
    this.logradouro,
    this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.uf,
    this.observacoes,
  }) : id = id ?? const Uuid().v4();

  factory Cliente.fromMap(Map<String, dynamic> map, String documentId) {
    return Cliente(
      id: documentId,
      tipoPessoa: (map['tipoPessoa'] == 'juridica') ? TipoPessoa.juridica : TipoPessoa.fisica,
      nome: map['nome'] ?? '',
      apelido: map['apelido'],
      email: map['email'],
      telefone: map['telefone'],
      cpf: map['cpf'],
      cnpj: map['cnpj'],
      inscricaoEstadual: map['inscricaoEstadual'],
      cep: map['cep'],
      logradouro: map['logradouro'],
      numero: map['numero'],
      complemento: map['complemento'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      uf: map['uf'],
      observacoes: map['observacoes'],
    );
  }

  factory Cliente.fromDbMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['uuid'], // Usa o UUID salvo no banco local
      tipoPessoa: (map['tipoPessoa'] == 'juridica') ? TipoPessoa.juridica : TipoPessoa.fisica,
      nome: map['nome'] ?? '',
      apelido: map['apelido'],
      email: map['email'],
      telefone: map['telefone'],
      cpf: map['cpf'],
      cnpj: map['cnpj'],
      inscricaoEstadual: map['inscricaoEstadual'],
      cep: map['cep'],
      logradouro: map['logradouro'],
      numero: map['numero'],
      complemento: map['complemento'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      uf: map['uf'],
      observacoes: map['observacoes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipoPessoa': tipoPessoa.name,
      'nome': nome,
      'apelido': apelido,
      'email': email,
      'telefone': telefone,
      'cpf': cpf,
      'cnpj': cnpj,
      'inscricaoEstadual': inscricaoEstadual,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
      'observacoes': observacoes,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'uuid': id, // Salva o UUID no banco local
      'tipoPessoa': tipoPessoa.name,
      'nome': nome,
      'apelido': apelido,
      'email': email,
      'telefone': telefone,
      'cpf': cpf,
      'cnpj': cnpj,
      'inscricaoEstadual': inscricaoEstadual,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
      'observacoes': observacoes,
    };
  }

  // Usa o ID único para garantir a correta de-duplicação.
  @override
  bool operator ==(Object other) => identical(this, other) || other is Cliente && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
