class Produto {
  final String nome;
  final int quantidade;
  final double precoUnitario;

  Produto({
    required this.nome,
    required this.quantidade,
    required this.precoUnitario,
  });
}

class Venda {
  final String cliente;
  final List<Produto> produtos;
  final double total;
  final DateTime data;

  Venda({
    required this.cliente,
    required this.produtos,
    required this.total,
    required this.data,
  });
}