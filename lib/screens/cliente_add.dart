import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../core/utils/validators.dart';
import '../core/widgets/header.dart';

import '../models/cliente_model.dart';

import '../notifiers/controller_cliente.dart';

class NovoCliente extends StatefulWidget {
  static const routeName = 'NovoClientePage';
  final Cliente? cliente;
  const NovoCliente({super.key, this.cliente});

  @override
  _NovoClienteState createState() => _NovoClienteState();
}

class _NovoClienteState extends State<NovoCliente> with MixinValidations {
  bool _isLoading = false;
  bool _enderecoVisivel = false;
  TipoPessoa _tipoPessoa = TipoPessoa.fisica;
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _apelidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _ieController = TextEditingController();
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();
  final _observacoesController = TextEditingController();

  final _cepFocusNode = FocusNode();

  final _cepMask = MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  final _phoneMask = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final _cnpjMask = MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    _cepFocusNode.addListener(() {
      if (!_cepFocusNode.hasFocus) {
        _buscarCep();
      }
    });

    if (widget.cliente != null) {
      final c = widget.cliente!;
      _tipoPessoa = c.tipoPessoa;
      _nomeController.text = c.nome;
      _apelidoController.text = c.apelido ?? '';
      _emailController.text = c.email ?? '';
      _telefoneController.text = c.telefone ?? '';
      _cpfController.text = c.cpf ?? '';
      _cnpjController.text = c.cnpj ?? '';
      _ieController.text = c.inscricaoEstadual ?? '';
      _cepController.text = c.cep ?? '';
      _numeroController.text = c.numero ?? '';
      _complementoController.text = c.complemento ?? '';
      _logradouroController.text = c.logradouro ?? '';
      _bairroController.text = c.bairro ?? '';
      _cidadeController.text = c.cidade ?? '';
      _ufController.text = c.uf ?? '';
      _observacoesController.text = c.observacoes ?? '';
    }
  }

  Future<void> _buscarCep() async {
    final cep = _cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) return;

    setState(() => _isLoading = true);
    try {
      final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      if (response.data != null && response.data['erro'] != true) {
        _logradouroController.text = response.data['logradouro'] ?? '';
        _bairroController.text = response.data['bairro'] ?? '';
        _cidadeController.text = response.data['localidade'] ?? '';
        _ufController.text = response.data['uf'] ?? '';
        FocusScope.of(context)
            .requestFocus(FocusNode()); // Move o foco para o próximo campo
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar CEP.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  void _salvarCliente() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isLoading = true);

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final cliente = Cliente(
      id: widget.cliente?.id,
      tipoPessoa: _tipoPessoa,
      nome: _nomeController.text.trim(),
      apelido: _apelidoController.text.nullIfEmpty,
      email: _emailController.text.nullIfEmpty,
      telefone: _telefoneController.text.nullIfEmpty,
      cpf: _tipoPessoa == TipoPessoa.fisica ? _cpfController.text.nullIfEmpty : null,
      cnpj: _tipoPessoa == TipoPessoa.juridica ? _cnpjController.text.nullIfEmpty : null,
      inscricaoEstadual: _tipoPessoa == TipoPessoa.juridica ? _ieController.text.nullIfEmpty : null,
      cep: _cepController.text.nullIfEmpty,
      logradouro: _logradouroController.text.nullIfEmpty,
      numero: _numeroController.text.nullIfEmpty,
      complemento: _complementoController.text.nullIfEmpty,
      bairro: _bairroController.text.nullIfEmpty,
      cidade: _cidadeController.text.nullIfEmpty,
      uf: _ufController.text.nullIfEmpty,
      observacoes: _observacoesController.text.nullIfEmpty,
    );

    try {
      final clienteController =
          Provider.of<ClienteController>(context, listen: false);
      if (widget.cliente == null) {
        await clienteController.adicionarCliente(cliente);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Cliente salvo com sucesso!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      } else {
        await clienteController.atualizarCliente(cliente);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Cliente atualizado com sucesso!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }

      if (mounted) {
        navigator.pop();
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar cliente: $e'),
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

  Widget _buildCampo(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    FocusNode? focusNode,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  @override
  void dispose() {
    _cepFocusNode.dispose();
    _nomeController.dispose();
    _apelidoController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _cnpjController.dispose();
    _ieController.dispose();
    _cepController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _logradouroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _ufController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
          pageTitle:
              widget.cliente == null ? 'Cadastrar Cliente' : 'Editar Cliente',
          showBackButton: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<TipoPessoa>(
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor:
                          Theme.of(context).colorScheme.primary.withAlpha(51),
                      selectedForegroundColor:
                          Theme.of(context).colorScheme.primary,
                    ),
                    segments: const <ButtonSegment<TipoPessoa>>[
                      ButtonSegment<TipoPessoa>(
                        value: TipoPessoa.fisica,
                        label: Text('Pessoa Física'),
                        icon: Icon(Icons.person),
                      ),
                      ButtonSegment<TipoPessoa>(
                        value: TipoPessoa.juridica,
                        label: Text('Pessoa Jurídica'),
                        icon: Icon(Icons.business),
                      ),
                    ],
                    selected: {_tipoPessoa},
                    onSelectionChanged: (Set<TipoPessoa> newSelection) {
                      setState(() {
                        _tipoPessoa = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildCampo(
                      _tipoPessoa == TipoPessoa.fisica
                          ? '* Nome'
                          : '* Razão Social',
                      _nomeController,
                      validator: (value) =>
                          isEmpty(value, 'Este campo é obrigatório!')),
                  const SizedBox(height: 12),
                  _buildCampo(
                      _tipoPessoa == TipoPessoa.fisica
                          ? 'Apelido'
                          : 'Nome Fantasia',
                      _apelidoController),
                  const SizedBox(height: 12),
                  _buildCampo(
                    'E-mail',
                    _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        validateEmail(value, "Insira um e-mail válido"),
                  ),
                  const SizedBox(height: 12),
                  _buildCampo('Telefone', _telefoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [_phoneMask], validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !_phoneMask.isFill()) {
                      return 'Telefone inválido.';
                    }
                    return null;
                  }),
                  const SizedBox(height: 12),
                  if (_tipoPessoa == TipoPessoa.fisica)
                    _buildCampo(
                      'CPF',
                      _cpfController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [_cpfMask],
                      validator: (v) => validateCPF(v),
                    ),
                  if (_tipoPessoa == TipoPessoa.juridica) ...[
                    _buildCampo(
                      '* CNPJ',
                      _cnpjController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [_cnpjMask],
                      validator: (v) => validateCNPJ(v),
                    ),
                    const SizedBox(height: 12),
                    _buildCampo('Inscrição Estadual', _ieController),
                  ],
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _enderecoVisivel = !_enderecoVisivel;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Endereço',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                          Icon(
                            _enderecoVisivel
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, height: 1),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _enderecoVisivel
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Container(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildCampo(
                                  'CEP',
                                  _cepController,
                                  focusNode: _cepFocusNode,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [_cepMask],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: _buildCampo(
                                  'UF',
                                  _ufController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildCampo(
                                  'Cidade',
                                  _cidadeController,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: _buildCampo(
                                  'Nº',
                                  _numeroController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildCampo('Bairro', _bairroController),
                          const SizedBox(height: 12),
                          _buildCampo('Logradouro', _logradouroController),
                          const SizedBox(height: 12),
                          _buildCampo('Complemento', _complementoController),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _salvarCliente,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15)),
                    child: Text(
                      'Salvar Cliente',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(102),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white), // Mantém branco para contraste com overlay
                ),
              ),
            ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String? get nullIfEmpty {
    return trim().isEmpty ? null : this;
  }
}
