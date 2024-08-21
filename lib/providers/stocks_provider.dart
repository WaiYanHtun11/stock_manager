import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/database_service.dart';

class StocksManager extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  late List<Item> _stocks;
  late int _currentPage;
  late int _totalPages;
  late bool _isLoading;
  int _totalStock = 0;

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
  int get totalStock => _totalStock;

  Future<void> fetchStocks({int page = 0, int limit = 12}) async {
    if (_isLoading || page > _totalPages) return;

    try {
      _isLoading = true;
      notifyListeners();

      if (page != 0) {
        await Future.delayed(const Duration(seconds: 2));
      }

      final stocks = await _databaseService.fetchPaginatedItems(
          'stocks', limit, page * limit);

      _stocks.addAll(stocks);

      // Assuming you have a method in DatabaseService to get total number of stock
      _totalStock = await _databaseService.getTotalStocks();
      final total = await _databaseService.getTotalRowCount('stocks');
      _totalPages = (total / limit).ceil();

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

  Future<void> updateTotalStocks() async {
    _totalStock = await _databaseService.getTotalStocks();
    notifyListeners();
  }

  Future<void> addStock(Item item) async {
    // Sync local data with the firestore before adding
    await _databaseService.syncStocks();
    // Add item to the firebase and sqflite
    await _databaseService.addStock(item);
    // // Get total items in the stock
    _totalStock = await _databaseService.getTotalStocks();
    // Update the in memory list
    stocks.insert(0, item);
    notifyListeners();
  }

  Future<void> updateStock(Item item) async {
    // Sync local data with the firestore before updating
    await _databaseService.syncStocks();
    // Update item in firebase and sqflite
    await _databaseService.updateStock(item);
    // Get total items in the stock
    _totalStock = await _databaseService.getTotalStocks();
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

      item.name = '';
      item.count = 0;
      item.timeStamp = DateTime.now().toIso8601String();

      // Delete item from Firebase and Sqflite
      await _databaseService.updateStock(item);

      // // Get total items in the stock
      _totalStock = await _databaseService.getTotalStocks();

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
    }
    notifyListeners();
  }
}
