// Representa um item dentro de uma venda, com nome, quantidade e preço específicos para essa transação.
class ItemVendido {
  final String nome;
  final int quantidade;
  final double precoUnitario;

  const ItemVendido({
    required this.nome,
    required this.quantidade,
    required this.precoUnitario,
  });
}

class Venda {
  final String cliente;
  final List<ItemVendido> produtos;
  final double total;
  final DateTime data;

  Venda({
    required this.cliente,
    required this.produtos,
    required this.total,
    required this.data,
  });
}