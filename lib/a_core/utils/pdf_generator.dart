import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../b_models/venda_model.dart';

class PdfGenerator {
  static Future<void> gerarComprovanteVenda(Venda venda, PdfPageFormat pageFormat) async {
    final pdf = pw.Document();
    final logo = pw.MemoryImage((await rootBundle.load('lib/a_core/images/logo.png')).buffer.asUint8List());
    final formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatadorData = DateFormat('dd/MM/yyyy \'às\' HH:mm');

    // Define estilos e tamanhos com base no formato da página para redimensionamento.
    final bool isA6 = pageFormat == PdfPageFormat.a6;
    final double logoWidth        = isA6 ? 90 : 150;
    final double logoHeight       = isA6 ? 30 : 50;
    final double totalFontSize    = isA6 ? 12 : 18;
    final double headerFontSize   = isA6 ? 12 : 18;
    final double bodyFontSize     = isA6 ? 10 : 14;
    final double smallFontSize    = isA6 ? 08 : 12;
    
    final pw.EdgeInsets cellPadding = isA6 ? const pw.EdgeInsets.all(3) : const pw.EdgeInsets.all(5);
    final Map<int, pw.TableColumnWidth> columnWidths = isA6
      ? {
          0: const pw.FlexColumnWidth(2.5), // Produto
          1: const pw.FlexColumnWidth(0.8), // Qtd
          2: const pw.FlexColumnWidth(1.5), // Preço Unit.
          3: const pw.FlexColumnWidth(1.5), // Subtotal
        }
      : {};

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // Cabeçalho
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(
                    height: logoHeight,
                    width: logoWidth,
                    child: pw.Image(logo)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Comprovante de Venda', style: pw.TextStyle(fontSize: headerFontSize, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Data: ${formatadorData.format(venda.data)}', style: pw.TextStyle(fontSize: smallFontSize)),
                    ],
                  ),
                ],
              ),
              pw.Divider(height: isA6 ? 15 : 30),

              // Informações do Cliente
              pw.Text('Cliente: ${venda.cliente}', 
                style: pw.TextStyle(
                  fontSize: bodyFontSize, 
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: isA6 ? 2 : 4),
              if (venda.metodoPagamento != null) 
                pw.Text('Pagamento: ${venda.metodoPagamento}', 
                  style: pw.TextStyle(
                    fontSize: smallFontSize,
                  ),
                ),
              pw.SizedBox(height: isA6 ? 10 : 20),

              // Tabela de Produtos
              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: smallFontSize),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: cellPadding,
                cellStyle: pw.TextStyle(fontSize: smallFontSize),
                columnWidths: columnWidths,
                headers: ['Produto', 'Qtd.', 'Preço Unit.', 'Subtotal'],
                data: venda.produtos.map((item) => [
                  item.nome,
                  item.quantidade.toString(),
                  formatadorMoeda.format(item.precoUnitario),
                  formatadorMoeda.format(item.subtotal),
                ]).toList(),
              ),
              pw.Divider(),

              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Total: ', 
                    style: pw.TextStyle(
                      fontSize: totalFontSize, 
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(formatadorMoeda.format(venda.total), 
                    style: pw.TextStyle(
                      fontSize: totalFontSize, 
                      color: PdfColors.green700, 
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.Spacer(),

              // Rodapé
              pw.Center(
                child: pw.Text('Desde 1980 entregando ovos da melhor qualidade!', 
                  style: pw.TextStyle(
                    fontStyle: pw.FontStyle.italic, 
                    fontSize: smallFontSize,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}