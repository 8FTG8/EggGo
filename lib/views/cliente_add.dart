import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/cliente_controller.dart';
import '../models/cliente_model.dart';
import '../core/utils/validators.dart';
import '../core/constants/app_colors.dart';
import '../core/widgets/header.dart';

class NovoCliente extends StatefulWidget {
  static const routeName = 'NovoClientePage';
  const NovoCliente({super.key});

  @override
  _NovoClienteState createState() => _NovoClienteState();
}

class _NovoClienteState extends State<NovoCliente> with MixinValidations {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _apelidoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _municipioController = TextEditingController();
  final _observacoesController = TextEditingController();

  void _salvarCliente() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
      setState(() => _isLoading = true);

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
      final cliente = Cliente(
        nome: _nomeController.text.trim(),
        apelido: _apelidoController.text.nullIfEmpty,
        telefone: _telefoneController.text.nullIfEmpty,
        cpfCnpj: _cpfCnpjController.text.nullIfEmpty,
        cep: _cepController.text.nullIfEmpty,
        numero: _numeroController.text.nullIfEmpty,
        logradouro: _logradouroController.text.nullIfEmpty,
        bairro: _bairroController.text.nullIfEmpty,
        municipio: _municipioController.text.nullIfEmpty,
        observacoes: _observacoesController.text.nullIfEmpty,
      );

      try {
        await Provider.of<ClienteController>(context, listen: false)
            .adicionarCliente(cliente);
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Cliente salvo com sucesso!')),
          );
          navigator.pop();
        }
      } catch (e) {
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Erro ao salvar cliente: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
      }
    }
  }
  
  Widget _buildCampo(String label, TextEditingController controller, {int maxLines = 1, FormFieldValidator<String>? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _apelidoController.dispose();
    _telefoneController.dispose();
    _cpfCnpjController.dispose();
    _cepController.dispose();
    _numeroController.dispose();
    _logradouroController.dispose();
    _bairroController.dispose();
    _municipioController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(pageTitle: 'Cadastrar Cliente', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCampo('* Nome', _nomeController, validator: (value) => isEmpty(value, 'Este campo é obrigatório!')),
              const SizedBox(height: 12),

              _buildCampo('Apelido', _apelidoController),
              const SizedBox(height: 12),

              _buildCampo('Telefone', _telefoneController, validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (cleaned.length < 10 || cleaned.length > 11) {
                    return 'Telefone inválido. Use (DD) XXXXX-XXXX';
                  }
                }
                return null;
              }),
              const SizedBox(height: 12),
              _buildCampo('CPF\\CNPJ', _cpfCnpjController, validator: (value) {
                if (value == null || value.isEmpty) return null; // Se for opcional
                final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (digitsOnly.length == 11) return validateCPF(value);
                if (digitsOnly.length == 14) return validateCNPJ(value);
                return 'CPF ou CNPJ inválido';
              }),

              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('Endereço', 
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              
              const Divider(thickness: 1),
              Row(
                children: [
                  Expanded(child: _buildCampo('CEP', _cepController)),
                  const SizedBox(width: 8),
                  SizedBox(width: 80, child: _buildCampo('Nº', _numeroController)),
                ],
              ),
              const SizedBox(height: 12),
              _buildCampo('Logradouro', _logradouroController),
              const SizedBox(height: 12),
              _buildCampo('Bairro', _bairroController),
              const SizedBox(height: 12),
              _buildCampo('Município', _municipioController),
              const SizedBox(height: 12),
              _buildCampo('Observações', _observacoesController, maxLines: 5),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _salvarCliente,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text('Salvar Cliente', style: GoogleFonts.inter(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String {
  get nullIfEmpty => null;
}