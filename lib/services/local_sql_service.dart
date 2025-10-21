import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/venda_model.dart';
import '../models/cliente_model.dart';
import '../models/produto_model.dart';

class LocalStorageService {
  static final LocalStorageService instance = LocalStorageService._init();
  static Database? _database;
  LocalStorageService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const textTypeNullable = 'TEXT';

    await db.execute('''
      CREATE TABLE pending_vendas ( 
        id $idType, 
        uuid $textType,
        cliente $textType,
        produtos $textType,
        total $realType,
        data $textType,
        metodoPagamento $textTypeNullable
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_clientes (
        id $idType,
        uuid $textType,
        tipoPessoa $textType,
        nome $textType,
        apelido $textTypeNullable,
        email $textTypeNullable,
        telefone $textTypeNullable,
        cpf $textTypeNullable,
        cnpj $textTypeNullable,
        inscricaoEstadual $textTypeNullable,
        cep $textTypeNullable,
        logradouro $textTypeNullable,
        numero $textTypeNullable,
        complemento $textTypeNullable,
        bairro $textTypeNullable,
        cidade $textTypeNullable,
        uf $textTypeNullable,
        observacoes $textTypeNullable
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_produtos (
        id $idType,
        uuid $textType,
        codigo $textType,
        nome $textType,
        cor $textType,
        tamanho $textType,
        embalagem $textType,
        tipoQuantidade $textType,
        duz $realType
      )
    ''');
  }

  // --- MÉTODOS PARA VENDAS ---

  Future<void> addPendingVenda(Venda venda) async {
    final db = await instance.database;
    await db.insert('pending_vendas', venda.toDbMap());
  }

  Future<List<Map<String, dynamic>>> getPendingVendas() async {
    final db = await instance.database;
    return db.query('pending_vendas', orderBy: 'id ASC');
  }

  Future<void> deletePendingVenda(int id) async {
    final db = await instance.database;
    await db.delete(
      'pending_vendas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- MÉTODOS PARA CLIENTES ---

  Future<void> addPendingCliente(Cliente cliente) async {
    final db = await instance.database;
    await db.insert('pending_clientes', cliente.toDbMap());
  }

  Future<List<Map<String, dynamic>>> getPendingClientes() async {
    final db = await instance.database;
    return db.query('pending_clientes', orderBy: 'id ASC');
  }

  Future<void> deletePendingCliente(int id) async {
    final db = await instance.database;
    await db.delete('pending_clientes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> upsertPendingCliente(Cliente cliente) async {
    final db = await instance.database;
    final existing = await db.query(
      'pending_clientes',
      where: 'uuid = ?',
      whereArgs: [cliente.id],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      await db.update(
        'pending_clientes',
        cliente.toDbMap(),
        where: 'uuid = ?',
        whereArgs: [cliente.id],
      );
    } else {
      await db.insert('pending_clientes', cliente.toDbMap());
    }
  }

  // --- MÉTODOS PARA PRODUTOS ---

  Future<void> addPendingProduto(Produto produto) async {
    final db = await instance.database;
    await db.insert('pending_produtos', produto.toDbMap());
  }

  Future<List<Map<String, dynamic>>> getPendingProdutos() async {
    final db = await instance.database;
    return db.query('pending_produtos', orderBy: 'id ASC');
  }

  Future<void> deletePendingProduto(int id) async {
    final db = await instance.database;
    await db.delete('pending_produtos', where: 'id = ?', whereArgs: [id]);
  }

  /// Tenta deletar um item pendente de uma tabela pelo seu UUID.
  /// Retorna `true` se um item foi encontrado e deletado, `false` caso contrário.
  Future<bool> deletePendingByUuid(String tableName, String uuid) async {
    final db = await instance.database;
    final count = await db.delete(
      tableName,
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return count > 0;
  }

  // -- FECHA O BANCO DE DADOS --
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
