import 'package:flutter/material.dart';
import 'package:egg_go/views/cadastrar_produto.dart';
import 'package:egg_go/utilis/app_colors.dart';
import 'package:egg_go/widgets/header.dart';

class ProdutosPage extends StatefulWidget {
  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  List<Map<String, dynamic>> produtos = [];

  bool _produtoDuplicado({required String codigo, required String nome}) {
    return produtos.any((produto) => produto['codigo'] == codigo || produto['nome'].toLowerCase() == nome.toLowerCase());
  }

  void _adicionarProduto(Map<String, dynamic> novoProduto) {
    setState(() {
      produtos.add({
        'codigo': novoProduto['codigo'],
        'nome': '${novoProduto['cor']} ${novoProduto['tamanho']} ${novoProduto['embalagem']} ${novoProduto['quantidade']}',
        'duz': _getQuantidadeDuzia(novoProduto['quantidade']),
        'cor': novoProduto['cor'],
        'borderColor': _getBorderColor(novoProduto['cor']),
      });
    });
  }

  Color _getBorderColor(String corOvo) {
    switch (corOvo.toLowerCase()) {
      case 'branco': return AppColors.ovoBranco;
      case 'vermelho': return AppColors.ovoVermelho;
      default: return Colors.grey;
    }
  }

  double _getQuantidadeDuzia(String quantidade) {
    switch (quantidade) {
      case 'Dúzia': 
        return 1;
      case 'Cartela': 
        return 2.5;
      case 'Cartela 20': 
        return 0;
      case 'PVC CX': 
        return 20;
      case 'CX': 
        return 30;
      default: 
        return 0;
    }
  }

  // CONSTRUTOR \\
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(pageTitle: 'Produtos Cadastrados', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black.withOpacity(0.4))
                )
              ),

              // CABEÇALHO DA TABELA \\
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Código', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Nome', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Dúzias', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // LISTA DE PRODUTOS CADASTRADOS \\
            const SizedBox(height: 8),
            Expanded(
              child: produtos.isEmpty
              ? Center(child: Text('Nenhum produto cadastrado!'))
              : ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  final produto = produtos[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: produto['borderColor'], width: 1.5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            produto['codigo'],
                            style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                produto['nome'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Text(produto['duz'].toString(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),

      // BOTÃO DE CADASTRO \\
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novoProduto = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CadastrarProdutoPage(
                produtosExistentes: produtos,
              ),
            ),
          );

          if (novoProduto != null) {
            _adicionarProduto(novoProduto);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}