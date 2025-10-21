import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/widgets/header.dart';
import '../models/venda_model.dart';
import '../models/cliente_model.dart';
import '../models/produto_model.dart';
import '../notifiers/controller_cliente.dart';
import '../notifiers/controller_produto.dart';
import '../notifiers/controller_venda.dart';

import 'produto_card_venda.dart';

class NovaVenda extends StatefulWidget {
  static const routeName = 'NovaVenda';
  const NovaVenda({super.key});

  @override
  State<NovaVenda> createState() => _NovaVendaState();
}

// Classe auxiliar para gerenciar o estado de cada produto no formulário de venda.
class ProdutoForm {
  Produto? produto;
  int quantidade = 1;
  double precoUnitario = 0.0;
  bool get valido => produto != null && quantidade > 0 && precoUnitario > 0.0;
}

class _NovaVendaState extends State<NovaVenda> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clienteController = TextEditingController();
  Key _autocompleteKey = UniqueKey();
  final List<ProdutoForm> _produtos = [];
  final List<String> _pagamento = [
    'Crédito',
    'Débito',
    'Dinheiro',
    'Pix',
    'Boleto',
    'A Prazo'
  ];
  String? _pagamentoSelecionado;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _adicionarProduto();
  }

  @override
  void dispose() {
    _clienteController.dispose();
    super.dispose();
  }

  void _finalizarVenda() async {
    // Impede múltiplos cliques e valida o formulário
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;

    final itensVendidos = _produtos
        .where((p) => p.valido)
        .map((p) => ItemVendido(
              nome: p.produto!.nome,
              quantidade: p.quantidade,
              precoUnitario: p.precoUnitario,
            ))
        .toList();

    if (itensVendidos.isEmpty) {
      // Mostra um aviso se não houver produtos válidos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos um produto válido!'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final venda = Venda(
        cliente: _clienteController.text.trim(),
        produtos: itensVendidos,
        total: _calcularTotal(),
        data: DateTime.now(),
        metodoPagamento: _pagamentoSelecionado,
      );

      await Provider.of<VendaController>(context, listen: false)
          .adicionarVenda(venda);

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Venda cadastrada com sucesso!'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      _resetarFormulario();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Erro ao registrar venda: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _resetarFormulario() {
    _clienteController.clear();
    setState(() {
      _pagamentoSelecionado = null;
      _autocompleteKey = UniqueKey();
      _produtos.clear();
      _adicionarProduto();
    });
  }

  void _adicionarProduto() {
    setState(() {
      _produtos.add(ProdutoForm());
    });
  }

  void _removerProduto(int index) {
    setState(() {
      _produtos.removeAt(index);
    });
  }

  double _calcularTotal() {
    return _produtos
        .where((p) => p.valido)
        .fold(0.0, (sum, p) => sum + (p.quantidade * p.precoUnitario));
  }

  @override
  Widget build(BuildContext context) {
    final allProducts =
        Provider.of<ProdutoController>(context, listen: false).produtos;
    final allClientes =
        Provider.of<ClienteController>(context, listen: false).clientes;

    return Scaffold(
      appBar:
          const CustomHeader(pageTitle: 'Nova Venda', showBackButton: false),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 24),
            Autocomplete<Cliente>(
              key: _autocompleteKey,
              displayStringForOption: (Cliente option) => option.nome,
              optionsBuilder: (TextEditingValue textEditingValue) {
                _clienteController.text = textEditingValue
                    .text; // Atualiza o controller externo com o texto digitado
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Cliente>.empty();
                }
                return allClientes.where((Cliente cliente) {
                  // Filtra a lista de clientes com base no que foi digitado
                  final input = textEditingValue.text.toLowerCase();
                  final nome = cliente.nome.toLowerCase();
                  final apelido = cliente.apelido?.toLowerCase() ?? '';
                  return nome.contains(input) || apelido.contains(input);
                });
              },
              onSelected: (Cliente selection) {
                _clienteController.text = selection.nome;
                FocusScope.of(context)
                    .unfocus(); // Esconde o teclado após a seleção
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return TextFormField(
                  controller:
                      textEditingController, // Usa o controller do Autocomplete
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                      labelText: '* Cliente', isDense: true),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Informe um cliente!' : null,
                );
              },
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _pagamentoSelecionado,
              decoration: const InputDecoration(
                  labelText: '* Método de pagamento', isDense: true),
              items: _pagamento.map((String cor) {
                return DropdownMenuItem<String>(
                  value: cor,
                  child: Text(cor),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _pagamentoSelecionado = newValue;
                });
              },
              validator: (value) =>
                  value == null ? 'Selecione um método de pagamento!' : null,
            ),

            const SizedBox(height: 8),
            ...List.generate(
              _produtos.length,
              (index) {
                return ProdutoCard(
                  key: ValueKey(_produtos[index]),
                  index: index,
                  produtoForm: _produtos[index],
                  allProducts: allProducts,
                  onRemoved: () => _removerProduto(index),
                  onChanged: (updatedForm) {
                    setState(() {
                      _produtos[index] = updatedForm;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 12),
            Text(
              'Total: R\$ ${_calcularTotal().toStringAsFixed(2).replaceAll('.', ',')}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),

            // Divider \\
            Divider(
                thickness: 1.0, color: Theme.of(context).colorScheme.primary),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: Row(
                children: [
                  // Botão Adicionar \\
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _adicionarProduto,
                      icon: const Icon(Icons.add),
                      label: const Text("Adicionar"),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Botão Finalizar \\
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _finalizarVenda,
                      icon: _isLoading ? Container() : const Icon(Icons.check),
                      label: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ))
                          : const Text("Finalizar"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
