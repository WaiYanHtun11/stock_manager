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
          CREATE TABLE refills(
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

  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  Future<List<Item>> fetchPaginatedItems(
      String table, int limit, int offset) async {
    final db = await database;
    // Fetch data with pagination
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $table ORDER BY timeStamp DESC LIMIT $limit OFFSET $offset');

    // Convert List<Map<String, dynamic>> to List<Item>
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<int> getTotalRowCount(String table) async {
    final db = await database;
    // Get the total count of rows in the table
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM $table');
    int? count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }
}
