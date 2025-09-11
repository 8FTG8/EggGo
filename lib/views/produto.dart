import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/widgets/header.dart';
import '../views/produto_add.dart';
//import '../views/sincronizacao.dart';
import '../controllers/produto_controller.dart';
import '../models/produto_model.dart';

class Produtos extends StatelessWidget {
  static const routeName = 'ProdutosPage';
  const Produtos({super.key});

  Color _getBorderColor(Produto produto) {
    switch (produto.cor.toLowerCase()) {
      case 'branco':
        return const Color(0xFF000C39);
      case 'vermelho':
        return const Color(0xFF900C3F);
      case 'codorna':
        return const Color(0xFFFDB014);
      case 'caipira':
        return AppColors.secondary;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomHeader(
        pageTitle: 'Produtos Cadastrados',
        showBackButton: true,
      ),
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
                      bottom: BorderSide(color: Colors.black.withOpacity(0.4)))),
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
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.produtos.length,
                    itemBuilder: (context, index) {
                      final produto = controller.produtos[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _getBorderColor(produto),
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
                                child: Text(
                                  produto.codigo,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  produto.nome,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: Text(
                                  produto.duz
                                    .toStringAsFixed(2)
                                    .replaceAll(RegExp(r'0*$'), '')
                                    .replaceAll(RegExp(r'\.$'), ''),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
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
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}