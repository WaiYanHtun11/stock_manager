import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';
import 'package:stock_manager/services/database_service.dart';

class ReportsManager extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  late List<Map<String, List<Item>>> _reportsList;
  late int _currentPage;
  late int _totalPages;
  late bool _isLoading;

  ReportsManager() {
    _reportsList = [];
    _currentPage = 0;
    _totalPages = 0;
    _isLoading = false;
    fetchReports();
  }

  List<Map<String, List<Item>>> get reportsList => _reportsList;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;

  //   Future<void> fetchReports({int page = 0, int limit = 12}) async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();

  //     final reports = await _databaseService.fetchPaginatedItems(
  //         'reports', limit, page * limit);

  //     for (var report in reports) {
  //       // Extracting only the date from the timestamp
  //       String dateString =
  //           DateTime.parse(report.timeStamp).toLocal().toString().split(' ')[0];

  //       // Check if the date already exists in _reportsList
  //       bool dateExists = false;
  //       for (var reportsMap in _reportsList) {
  //         if (reportsMap.containsKey(dateString)) {
  //           // If the date exists, append the report to the existing list
  //           reportsMap[dateString]!.add(report);
  //           dateExists = true;
  //           break;
  //         }
  //       }

  //       // If the date doesn't exist, create a new map and add the report
  //       if (!dateExists) {
  //         _reportsList.add({
  //           dateString: [report]
  //         });
  //       }
  //     }

  //     // Assuming you have a method in DatabaseService to get total number of reports
  //     final totalReports = await _databaseService.getTotalRowCount('reports');
  //     _totalPages = (totalReports / limit).ceil();

  //     _currentPage = page;
  //     _isLoading = false;
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('Error fetching reports: $e');
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchReports({int page = 0, int limit = 12}) async {
    if (_isLoading || page > _totalPages) return;

    try {
      _isLoading = true;
      notifyListeners();

      if (page != 0) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final reports = await _databaseService.fetchPaginatedItems(
          'reports', limit, page * limit);

      for (var report in reports) {
        String dateString =
            DateTime.parse(report.timeStamp).toLocal().toString().split(' ')[0];

        bool dateExists = false;
        for (var reportsMap in _reportsList) {
          if (reportsMap.containsKey(dateString)) {
            reportsMap[dateString]!.add(report);
            dateExists = true;
            break;
          }
        }

        if (!dateExists) {
          _reportsList.add({
            dateString: [report]
          });
        }
      }

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
    if (_currentPage < _totalPages - 1 && !_isLoading) {
      await fetchReports(page: _currentPage + 1);
    }
  }

  void addReport(Item report) {
    String dateString =
        DateTime.parse(report.timeStamp).toLocal().toString().split(' ')[0];

    bool dateExists = false;
    for (var reportsMap in _reportsList) {
      if (reportsMap.containsKey(dateString)) {
        reportsMap[dateString]!.insert(0, report);
        dateExists = true;
        break;
      }
    }

    if (!dateExists) {
      _reportsList.insert(0, {
        dateString: [report]
      });
    }

    notifyListeners();
  }

  Future<void> updateReport(
      String sid, Item updatedReport, int difference) async {
    try {
      await _databaseService.syncReports();
      await _databaseService.updateTransaction(sid, updatedReport, difference);

      for (var reportsMap in _reportsList) {
        reportsMap.forEach((date, reportsList) {
          final index =
              reportsList.indexWhere((report) => report.id == updatedReport.id);
          if (index != -1) {
            reportsList[index] = updatedReport;
          }
        });
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating report: $e');
    }
  }

  void updateMemoryList(Item updatedReport) {
    for (var reportsMap in _reportsList) {
      reportsMap.forEach((date, reportsList) {
        final index =
            reportsList.indexWhere((report) => report.id == updatedReport.id);
        if (index != -1) {
          reportsList[index] = updatedReport;
        }
      });
    }
    notifyListeners();
  }
}
