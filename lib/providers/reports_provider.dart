import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/database_service.dart';

class ReportsProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  late List<Item> _reports;
  late int _currentPage;
  late int _totalPages;
  late bool _isLoading;

  ReportsProvider() {
    _reports = [];
    _currentPage = 0;
    _totalPages = 0;
    _isLoading = false;
    fetchReports();
  }

  List<Item> get reports => _reports;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;

  Future<void> fetchReports({int page = 0, int limit = 12}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final reports = await _databaseService.fetchPaginatedItems('reports', limit, page * limit);
      _reports.addAll(reports);
      
      // Assuming you have a method in DatabaseService to get total number of reports
      final totalReports = await _databaseService.getTotalRowCount('reports');
      _totalPages = (totalReports / limit).ceil();

      _currentPage = page;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching reports: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreReports() async {
    if (_currentPage < _totalPages - 1) {
      await fetchReports(page: _currentPage + 1);
    }
  }

   Future<void> updateReport(Item stock, Item updatedReport , int difference) async {
    // Sync the local data with the firestore before updating
    await _databaseService.syncReports();
    // Update item in firebase and sqflite
    await _databaseService.updateItem(updatedReport, 'reports');
    // Update the in stocks
    await _databaseService.updateTransaction(stock, updatedReport, difference);
    // Upate the in memory list
    final index = reports.indexWhere((refill) => refill.id == updatedReport.id);
    if (index != -1) {
      reports[index] = updatedReport;
      notifyListeners();
    }
  }
}
