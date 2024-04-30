import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/database_service.dart';

class DailyManager extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  late SharedPreferences _prefs;

  List<Item> sales = [];
  List<Item> refills = [];

  DailyManager() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> syncData() async {
    // Check if it's a new day
    final lastSyncDate = _prefs.getString('lastSyncDate');
    final currentDate = DateTime.now().toIso8601String().substring(0, 10);
    if (lastSyncDate != currentDate) {
      // Clear database and sync data if it's a new day
      await _databaseService.clearTransactions('sales');
      await _databaseService.clearTransactions('refills');
      _prefs.setString('lastSyncDate', currentDate);
    }

    // Fetch sales and refills from local database after syncing data
    sales = await _databaseService.fetchFromLocalDB('sales');
    refills = await _databaseService.fetchFromLocalDB('refills');
    notifyListeners();
  }

  Future<void> addSale(Item stock, Item sale) async {
    // Add item to the firebase and sqflite
    await _databaseService.addItem(sale, 'sales');
    // Update the in stocks
    await _databaseService.addTransaction(stock, sale);
    // Update the in memory list
    sales.add(sale);
    notifyListeners();
  }

  Future<void> addRefill(Item stock, Item refill) async {
    // Add item to the firebase and sqflite
    await _databaseService.addItem(refill, 'refills');
    // Update the in stocks
    await _databaseService.addTransaction(stock, refill);
    // Update the in memory list    
    refills.add(refill);
    notifyListeners();
  }

  // Difference : new item - old item
  Future<void> updateSale(Item stock, Item updatedSale , int difference) async {
    // Update item in firebase and sqflite
    await _databaseService.updateItem(updatedSale, 'sales');
    // Update the in stocks
    await _databaseService.updateTransaction(stock, updatedSale, difference);
    // Upate the in memory list
    final index = sales.indexWhere((sale) => sale.id == updatedSale.id);
    if (index != -1) {
      sales[index] = updatedSale;
      notifyListeners();
    }
  }

  Future<void> updateRefill(Item stock, Item updatedRefill , int difference) async {
    // Update item in firebase and sqflite
    await _databaseService.updateItem(updatedRefill, 'refills');
    // Update the in stocks
    await _databaseService.updateTransaction(stock, updatedRefill, difference);
    // Upate the in memory list
    final index = refills.indexWhere((refill) => refill.id == updatedRefill.id);
    if (index != -1) {
      refills[index] = updatedRefill;
      notifyListeners();
    }
  }

}
