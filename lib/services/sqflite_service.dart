import 'package:sqflite/sqflite.dart';
import 'package:stock_manager/models/item.dart';

class SqfliteService {
  static Database? _database;
  static const String dbName = 'stock_manager.db';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();
    String dbPath = '$path/$dbName';
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE stocks(
            id TEXT PRIMARY KEY,
            name TEXT,
            count INTEGER,
            image TEXT,
            timeStamp TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE sales(
            id TEXT PRIMARY KEY,
            name TEXT,
            count INTEGER,
            image TEXT,
            status TEXT,
            timeStamp TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE buys(
            id TEXT PRIMARY KEY,
            name TEXT,
            count INTEGER,
            image TEXT,
            status TEXT,
            timeStamp TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE reports(
            id TEXT PRIMARY KEY,
            name TEXT,
            count INTEGER,
            image TEXT,
            status TEXT,
            timeStamp TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertItem(String table, Item item) async {
    final db = await database;
    await db.insert(
      table,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Item>> getAllItems(String table, {String? searchTerm}) async {
    final db = await database;
    late List<Map<String, dynamic>> maps;
    if (searchTerm != null && searchTerm.isNotEmpty) {
      maps = await db.query(
        table,
        where: 'name LIKE ?',
        whereArgs: ['%$searchTerm%'],
      );
    } else {
      maps = await db.query(table);
    }
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<void> updateItem(String table, Item item) async {
    final db = await database;
    await db.update(
      table,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteItem(String table, String id) async {
    final db = await database;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}