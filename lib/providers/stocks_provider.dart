import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/database_service.dart';

class StocksManager extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  late List<Item> _stocks;
  late int _currentPage;
  late int _totalPages;
  late bool _isLoading;

  StocksManager() {
    _stocks = [];
    _currentPage = 0;
    _totalPages = 0;
    _isLoading = false;
    fetchStocks();
  }

  List<Item> get stocks => _stocks;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;

  Future<void> fetchStocks({int page = 0, int limit = 12}) async {
    if (_isLoading || page > _totalPages) return;

    try {
      _isLoading = true;
      notifyListeners();

      final stocks = await _databaseService.fetchPaginatedItems(
          'stocks', limit, page * limit);
      _stocks.addAll(stocks);

      print(stocks.length);

      // Assuming you have a method in DatabaseService to get total number of stocks
      final totalStocks = await _databaseService.getTotalRowCount('stocks');
      _totalPages = (totalStocks / limit).ceil();

      _currentPage = page;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching stocks: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreStocks() async {
    if (_currentPage < _totalPages - 1 && !_isLoading) {
      await fetchStocks(page: _currentPage + 1);
    }
  }

  Future<void> addStock(Item item) async {
    // Sync local data with the firestore before adding
    await _databaseService.syncStocks();
    // Add item to the firebase and sqflite
    await _databaseService.addStock(item);
    // Update the in memory list
    stocks.add(item);
    notifyListeners();
  }

  Future<void> updateStock(Item item) async {
    // Sync local data with the firestore before updating
    await _databaseService.syncStocks();
    // Update item in firebase and sqflite
    await _databaseService.updateStock(item);
    // Update the in memory list
    final index = stocks.indexWhere((stock) => stock.id == item.id);
    if (index != -1) {
      stocks[index] = item;
    }
    notifyListeners();
  }

  Future<void> deleteStock(Item item) async {
    try {
      // Sync local data with Firestore before deleting
      await _databaseService.syncStocks();

      // Delete item from Firebase and Sqflite
      await _databaseService.deleteStock(item.id);

      // Remove item from the in-memory list
      _stocks.removeWhere((stock) => stock.id == item.id);

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting stock: $e');
    }
  }

  void updateMemoryList(Item item) {
    // Update the in memory list
    final index = stocks.indexWhere((stock) => stock.id == item.id);
    if (index != -1) {
      stocks[index] = item;
      print('update the memory list of the stock');
    }
    notifyListeners();
  }
}
