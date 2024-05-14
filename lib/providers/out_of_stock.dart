import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/database_service.dart';

class OutofStockManager extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final List<Item> _outofStocks = [];
  bool _isOutofStock = false;

  List<Item> get outofStocks => _outofStocks;
  bool get isOutofStock => _isOutofStock;

  OutofStockManager() {
    syncOutofStockData();
  }

  // Sync all local and firestore database
  Future<void> syncOutofStockData() async {
    final List<Item> outofStocks =
        await _databaseService.fetchItemsLessThan(10);
    _outofStocks.addAll(outofStocks);
    _isOutofStock = await _databaseService.isOutofStock('stocks');
    print(_isOutofStock);
    notifyListeners();
  }

  Future<void> checkOutofStockAfterUpdate(Item item) async {
    await updateOutofStockList(item);
    _isOutofStock = await _databaseService.isOutofStock('stocks');
    notifyListeners();
  }

  Future<void> updateOutofStockList(Item item) async {
    // Check whether it has to be in the out of stocks list
    if (item.count > 10) {
      _outofStocks.removeWhere((stock) => stock.id == item.id);
    } else {
      // Update the in memory list
      final index = _outofStocks.indexWhere((stock) => stock.id == item.id);
      if (index != -1) {
        _outofStocks[index] = item;
      }
    }
    notifyListeners();
  }

  void updateMemoryList(Item item) {
    int total = item.count;
        if (total > 10) {
      _outofStocks.removeWhere((stock) => stock.id == item.id);
    } else {
      // Update the in memory list
      final index = _outofStocks.indexWhere((stock) => stock.id == item.id);
      if (index != -1) {
        _outofStocks[index] = item;
      }
    }
    notifyListeners();
  }
}
