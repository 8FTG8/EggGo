import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

import '../a_core/widgets/header.dart';
import '../a_core/utils/pdf_generator.dart';
import '../b_models/venda_model.dart';

class VendaComprovante extends StatelessWidget {
  static const routeName = 'VendaComprovante';
  final Venda venda;
  const VendaComprovante({super.key, required this.venda});

  Widget _buildInfoCard(BuildContext context, {required String title, required String content, required IconData icon}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
        subtitle: Text(content, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatadorData = DateFormat('dd/MM/yyyy \'às\' HH:mm');
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const CustomHeader(pageTitle: 'Detalhes da Venda', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoCard(
            context,
            title: 'Cliente',
            content: venda.cliente,
            icon: Icons.person,
          ),
          _buildInfoCard(
            context,
            title: 'Data da Venda',
            content: formatadorData.format(venda.data),
            icon: Icons.calendar_today,
          ),
          if (venda.metodoPagamento != null)
            _buildInfoCard(
              context,
              title: 'Método de Pagamento',
              content: venda.metodoPagamento!,
              icon: Icons.payment,
            ),
          const SizedBox(height: 16),
          Text('Itens Vendidos', style: Theme.of(context).textTheme.titleLarge),
          const Divider(),
          ...venda.produtos.map((item) => ListTile(
              title: Text(item.nome),
              subtitle: Text('${item.quantidade} x ${formatadorMoeda.format(item.precoUnitario)}'),
              trailing: Text(
                formatadorMoeda.format(item.subtotal),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            )),
          const Divider(),
          ListTile(
            title: Text('Total da Venda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.primary)),
            trailing: Text(
              formatadorMoeda.format(venda.total),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.secondary),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExportOptions(context),
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text('Exportar PDF'),
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Exportar em A4 (Padrão)'),
                onTap: () {
                  Navigator.of(context).pop();
                  PdfGenerator.gerarComprovanteVenda(venda, PdfPageFormat.a4);
                },
              ),
              ListTile(
                leading: const Icon(Icons.note_alt_outlined),
                title: const Text('Exportar em A6 (Recibo)'),
                onTap: () {
                  Navigator.of(context).pop();
                  PdfGenerator.gerarComprovanteVenda(venda, PdfPageFormat.a6);
                },
              ),
            ],
          ),
        );
      },
    );
  }  
}