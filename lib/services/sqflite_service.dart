import 'package:sqflite/sqflite.dart';
import 'package:stock_manager/models/item.dart';

class SqfliteService {
  static final SqfliteService _instance = SqfliteService._internal();

  factory SqfliteService() {
    return _instance;
  }

  SqfliteService._internal();

  static Database? _database;
  static const String dbName = 'stock_manager.db';

  Future<Database> getDatabase() async {
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
        // Create tables if they don't exist
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // Create tables if they don't exist
    await db.execute('''
    CREATE TABLE IF NOT EXISTS stocks(
      id TEXT PRIMARY KEY,
      name TEXT,
      count INTEGER,
      image TEXT,
      location TEXT,
      date TEXT,
      timeStamp TEXT,
      note TEXT 
    )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS sales(
      id TEXT PRIMARY KEY,
      name TEXT,
      count INTEGER,
      image TEXT,
      status TEXT,
      sid TEXT,
      date TEXT,
      timeStamp TEXT,
      note TEXT 
    )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS refills(
      id TEXT PRIMARY KEY,
      name TEXT,
      count INTEGER,
      image TEXT,
      status TEXT,
      sid TEXT,
      date TEXT,
      timeStamp TEXT,
      note TEXT 
    )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS reports(
      id TEXT PRIMARY KEY,
      name TEXT,
      count INTEGER,
      image TEXT,
      status TEXT,
      sid TEXT,
      date TEXT,
      timeStamp TEXT,
      note TEXT 
    )
  ''');
  }

  Future<void> insertItem(String table, Item item) async {
    final db = await getDatabase();
    if (table == 'stocks') {
      await db.insert(
        table,
        item.toStocksMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.insert(
        table,
        item.toTransactionsMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Item>> getAllItems(String table, {String? searchTerm}) async {
    final db = await getDatabase();
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

  Future<int> getCountOfStockById(String id) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> result = await db.query('stocks',
        columns: ['count'], where: 'id = ?', whereArgs: [id]);

    // If the query returns a result, return the count value
    if (result.isNotEmpty) {
      return result.first['count'] as int;
    } else {
      // If no result is found, return a default value, like -1 or 0
      return 0;
    }
  }

  Future<Item?> getStockById(String id) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> result = await db.query(
      'stocks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Item.fromMap(result.first);
    }
    return null;
  }

  Future<void> updateCount(String table, String id, int count) async {
    final db = await getDatabase();
    await db.update(
      table,
      {'count': count},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateItem(String table, Item item) async {
    final db = await getDatabase();
    if (table == 'stocks') {
      await db.update(
        table,
        item.toStocksMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      );
    } else {
      await db.update(
        table,
        item.toTransactionsMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      );
    }
  }

  Future<void> deleteItem(String table, String id) async {
    final db = await getDatabase();
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearTable(String table) async {
    final db = await getDatabase();
    await db.delete(table);
  }

  Future<List<Item>> fetchPaginatedItems(
      String table, int limit, int offset) async {
    final db = await getDatabase();
    // Fetch data with pagination
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $table ORDER BY date DESC LIMIT $limit OFFSET $offset');

    // Convert List<Map<String, dynamic>> to List<Item>
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<int> getTotalRowCount(String table) async {
    final db = await getDatabase();
    // Get final db = await getDatabase(); the total count of rows in the table
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM $table');
    int? count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }

  Future<int> getTotalCount() async {
    final db = await getDatabase();
    // Execute the query to get the sum of the count field
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT SUM(count) as total FROM stocks');

    // Get the total from the result
    int totalCount = result.first['total'] ?? 0;

    return totalCount;
  }

  Future<bool> isTableEmpty(String table) async {
    final db = await getDatabase();
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM $table');
    int? count = Sqflite.firstIntValue(result);
    return count != 0;
  }
}
