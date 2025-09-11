import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class ProdutoForm {
  String nome = '';
  int quantidade = 0;
  double precoUnitario = 0.0;
  bool get valido => nome.isNotEmpty && quantidade > 0 && precoUnitario > 0;
}

class ProdutoCard extends StatelessWidget {
  final int index;
  final ProdutoForm produto;
  final Function() onRemoved;
  final Function(String) onNomeChanged;
  final Function(String) onQuantidadeChanged;
  final Function(String) onPrecoChanged;

  const ProdutoCard({
    super.key,
    required this.produto,
    required this.index,
    required this.onRemoved,
    required this.onNomeChanged,
    required this.onQuantidadeChanged,
    required this.onPrecoChanged,
  });

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

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    required Function(String) onChanged,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: _buildInputDecoration(label),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('produto_${index}_${produto.hashCode}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemoved(),
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
              child: Text('Produto ${index + 1}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              label: '* Nome do produto',
              initialValue: produto.nome,
              onChanged: onNomeChanged,
              validator: (value) => value!.trim().isEmpty ? 'Informe o nome do produto!' : null,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: '* Quantidade',
                    initialValue: produto.quantidade == 0 ? '' : produto.quantidade.toString(),
                    onChanged: onQuantidadeChanged,
                    validator: (value) => (int.tryParse(value ?? '0') ?? 0) <= 0 ? 'Quantidade inválida!' : null,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    label: '* Preço unitário',
                    initialValue: produto.precoUnitario == 0.0 
                      ? '' 
                      : produto.precoUnitario.toStringAsFixed(2).replaceAll('.', ','),
                    onChanged: onPrecoChanged,
                    validator: (value) => (double.tryParse(value?.replaceAll(',', '.') ?? '0') ?? 0) <= 0 
                      ? 'Preço inválido!' 
                      : null,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
