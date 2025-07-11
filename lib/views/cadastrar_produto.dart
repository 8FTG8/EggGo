import 'package:egg_go/utilis/app_colors.dart';
import 'package:egg_go/widgets/header.dart';
import 'package:flutter/material.dart';

class CadastrarProdutoPage extends StatefulWidget {
  final List<Map<String, dynamic>> produtosExistentes;

  const CadastrarProdutoPage({
    Key? key,
    required this.produtosExistentes,
  }) : super(key: key);

  @override
  _CadastrarProdutoPageState createState() => _CadastrarProdutoPageState();
}

class _CadastrarProdutoPageState extends State<CadastrarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  String? _corSelecionado;
  String? _tamanhoSelecionado;
  String? _embalagemSelecionada;
  String? _quantidadeSelecionada;
  
  // Opções para os dropdowns
  final List<String> _cor = ['Branco', 'Vermelho'];
  final List<String> _tamanho = ['Pequeno', 'Grande', 'Extra', 'Jumbo'];
  final List<String> _embalagem = ['Estojo', 'Granel', 'PVC'];
  final List<String> _quantidade = ['CX', 'Dúzia', 'Cart. 30', 'Cart. 20'];

  bool _produtoDuplicado({String? codigo, String? nome}) {
    if (codigo != null) {
      if (widget.produtosExistentes.any((p) => p['codigo'] == codigo)) {
        return true;
      }
    }

    if (nome != null) {
      if (widget.produtosExistentes.any((p) => p['nome'] == nome)) {
        return true;
      }
    }

    return false;
  }

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(pageTitle: 'Cadastrar Produto', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              // Campo Código
              TextFormField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: 'Código (# seguido de dois números)',
                  hintText: 'Ex: #12',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o código';
                  }
                  if (!RegExp(r'^#\d{2}$').hasMatch(value)) {
                    return 'Formato inválido. Use # seguido de dois números';
                  }
                  if (_produtoDuplicado(codigo: value)) {
                    return 'Código já cadastrado';
                  }
                  return null;
                },
              ),
              
              // Dropdown Tipo
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _corSelecionado,
                decoration: InputDecoration(
                  labelText: 'Cor',
                  border: OutlineInputBorder(),
                ),
                items: _cor.map((String cor) {
                  return DropdownMenuItem<String>(
                    value: cor,
                    child: Text(cor),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _corSelecionado = newValue;
                  });
                },
                validator: (value) => value == null ? 'Selecione um tipo' : null,
              ),
              
              // Dropdown Tamanho
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _tamanhoSelecionado,
                decoration: InputDecoration(
                  labelText: 'Tamanho',
                  border: OutlineInputBorder(),
                ),
                items: _tamanho.map((String tamanho) {
                  return DropdownMenuItem<String>(
                    value: tamanho,
                    child: Text(tamanho),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tamanhoSelecionado = newValue;
                  });
                },
                validator: (value) => value == null ? 'Selecione um tamanho' : null,
              ),
              
              // Dropdown Embalagem
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _embalagemSelecionada,
                decoration: InputDecoration(
                  labelText: 'Embalagem',
                  border: OutlineInputBorder(),
                ),
                items: _embalagem.map((String embalagem) {
                  return DropdownMenuItem<String>(
                    value: embalagem,
                    child: Text(embalagem),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _embalagemSelecionada = newValue;
                  });
                },
                validator: (value) => value == null ? 'Selecione uma embalagem' : null,
              ),
              
              // Dropdown Quantidade
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _quantidadeSelecionada,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(),
                ),
                items: _quantidade.map((String quantidade) {
                  return DropdownMenuItem<String>(
                    value: quantidade,
                    child: Text(quantidade),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _quantidadeSelecionada = newValue;
                  });
                },
                validator: (value) => value == null ? 'Selecione uma quantidade' : null,
              ),

              // Botão de Cadastrar
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final nomeCompleto = '${_corSelecionado!} ${_tamanhoSelecionado!} ${_embalagemSelecionada!} ${_quantidadeSelecionada}';
                    final produto = {
                      'codigo': _codigoController.text,
                      'nome': nomeCompleto,
                      'cor': _corSelecionado,
                      'tamanho': _tamanhoSelecionado,
                      'embalagem': _embalagemSelecionada,
                      'quantidade': _quantidadeSelecionada,
                    };

                    Navigator.pop(context, produto);
                  }
                },
                child: Text('Cadastrar Produto'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}