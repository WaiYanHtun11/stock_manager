import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/database_service.dart';

class StocksProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  late List<Item> _stocks;
  late int _currentPage;
  late int _totalPages;
  late bool _isLoading;

  StocksProvider() {
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
    try {
      _isLoading = true;
      notifyListeners();

      final stocks = await _databaseService.fetchPaginatedItems('stocks', limit, page * limit);
      _stocks.addAll(stocks);
      
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
    if (_currentPage < _totalPages - 1) {
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
      notifyListeners();
    }
  }
}