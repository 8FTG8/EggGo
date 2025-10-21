import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/widgets/header.dart';

import '../models/produto_model.dart';

import '../notifiers/controller_produto.dart';

import '../services/service_produto.dart';

class NovoProduto extends StatefulWidget {
  static const routeName = 'NovoProduto';
  const NovoProduto({super.key});

  @override
  _NovoProdutoState createState() => _NovoProdutoState();
}

class _NovoProdutoState extends State<NovoProduto> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _codigoController = TextEditingController();
  final _duzController = TextEditingController();
  String? _corSelecionado;
  String? _tamanhoSelecionado;
  String? _embalagemSelecionada;
  String? _quantidadeSelecionada;

  // Opções para os dropdowns
  static const List<String> _cores = [
    'Branco',
    'Vermelho',
    'Codorna',
    'Caipira'
  ];
  static const List<String> _tamanhos = [
    'Médio',
    'Grande',
    'Extra',
    'Jumbo',
    'Não aplicável'
  ];
  static const List<String> _embalagens = [
    'Estojo',
    'Granel',
    'PVC',
    'Conserva',
    'Não aplicável'
  ];
  static const List<String> _unidades = [
    'CX',
    'Dúzia',
    'Cart. 30',
    'Cart. 20',
    '1kg',
    '0.5kg'
  ];

  void _atualizarDuzias(String? unidadeSelecionada) {
    double duzias = 0.0;
    switch (unidadeSelecionada) {
      case 'CX':
        duzias = 30.0; // Caixa com 360 ovos = 30 dúzias
        break;
      case 'Dúzia':
        duzias = 1.0; // 12 ovos = 1 dúzia
        break;
      case 'Cart. 30':
        duzias = 2.5; // 30 ovos = 2.5 dúzias
        break;
      default:
        duzias = 0.0; // Não aplicável para kg ou outros
        break;
    }
    _duzController.text = duzias.toStringAsFixed(2);
  }

  Future<void> _salvarProduto() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isLoading = true);

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final nomeParts = [
      _corSelecionado,
      if (_tamanhoSelecionado != 'Não aplicável') _tamanhoSelecionado,
      if (_embalagemSelecionada != 'Não aplicável') _embalagemSelecionada,
      _quantidadeSelecionada,
    ];
    final nomeCompleto = nomeParts.where((p) => p != null).join(' ');
    final produto = Produto(
      codigo: '#${_codigoController.text.trim()}',
      nome: nomeCompleto,
      cor: _corSelecionado!,
      tamanho: _tamanhoSelecionado!,
      embalagem: _embalagemSelecionada!,
      tipoQuantidade: _quantidadeSelecionada!,
      duz: double.tryParse(_duzController.text.replaceAll(',', '.')) ?? 0.0,
    );

    try {
      await Provider.of<ProdutoController>(context, listen: false)
          .adicionarProduto(produto);

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Produto salvo com sucesso!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
        navigator.pop();
      }
    } on ProdutoDuplicadoException catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        String errorMessage =
            'Ocorreu um erro ao salvar no Firebase: ${e.message}';
        if (e.code == 'permission-denied') {
          errorMessage =
              'Erro de permissão. Verifique as Regras de Segurança do Firestore no console do Firebase.';
        }
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Ocorreu um erro inesperado ao salvar: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _duzController.dispose();
    super.dispose();
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Selecione uma opção!' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(
          pageTitle: 'Cadastrar Produto', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                    labelText: '* Código', prefixText: '#'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira o código!';
                  }
                  if (value.trim().length != 2) {
                    return 'O código deve ter 2 dígitos.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                value: _corSelecionado,
                label: '* Tipo',
                items: _cores,
                onChanged: (String? newValue) {
                  setState(() => _corSelecionado = newValue);
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                value: _tamanhoSelecionado,
                label: '* Tamanho',
                items: _tamanhos,
                onChanged: (String? newValue) {
                  setState(() => _tamanhoSelecionado = newValue);
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                value: _embalagemSelecionada,
                label: '* Embalagem',
                items: _embalagens,
                onChanged: (String? newValue) {
                  setState(() => _embalagemSelecionada = newValue);
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                value: _quantidadeSelecionada,
                label: '* Unidade',
                items: _unidades,
                onChanged: (String? newValue) {
                  setState(() {
                    _quantidadeSelecionada = newValue;
                    _atualizarDuzias(newValue);
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _salvarProduto,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 3))
                    : Text('Salvar produto',
                        style: GoogleFonts.inter(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
