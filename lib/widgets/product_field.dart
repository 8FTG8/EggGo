import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Produto {
  String nome = '';
  int quantidade = 0;
  double precoUnitario = 0.0;

  Produto();
}

class ProductField extends StatefulWidget {
  const ProductField({super.key});

  @override
  State<ProductField> createState() => _ProductFieldState();
}

class _ProductFieldState extends State<ProductField> {
  final TextEditingController clienteController = TextEditingController();
  final List<Produto> produtos = [];

  @override
  void initState() {
    super.initState();
    adicionarProduto();
  }

  void adicionarProduto() {
    setState(() {
      produtos.add(Produto());
    });
  }

  void removerProduto(int index) {
    setState(() {
      produtos.removeAt(index);
    });
  }

  double get total {
    return produtos.fold(
        0.0, (sum, p) => sum + p.quantidade * p.precoUnitario);
  }

  Widget _buildProdutoCard(int index) {
    final produto = produtos[index];

    return Dismissible(
      key: ValueKey(produto),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => removerProduto(index),
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Icon(
          Icons.delete, 
          color: Colors.white,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // PRODUTO \\
          const SizedBox(height: 16),
          Center(
            child: Text('Produto ${index + 1}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFDB014),
              ),
            ),
          ),
          
          // CÓDIGO DO PRODUTO \\
          const SizedBox(height: 8),
          TextFormField(
            initialValue: produto.nome,
            decoration: InputDecoration(
              labelText: '* Nome/Código do produto',
              labelStyle: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.bold),
              border: const OutlineInputBorder()),
            onChanged: (value) => setState(() {
              produto.nome = value;
            }),
          ),

          // QUANTIDADE + PREÇO \\
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue:
                      produto.quantidade > 0 
                      ? '${produto.quantidade}' 
                      : '',
                  decoration: InputDecoration(
                    labelText: '* Quantidade',
                    labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                    border: const OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() {
                    produto.quantidade = int.tryParse(value) ?? 0;
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: produto.precoUnitario > 0
                      ? produto.precoUnitario.toStringAsFixed(2)
                      : '',
                  decoration: InputDecoration(
                    labelText: '* Preço unitário',
                    labelStyle: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => setState(() {
                    produto.precoUnitario =
                        double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [

        // CLIENTE \\
        const SizedBox(height: 16),
        TextFormField(
          controller: clienteController,
          decoration: InputDecoration(
            labelText: '* Cliente',
            labelStyle: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.bold),
            border: const OutlineInputBorder(),
          ),
        ),

        ...List.generate(produtos.length, (index) => _buildProdutoCard(index)),

        // TOTAL \\
        const SizedBox(height: 16),
        Text('Total: R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
          const Divider(thickness: 1.5, color: Color(0xFFFDB014)),

        // ADICIONAR PRODUTO  + FINALIZAR VENDA \\
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: adicionarProduto,
                  icon: const Icon(Icons.add),
                  label: Text("Adicionar", style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14)),
                  style: ElevatedButton.styleFrom(foregroundColor: Color(0xFF000C39)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check),
                  label: Text("Finalizar", style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14)),
                  style: ElevatedButton.styleFrom(foregroundColor: Color(0xFF000C39)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
