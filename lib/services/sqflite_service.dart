

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'items.db';

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
          CREATE TABLE InStock(
            id TEXT PRIMARY KEY,
            name TEXT,
            count INTEGER,
            image TEXT,
            timeStamp TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Sell(
            id TEXT PRIMARY KEY,
            name TEXT,
            count INTEGER,
            image TEXT,
            timeStamp TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Buy(
            id TEXT PRIMARY KEY,
            name TEXT,
            count INTEGER,
            image TEXT,
            timeStamp TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Report(
            id TEXT PRIMARY KEY,
            name TEXT,
            count INTEGER,
            image TEXT,
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

  Future<List<Item>> getAllItems(String table) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
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