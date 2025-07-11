import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../validators/mixin_validations.dart';

import 'package:egg_go/utilis/app_colors.dart';
import 'package:egg_go/widgets/header.dart';

class NovoClientePage extends StatefulWidget {
  const NovoClientePage({super.key});

  @override
  _NovoClientePageState createState() => _NovoClientePageState();
}

class _NovoClientePageState extends State<NovoClientePage> with MixinValidations {
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

  // TODO: Implementar a lógica para salvar o cliente no Firebase
  void _salvarCliente() {
    if (_formKey.currentState!.validate()) {
      // Lógica para obter os dados dos controllers e salvar no Firebase
      print('Formulário válido. Salvando cliente...');
      // Exemplo: String nome = _nomeController.text;
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
      appBar: const CustomHeader(pageTitle: 'Novo Cliente'),

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
                // TODO: Criar uma validação mais robusta para telefone no MixinValidations
                // Exemplo simples:
                // if (value != null && value.isNotEmpty && value.length < 10) {
                //   return 'Telefone inválido';
                // }
                return null; // Por enquanto, sem validação específica
              }),
              const SizedBox(height: 12),
              _buildCampo('CPF\\CNPJ', _cpfCnpjController, validator: (value) {
                // TODO: Melhorar esta lógica para diferenciar CPF e CNPJ ou usar um validador combinado
                if (value == null || value.isEmpty) return null; // Se for opcional
                final isCpf = value.replaceAll(RegExp(r'[^0-9]'), '').length == 11;
                final isCnpj = value.replaceAll(RegExp(r'[^0-9]'), '').length == 14;
                if (isCpf) return validateCPF(value);
                if (isCnpj) return validateCNPJ(value);
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
              _buildCampo('Observações', _observacoesController),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _salvarCliente,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Salvar Cliente', style: GoogleFonts.inter(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}
