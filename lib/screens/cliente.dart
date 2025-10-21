import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cliente_add.dart';
import '../core/widgets/header.dart';
import '../models/cliente_model.dart';
import '../notifiers/controller_cliente.dart';

class Clientes extends StatefulWidget {
  static const routeName = 'ClientePage';
  const Clientes({super.key});

  @override
  _ClientesState createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(pageTitle: 'Clientes', showBackButton: true),
      body: Consumer<ClienteController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.clientes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final allClientes = controller.clientes;
          final searchQuery = _searchController.text.toLowerCase();
          final filteredClientes = allClientes.where((cliente) {
            final nome = cliente.nome.toLowerCase();
            final apelido = cliente.apelido?.toLowerCase() ?? '';
            return nome.contains(searchQuery) || apelido.contains(searchQuery);
          }).toList();
          if (controller.clientes.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum cliente cadastrado.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  onChanged: (value) => setState(() {}),
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nome ou apelido',
                    isDense: true,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: filteredClientes.isEmpty
                    ? const Center(
                        child: Text('Nenhum cliente encontrado.',
                            style: TextStyle(fontSize: 16)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        itemCount: filteredClientes.length,
                        itemBuilder: (context, index) {
                          final cliente = filteredClientes[index];
                          return Dismissible(
                            key: ValueKey(cliente.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Theme.of(context).colorScheme.primary,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 4),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.delete,
                                  color: Theme.of(context).colorScheme.onError),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirmar Exclusão"),
                                    content: Text(
                                        "Tem certeza que deseja excluir o cliente \"${cliente.nome}\"?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("Cancelar")),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .error),
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("Excluir"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) {
                              Provider.of<ClienteController>(context,
                                      listen: false)
                                  .deletarCliente(cliente.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Cliente "${cliente.nome}" excluído.'),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 4),
                              child: ListTile(
                                leading: Icon(
                                  cliente.tipoPessoa == TipoPessoa.fisica
                                      ? Icons.person
                                      : Icons.business,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 32,
                                ),
                                title: Text(
                                  cliente.nome,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    size: 16),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, NovoCliente.routeName,
                                      arguments: cliente);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      // BOTÃO DE CADASTRO \\
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NovoCliente.routeName);
        },
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
