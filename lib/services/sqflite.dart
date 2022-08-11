import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/utils/utils.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const table = "my_table";

  static const columnId = "id";
  static const columnTitle = "birdName";
  static const columnDescription = "birdDescription";
  static const columnUrl = "url";
  static const longitude = "longitude";
  static const latitude = "latitude";

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static sql.Database? _db;

  Future<sql.Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper._internal();

  initDb() async {
    final dbPath = await sql.getDatabasesPath();

    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String db_path = path.join(documentsDirectory.path, _databaseName);
    String _path = path.join(dbPath, _databaseName);

    // open if found, create if not found for db
    return await sql.openDatabase(_path, version: _databaseVersion, onCreate: _onCreate);
  }

Future<void> _onCreate(sql.Database db, int version) async {
  await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnTitle TEXT NOT NULL,
      $columnDescription TEXT NOT NULL,
      $columnUrl TEXT NOT NULL,
      $latitude REAL NOT NULL,
      $longitude REAL NOT NULL
    )

    ''');
}

  Future<int?> insert(Map<String, dynamic> row) async {
    final dbClient = await db;

    return await dbClient!
        .insert(table, row, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  /// update data in db
  /// @param table: the name of the table to be updated
  /// @param data: data map to be updated
  // Future<void> update(String table, Map<String, Object> data) async {
  //   final dbClient = await db;
  //   dbClient?.update(table, data);
  // }

  Future<int?> queryRowCount() async {
    final dbClient = await db;
    return firstIntValue(
        await dbClient!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    final dbClient = await db;
    int id = row[columnId];
    return await dbClient!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>?> queryAllRows() async {
    final dbClient = await db;

    return await dbClient!.query(table);
  }

  Future<int> delete(int id) async {
    final dbClient = await db;

    return await dbClient!
        .delete(table, where: "$columnId = ?", whereArgs: [id]);
  }

  /// clear database
  Future clear() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase(dbPath);
  }
}

