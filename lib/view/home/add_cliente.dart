import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NovoClientePage extends StatelessWidget {
  const NovoClientePage({super.key});

  Widget _buildCampo(String label, {int maxLines = 1}) {
    return TextFormField(
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
              Text('Novo Cliente', style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
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
        child: Column(
          children: [
            _buildCampo('* Nome'),
            const SizedBox(height: 12),
            _buildCampo('Apelido'),
            const SizedBox(height: 12),
            _buildCampo('Telefone'),
            const SizedBox(height: 12),
            _buildCampo('CPF\\CNPJ'),
            const SizedBox(height: 24),

            const Divider(thickness: 1),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Endereço', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700])),
              ),
            ),
            const Divider(thickness: 1),

            Row(
              children: [
                Expanded(child: _buildCampo('CEP')),
                const SizedBox(width: 8),
                SizedBox(width: 80, child: _buildCampo('Nº')),
              ],
            ),
            const SizedBox(height: 12),
            _buildCampo('Logradouro'),
            const SizedBox(height: 12),
            _buildCampo('Bairro'),
            const SizedBox(height: 12),
            _buildCampo('Município'),
            const SizedBox(height: 12),
            _buildCampo('Ponto de referência'),
            const SizedBox(height: 12),
            _buildCampo('Observações', maxLines: 3),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
