import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cliente_add.dart';
import '../core/constants/app_colors.dart';
import '../core/widgets/header.dart';
import '../controllers/cliente_controller.dart';

class Clientes extends StatefulWidget {
  static const routeName = 'ClientePage';
  const Clientes({super.key});

  @override
  _ClientesState createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(pageTitle: 'Clientes', showBackButton: true),
      body: Consumer<ClienteController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.clientes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.clientes.isEmpty) {
            return const Center(
              child: Text('Nenhum cliente cadastrado.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: controller.clientes.length,
            itemBuilder: (context, index) {
              final cliente = controller.clientes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: ListTile(
                  title: Text(cliente.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(cliente.telefone ?? cliente.municipio ?? 'Sem informações adicionais'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Implementar navegação para a tela de detalhes do cliente
                  },
                ),
              );
            },
          );
        },
      ),

      // BOTÃO DE CADASTRO \\
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NovoCliente()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}