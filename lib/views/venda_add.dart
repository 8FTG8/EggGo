import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/widgets/header.dart';
import '../core/widgets/card_produto.dart';
import '../controllers/venda_controller.dart';
import '../models/venda_model.dart';

class NovaVenda extends StatefulWidget {
  static const routeName = 'NovaVenda';
  const NovaVenda({super.key});
  
  @override
  State<NovaVenda> createState() => _NovaVendaState();
}

class _NovaVendaState extends State<NovaVenda> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clienteController = TextEditingController();
  final List<ProdutoForm> _produtos = [];
  final List<String> _pagamento =  ['Crédito', 'Débito', 'Dinheiro', 'Pix', 'Boleto', 'A Prazo'];
  String? _pagamentoSelecionado;

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
      // Mapeia os formulários de produto para o modelo ItemVendido.
      // Assumindo que 'p' (um objeto ProdutoForm) tem os campos nome, quantidade e precoUnitario.
      produtos: produtosValidos.map((p) => ItemVendido(
        nome: p.nome,
        quantidade: p.quantidade,
        precoUnitario: p.precoUnitario,
      )).toList(),
      total: _calcularTotal(),
      data: DateTime.now(),
    );
    
    await Provider.of<VendaController>(context, listen: false).adicionarVenda(venda);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(pageTitle: 'Nova Venda', showBackButton: false),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          children: [

            const SizedBox(height: 24),
            TextFormField(
              controller: _clienteController,
              decoration: _buildInputDecoration('* Cliente'),
              validator: (value) =>
                  value!.trim().isEmpty ? 'Informe o cliente' : null,
            ),
            
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _pagamentoSelecionado,
              decoration: _buildInputDecoration('* Método de pagamento'),
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
              validator: (value) => value == null ? 'Selecione um método de pagamento!' : null,
            ),

            const SizedBox(height: 8),
            ...List.generate(
              _produtos.length,
              (index) => ProdutoCard(
                produto: _produtos[index],
                index: index,
                onRemoved: () => _removerProduto(index),
                onNomeChanged: (value) => setState(() {
                  _produtos[index].nome = value.trim();
                }),
                onQuantidadeChanged: (value) => setState(() {
                  _produtos[index].quantidade = int.tryParse(value) ?? 0;
                }),
                onPrecoChanged: (value) => setState(() {
                  _produtos[index].precoUnitario = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                }),
              ),
            ),

            const SizedBox(height: 8),
            Text('Total: R\$ ${_calcularTotal().toStringAsFixed(2).replaceAll('.', ',')}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, 
                fontSize: 18,
              ),
            ),

            // Divider \\
            const Divider(thickness: 1.0, color: AppColors.primary),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: Row(
                children: [

                  // Botão Adicionar \\
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

                  const SizedBox(width: 16),

                  // Botão Finalizar \\
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