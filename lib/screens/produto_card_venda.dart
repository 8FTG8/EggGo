import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/produto_model.dart';
import 'venda_add.dart'; // Importa para ter acesso a ProdutoForm

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
  String _displayStringForOption(Produto option) {
    return '${option.codigo} - ${option.nome}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(widget.produtoForm),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onRemoved(),
      background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16.0),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(204),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.delete, color: colorScheme.onError)),
      child: Card(
        elevation: 0,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Produto ${widget.index + 1}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                        labelText: '* Nome do produto', isDense: true),
                    validator: (value) {
                      if (widget.produtoForm.produto == null) {
                        return 'Selecione um produto válido!';
                      }
                      if (value !=
                          _displayStringForOption(widget.produtoForm.produto!)) {
                        return 'Selecione um item da lista';
                      }
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
                      decoration: const InputDecoration(
                          labelText: '* Quantidade', isDense: true),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        widget.produtoForm.quantidade =
                            int.tryParse(value) ?? 0;
                        widget.onChanged(widget.produtoForm);
                      },
                      validator: (v) => (int.tryParse(v ?? '0') ?? 0) <= 0
                          ? 'Quantidade inválida!'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: '* Preço Unitário', isDense: true),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        widget.produtoForm.precoUnitario =
                            double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                        widget.onChanged(widget.produtoForm);
                      },
                      validator: (v) =>
                          (double.tryParse(v?.replaceAll(',', '.') ?? '0.0') ??
                                      0.0) <=
                                  0
                              ? 'Preço inválido!'
                              : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
