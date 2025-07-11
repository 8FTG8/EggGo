import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:egg_go/utilis/app_colors.dart';
import 'package:egg_go/widgets/header.dart';
import 'package:egg_go/services/vendas_model.dart';
import 'package:egg_go/services/models.dart';

class ProdutoForm {
  String nome = '';
  int quantidade = 0;
  double precoUnitario = 0.0;

  bool get valido => nome.isNotEmpty && quantidade > 0 && precoUnitario > 0;

  Produto toProduto() => 
    Produto(
      nome: nome,
      quantidade: quantidade,
      precoUnitario: precoUnitario,
  );
}

class NovaVendaPage extends StatefulWidget {
  const NovaVendaPage({super.key});
  
  @override
  State<NovaVendaPage> createState() => _NovaVendaPageState();
}

class _NovaVendaPageState extends State<NovaVendaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clienteController = TextEditingController();
  final List<ProdutoForm> _produtos = [];

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

  void _finalizarVenda() {
    if (!_formKey.currentState!.validate()) return;

    final produtosValidos = _produtos.where((p) => p.valido).toList();
    if (produtosValidos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos um produto válido'),
        ),
      );
      return;
    }

    final venda = Venda(
      cliente: _clienteController.text.trim(),
      produtos: produtosValidos.map((p) => p.toProduto()).toList(),
      total: _calcularTotal(),
      data: DateTime.now(),
    );

    Provider.of<VendasModel>(context, listen: false).adicionarVenda(venda);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Venda cadastrada com sucesso!'),
      ),
    );

    _resetarFormulario();
  }

  void _resetarFormulario() {
    _formKey.currentState?.reset();
    _clienteController.clear();
    setState(() {
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

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14, 
        fontWeight: FontWeight.bold, 
        color: Colors.black
      ),
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.black)
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary)
      ),
    );
  }

  Widget _buildProdutoCard(int index) {
    final produto = _produtos[index];
    return Dismissible(
      key: ObjectKey(produto),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _removerProduto(index),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        color: AppColors.primary,
        child: const Icon(
          Icons.delete, 
          color: Colors.white,
        ),
      ),

      // Card de produto \\
      child: Card(
        color: AppColors.background,
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('Produto ${index + 1}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 16),
            TextFormField(
              initialValue: produto.nome,
              decoration: _buildInputDecoration('* Nome do produto'),
              onChanged: (value) {
                setState(() {
                  produto.nome = value.trim();
                });
              },
              validator: (value) => 
                value!.trim().isEmpty ? 'Informe o nome do cliente!' : null,
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: produto.quantidade == 0 ? '' : produto.quantidade.toString(),
                    decoration: _buildInputDecoration('* Quantidade'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        produto.quantidade = int.tryParse(value ?? '0') ?? 0;
                      });
                    },
                    validator: (value) => (int.tryParse(value ?? '0') ?? 0) <= 0 ? 'Quantidade inválida!' : null,
                  ),
                ),
                
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: produto.precoUnitario == 0.0 ? '' : produto.precoUnitario.toStringAsFixed(2).replaceAll('.', ','),
                    decoration: _buildInputDecoration('* Preço unitário'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        produto.precoUnitario = double.tryParse(value?.replaceAll(',', '.') ?? '0') ?? 0.0;
                      });
                    },
                    validator: (value) => (double.tryParse(value?.replaceAll(',', '.') ?? '0') ?? 0) <= 0 ? 'Preço inválido!' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(pageTitle: 'Nova Venda', showBackButton: false),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 24),
            TextFormField(
              controller: _clienteController,
              decoration: _buildInputDecoration('* Cliente'),
              validator: (value) => 
                value!.trim().isEmpty ? 'Informe o cliente' : null,
            ),

            const SizedBox(height: 24),
            ...List.generate(_produtos.length, (index) => _buildProdutoCard(index)),

            const SizedBox(height: 16),
            Text('Total: R\$ ${_calcularTotal().toStringAsFixed(2).replaceAll('.', ',')}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, 
                fontSize: 18
              ),
            ),

            // Botão Adicionar \\
            const Divider(thickness: 1.0, color: AppColors.primary),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _adicionarProduto,
                      icon: const Icon(Icons.add),
                      label: const Text("Adicionar"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),

                  // Botão Finalizar \\
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _finalizarVenda,
                      icon: const Icon(Icons.check),
                      label: const Text("Finalizar"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        backgroundColor: Colors.white,
                      ),
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