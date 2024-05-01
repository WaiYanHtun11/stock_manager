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
    await _firestoreService.createItem('stocks', item.toMap());
    await _sqfliteService.insertItem('stocks', item);
  }

  // Update stock in both Firestore and SQLite
  Future<void> updateStock(Item item) async {
    await _firestoreService.updateItem('stocks', item.id, item.toMap());
    await _sqfliteService.updateItem('stocks', item);
  }

  // Add item to both Firestore and SQLite
  Future<void> addItem(Item item, String table) async {
    await _firestoreService.createItem('transactions', item.toMap());
    await _sqfliteService.insertItem(table, item);
  }

  // Update item in both Firestore and SQLite
  Future<void> updateItem(Item item, String table) async {
    await _firestoreService.updateItem('transactions', item.id, item.toMap());
    await _sqfliteService.updateItem(table, item);
  }

  // Add transaction and update stock in both Firestore and SQLite
  Future<void> addTransaction(Item stock, Item item) async {
    int count = 0;
    if (item.status == 'sale') {
      count = stock.count - item.count;
      addItem(item, 'sales');
    } else {
      count = stock.count + item.count;
      addItem(item, 'refills');
    }
    stock.count = count;
    updateStock(stock);
  }

  // Update transaction and stock in both Firestore and SQLite
  Future<void> updateTransaction(Item stock, Item item, int difference) async {
    // Difference : new - old
    int count = 0;
    if (item.status == 'sale') {
      count = stock.count - difference;
      updateItem(item, 'sales');
    } else {
      count = stock.count + difference;
      updateItem(item, 'refills');
    }
    stock.count = count;
    updateStock(item);
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

  Future<void> clearTransactions(String table) async {
    await _sqfliteService.clearTable(table);
  }
}
