import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/firestore_service.dart';
import 'package:stock_manager/services/sqflite_service.dart';

class DatabaseService {
  final FirestoreService _firestoreService = FirestoreService();
  final SqfliteService _sqfliteService = SqfliteService();

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
  Future<void> addItem(Item item, String table) async{
    await _firestoreService.createItem('transactions', item.toMap());
    await _sqfliteService.insertItem(table, item);
  }

  // Update item in both Firestore and SQLite
  Future<void> updateItem(Item item , String table) async {
    await _firestoreService.updateItem('transactions', item.id, item.toMap());
    await _sqfliteService.updateItem(table, item);
  }

  // Add transaction and update stock in both Firestore and SQLite
  Future<void> addTransaction(Item stock, Item item) async{
    int count = 0;
    if(item.status == 'sale'){
      count = stock.count - item.count;
      addItem(item, 'sales');
    } else{
      count = stock.count + item.count;
      addItem(item, 'buys');
    }
    stock.count = count;
    updateStock(stock);
  }

  // Update transaction and stock in both Firestore and SQLite
  Future<void> updateTransaction(Item stock, Item item , int difference) async{
    // Difference : new - old
    int count = 0;
    if(item.status == 'sale'){
      count = stock.count - difference;
    }else{
      count = stock.count + difference;
    }
    stock.count = count;
    updateStock(item);
  }
  
  Future<List<Map<String, dynamic>>> fetchFromFirebase(String collection, String isoTimestamp) async{
    return await _firestoreService.getItems(collection, isoTimestamp);
  }

  Future<List<Map<String,dynamic>>> fetchItemsLessThan() async{
    return await _firestoreService.getItemsLessThan('stocks', 12);
  }
 
  Future<List<Item>> fetchFromLocalDB(String table, {String? searchTerm}) async {
    return await _sqfliteService.getAllItems(table, searchTerm: searchTerm);
  }
  
}
