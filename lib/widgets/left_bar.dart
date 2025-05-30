// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Dados da Empresa'),
          ),
          ListTile(
            title: Text('Produtos'),
          ),
          ListTile(
            title: Text('Sincronização'),
          ),
          ListTile(
            title: Text('Usuários Cadastrados'),
          ),
          ListTile(
            title: Text('Restrições de Acesso'),
          ),
          ListTile(
            title: Text('Notas Fiscais'),
          ),
          ListTile(
            title: Text('Boletos Bancários'),
          ),
          ListTile(
            title: Text('Cupons Fiscais'),
          ),
        ],
      ),
    );
  }
}
