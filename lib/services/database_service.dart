import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/firestore_service.dart';
import 'package:stock_manager/services/sqflite_service.dart';

class DatabaseService {
  final FirestoreService _firestoreService = FirestoreService();
  final SqfliteService _sqfliteService = SqfliteService();

  Future<void> syncData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final stocksTimeStamp = prefs.getString('stocks') ?? '';
    final reportsTimeStamp = prefs.getString('reports') ?? '';
    print(stocksTimeStamp);
    // Update the local stocks to sync with firestore
    final stocks = await _firestoreService.getItems('stocks', stocksTimeStamp);
    for (Item stock in stocks) {
      _sqfliteService.insertItem('stocks', stock);
    }
    prefs.setString('stocks', DateTime.now().toIso8601String());

    // Update the local reports to sync with the firestore
    final transactions =
        await _firestoreService.getItems('transactions', reportsTimeStamp);
    for (Item transaction in transactions) {
      _sqfliteService.insertItem('reports', transaction);
    }
    prefs.setString('reports', DateTime.now().toIso8601String());
  }

  Future<void> syncStocks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final stocksTimeStamp = prefs.getString('stocks') ?? '';

    // Update the local stocks to sync with firestore
    final stocks = await _firestoreService.getItems('stocks', stocksTimeStamp);

    for (Item stock in stocks) {
      _sqfliteService.insertItem('stocks', stock);
    }

    prefs.setString('stocks', DateTime.now().toIso8601String());
    print(stocksTimeStamp);
  }

  Future<void> syncReports() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final reportsTimeStamp = prefs.getString('reports') ?? '';

    // Update the local reports to sync with the firestore
    final transactions =
        await _firestoreService.getItems('transactions', reportsTimeStamp);
    for (Item transaction in transactions) {
      _sqfliteService.insertItem('reports', transaction);
    }
    prefs.setString('reports', DateTime.now().toIso8601String());
  }

  // Add stock to both Firestore and SQLite
  Future<void> addStock(Item item) async {
    await _firestoreService.createItem('stocks', item.toStocksMap());
    await _sqfliteService.insertItem('stocks', item);
  }

  // Update stock in both Firestore and SQLite
  Future<void> updateStock(Item item) async {
    await _firestoreService.updateItem('stocks', item.id, item.toStocksMap());
    await _sqfliteService.updateItem('stocks', item);
  }

  // Update count in both Firestore and SQLite
  Future<void> updateStockCount(String id, int count) async {
    try {
      await _firestoreService.updateItem('stocks', id,
          {'count': count, 'timeStamp': DateTime.now().toIso8601String()});
      await _sqfliteService.updateCount('stocks', id, count);
    } catch (e) {
      // Absorb the error
      print('error occurs in updating count');
    }
  }

  Future<void> updateTransactionCount(
      String table, String id, int count) async {
    await _sqfliteService.updateCount(table, id, count);
  }

  // Add item to both Firestore and SQLite
  Future<void> addItem(Item item, String table) async {
    await _firestoreService.createItem(
        'transactions', item.toTransactionsMap());
    await _sqfliteService.insertItem(table, item);
    await _sqfliteService.insertItem('reports', item);
  }

  // Update item in both Firestore and SQLite
  Future<void> updateItem(Item item, String table) async {
    await _firestoreService.updateItem(
        'transactions', item.id, item.toTransactionsMap());
    await _sqfliteService.updateItem(table, item);
  }

  // Add transaction and update stock in both Firestore and SQLite
  Future<void> addTransaction(Item stock, Item item) async {
    int count = 0;
    if (item.status == 'sale') {
      count = stock.count - item.count;
      await addItem(item, 'sales');
    } else {
      count = stock.count + item.count;
      await addItem(item, 'refills');
    }
    stock.count = count;
    // Update only the count
    await updateStockCount(stock.id, count);
  }

  // Update transaction and stock in both Firestore and SQLite
  Future<void> updateTransaction(String sid, Item item, int difference) async {
    // Difference : new - old
    String id = item.id;
    int count = 0;
    int inStock = await _sqfliteService.getCountOfStockById(sid);
    print('in stock : $inStock');
    print('difference : $difference');
    await _firestoreService.updateItem('transactions', id,
        {'count': item.count, 'timeStamp': DateTime.now().toIso8601String()});
    if (item.status == 'sale') {
      count = inStock - difference;
      await updateTransactionCount('sales', id, item.count);
    } else {
      count = inStock + difference;
      await updateTransactionCount('refills', id, item.count);
    }
    await updateTransactionCount('reports', id, item.count);
    print('final count : $count');
    await updateStockCount(sid, count);
  }

  Future<List<Item>> fetchFromFirebase(
      String collection, String isoTimestamp) async {
    return await _firestoreService.getItems(collection, isoTimestamp);
  }

  Future<List<Item>> fetchItemsLessThan(int i) async {
    return await _firestoreService.getItemsLessThan('stocks', 12);
  }

  Future<List<Item>> fetchFromLocalDB(String table,
      {String? searchTerm}) async {
    return await _sqfliteService.getAllItems(table, searchTerm: searchTerm);
  }

  Future<List<Item>> fetchPaginatedItems(
      String table, int limit, int offset) async {
    return await _sqfliteService.fetchPaginatedItems(table, limit, offset);
  }

  Future<int> getTotalRowCount(String table) async {
    return await _sqfliteService.getTotalRowCount(table);
  }

  Future<Item?> getStockById(String id) async {
    return await _sqfliteService.getStockById(id);
  }

  Future<void> clearTransactions(String table) async {
    await _sqfliteService.clearTable(table);
  }

  Future<bool> isOutofStock(String table) async {
    return await _sqfliteService.isTableEmpty(table);
  }

  Future<void> deleteStock(String id) async {
    await _firestoreService.deleteItem('stocks', id);
    await _sqfliteService.deleteItem('stocks', id);
  }
}
