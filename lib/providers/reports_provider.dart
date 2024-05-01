import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/database_service.dart';

class ReportsProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  late Map<String, List<Item>> _reports; 
  late int _currentPage;
  late int _totalPages;
  late bool _isLoading;

  ReportsProvider() {
    _reports = {};
    _currentPage = 0;
    _totalPages = 0;
    _isLoading = false;
    fetchReports();
  }

  Map<String, List<Item>> get reports => _reports;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;

  Future<void> fetchReports({int page = 0, int limit = 12}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final reports = await _databaseService.fetchPaginatedItems(
          'reports', limit, page * limit);

      // Classify reports by date and store in a map
      Map<String, List<Item>> classifiedReports = {};
      for (var report in reports) {
        String dateString = report.timeStamp;
        if (!classifiedReports.containsKey(dateString)) {
          classifiedReports[dateString] = [];
        }
        classifiedReports[dateString]!.add(report);
      }

      // Merge new reports with existing ones
      _reports.forEach((date, existingReports) {
        if (classifiedReports.containsKey(date)) {
          existingReports.addAll(classifiedReports[date]!);
        }
      });

      // Add any new dates and reports to _reports
      classifiedReports.forEach((date, newReports) {
        if (!_reports.containsKey(date)) {
          _reports[date] = newReports;
        }
      });

      // Assuming you have a method in DatabaseService to get total number of reports
      final totalReports = await _databaseService.getTotalRowCount('reports');
      _totalPages = (totalReports / limit).ceil();

      _currentPage = page;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching reports: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreReports() async {
    if (_currentPage < _totalPages - 1) {
      await fetchReports(page: _currentPage + 1);
    }
  }

  Future<void> updateReport(
      Item stock, Item updatedReport, int difference) async {
    try {
      // Sync the local data with the firestore before updating
      await _databaseService.syncReports();
      // Update item in firebase and sqflite
      await _databaseService.updateItem(updatedReport, 'reports');
      // Update the in stocks
      await _databaseService.updateTransaction(
          stock, updatedReport, difference);

      // Update the in memory list
      _reports.forEach((date, reportsList) {
        final index =
            reportsList.indexWhere((report) => report.id == updatedReport.id);
        if (index != -1) {
          reportsList[index] = updatedReport;
        }
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating report: $e');
    }
  }
}
