import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/produto_model.dart';
import '../core/constants/app_colors.dart';

class ProdutoForm {
  Produto? produto;
  int quantidade = 1;
  double precoUnitario = 0.0;
  bool get valido => produto != null && quantidade > 0;
}

class ProdutoCard extends StatefulWidget {
  final int index;
  final ProdutoForm produtoForm;
  final List<Produto> allProducts;
  final Function() onRemoved;
  final ValueChanged<ProdutoForm> onChanged;

  const ProdutoCard({
    super.key,
    required this.produtoForm,
    required this.allProducts,
    required this.index,
    required this.onRemoved,
    required this.onChanged,
  });

  @override
  State<ProdutoCard> createState() => _ProdutoCardState();
}

class _ProdutoCardState extends State<ProdutoCard> {
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14, 
        fontWeight: FontWeight.bold, 
        color: Colors.black,
      ),
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.black)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
    );
  }

  String _displayStringForOption(Produto option) {
    return '${option.codigo} - ${option.nome}';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('produto_${widget.index}_${widget.produtoForm.hashCode}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onRemoved(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        color: AppColors.primary,
        child: const Icon(Icons.delete, color: Colors.white)),
      child: Card(
        color: AppColors.background,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('Produto ${widget.index + 1}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
              Autocomplete<Produto>(
                displayStringForOption: _displayStringForOption,
                initialValue: TextEditingValue(
                  text: widget.produtoForm.produto != null
                      ? _displayStringForOption(widget.produtoForm.produto!)
                      : '',
                ),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    if (widget.produtoForm.produto != null) {
                      widget.produtoForm.produto = null;
                      widget.onChanged(widget.produtoForm);
                    }
                    return const Iterable<Produto>.empty();
                  }
                  return widget.allProducts.where((Produto option) {
                    final input = textEditingValue.text.toLowerCase();
                    return option.nome.toLowerCase().contains(input) ||
                           option.codigo.toLowerCase().contains(input);
                  });
                },
                onSelected: (Produto selection) {
                  widget.produtoForm.produto = selection;
                  widget.onChanged(widget.produtoForm);
                  FocusScope.of(context).unfocus();
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: _buildInputDecoration('* Nome do produto'),
                    validator: (value) {
                      if (widget.produtoForm.produto == null) return 'Selecione um produto válido';
                      if (value != _displayStringForOption(widget.produtoForm.produto!)) return 'Selecione um item da lista';
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      //initialValue: widget.produtoForm.quantidade.toString(),
                      decoration: _buildInputDecoration('* Quantidade'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        widget.produtoForm.quantidade = int.tryParse(value) ?? 0;
                        widget.onChanged(widget.produtoForm);
                      },
                      validator: (v) => (int.tryParse(v ?? '0') ?? 0) <= 0 ? 'Inválido' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      //initialValue: widget.produtoForm.precoUnitario.toStringAsFixed(2).replaceAll('.', ','),
                      decoration: _buildInputDecoration('* Preço Unitário'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        widget.produtoForm.precoUnitario = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                        widget.onChanged(widget.produtoForm);
                      },
                      validator: (v) => (double.tryParse(v?.replaceAll(',', '.') ?? '0.0') ?? 0.0) < 0 ? 'Inválido' : null,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
