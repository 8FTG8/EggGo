import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'produto_add.dart';

import '../a_core/widgets/header.dart';
import '../b_models/produto_model.dart';
import '../c_controllers/controller_produto.dart';

class Produtos extends StatelessWidget {
  static const routeName = 'ProdutosPage';
  const Produtos({super.key});

  Color _getBorderColor(BuildContext context, Produto produto) {
    switch (produto.cor.toLowerCase()) {
      case 'branco':
        return Theme.of(context).colorScheme.onSurface;
      case 'vermelho':
        return const Color(0xFF900C3F);
      case 'codorna':
        return const Color(0xFFFDB014);
      case 'caipira':
        return Theme.of(context).colorScheme.secondary;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomHeader(pageTitle: 'Produtos Cadastrados', showBackButton: true),
      body: Consumer<ProdutoController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.produtos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.produtos.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado!'));
          }
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.onSurface.withAlpha(102)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      SizedBox(
                        width: 60, 
                        child: Text('Código', 
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                        child: Text('Nome', 
                          style: TextStyle(fontWeight: FontWeight.bold), 
                          textAlign: TextAlign.center)),
                      SizedBox(
                        width: 60, 
                        child: Text('Dúzias', 
                          style: TextStyle(fontWeight: FontWeight.bold), 
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista de produtos cadastrados
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.produtos.length,
                    itemBuilder: (context, index) {
                      final produto = controller.produtos[index];
                      return Dismissible(
                        key: ValueKey(produto.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: colorScheme.primary,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.delete, color: colorScheme.onError),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmar Exclusão"),
                                content: Text("Tem certeza que deseja excluir o produto \"${produto.nome}\"?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("Cancelar")),
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("Excluir"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          Provider.of<ProdutoController>(context, listen: false).deletarProduto(produto.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Produto "${produto.nome}" excluído.'),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(0),
                            border: Border.all(
                              color: _getBorderColor(context, produto),
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text(produto.codigo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(produto.nome, 
                                  textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    produto.duz.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), ''),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // BOTÃO DE CADASTRO \\
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NovoProduto.routeName);
        },
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}