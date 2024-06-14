import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'transaction.dart' as txn;

const String tableTransactions = 'transactions';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnAmount = 'amount';
const String columnDate = 'date';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static const _databaseName = "transactionsDB.db";

  static const _databaseVersion = 1;

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

 
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);


    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableTransactions (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnAmount REAL NOT NULL,
            $columnDate TEXT NOT NULL
          )
          ''');
  }

 

  Future<int> insert(txn.Transaction element) async {
    Database? db = await database;
    int id = await db!.insert(tableTransactions, element.toMap());
    return id;
  }

  Future<txn.Transaction?> getTransactionById(int id) async {
    Database? db = await database;
    List<Map<String, dynamic>> res = await db!.query(tableTransactions,
        columns: [columnId, columnTitle, columnAmount, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (res.isNotEmpty) {
      return txn.Transaction.fromMap(res.first);
    }
    return null;
  }

  Future<List<txn.Transaction>> getAllTransactions() async {
    Database? db = await database;
    List<Map<String, dynamic>> res = await db!.query(tableTransactions,
        columns: [columnId, columnTitle, columnAmount, columnDate]);

    List<txn.Transaction> list =
        res.map((e) => txn.Transaction.fromMap(e)).toList();

    return list;
  }

  Future<int> deleteTransactionById(int id) async {
    Database? db = await database;
    int res = await db!
        .delete(tableTransactions, where: "$columnId = ?", whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllTransactions() async {
    Database? db = await database;
    int res = await db!.delete(tableTransactions);
    return res;
  }


}
