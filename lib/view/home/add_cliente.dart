import 'package:app_frontend/validators/mixin_validations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    _telefoneController.dispose();
    _cpfCnpjController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackButton(color: Colors.black),
              Text('Novo Cliente', 
                style: GoogleFonts.inter(
                  color: Colors.black, 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Lógica para importar contatos do celular
                    },
                    icon: const Icon(Icons.import_contacts, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {
                      // Finalizar cadastro
                    },
                    icon: const Icon(Icons.check, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCampo('* Nome', _nomeController),
              const SizedBox(height: 12),
              _buildCampo('Apelido', _apelidoController),
              const SizedBox(height: 12),
              _buildCampo('Telefone', _telefoneController),
              const SizedBox(height: 12),
              _buildCampo('CPF\\CNPJ', _cpfCnpjController),
              const SizedBox(height: 24),
          
              const Divider(thickness: 1),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
