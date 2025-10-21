import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/widgets/header.dart';
import '../notifiers/controller_venda.dart';
import 'venda_comprovante.dart';

class VendaHistorico extends StatelessWidget {
  static const routeName = 'VendaHistorico';
  const VendaHistorico({super.key});

  @override
  Widget build(BuildContext context) {
    final formatadorMoeda =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatadorData = DateFormat('dd/MM/yyyy \'às\' HH:mm');

    return Scaffold(
      appBar: const CustomHeader(
          pageTitle: 'Histórico de Vendas', showBackButton: true),
      body: Consumer<VendaController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.vendas.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma venda registrada.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          final vendasOrdenadas = controller.vendasOrdenadasPorData;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: vendasOrdenadas.length,
            itemBuilder: (context, index) {
              final venda = vendasOrdenadas[index];
              return Dismissible(
                key: ValueKey(venda.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Theme.of(context).colorScheme.primary,
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.delete,
                      color: Theme.of(context).colorScheme.onError),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirmar Exclusão"),
                        content: Text(
                            "Tem certeza que deseja excluir a venda para o cliente \"${venda.cliente}\"?"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancelar")),
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.error),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Excluir"),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  Provider.of<VendaController>(context, listen: false)
                      .deletarVenda(venda.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Venda para "${venda.cliente}" excluída.')),
                  );
                },
                child: Card(
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withAlpha(26),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.receipt_long),
                    ),
                    title: Text(venda.cliente,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(formatadorData.format(venda.data)),
                    trailing: Text(
                      formatadorMoeda.format(venda.total),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, VendaComprovante.routeName,
                          arguments: venda);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
