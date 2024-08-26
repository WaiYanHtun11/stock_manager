import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';

class OutofStockManager extends ChangeNotifier {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('stocks');
  final List<Item> _outofStocks = [];
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;

  List<Item> get outofStocks => _outofStocks;
  bool get isLoading => _isLoading;

  OutofStockManager() {
    syncOutofStockData();
  }

  // Sync all local and firestore database
  Future<void> syncOutofStockData({limit = 12}) async {
    if (_isLoading || (_lastDocument == null && _outofStocks.isNotEmpty)) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    Query query =
        _firestore.orderBy('count').where('count', isLessThan: limit).limit(12);
    if (_lastDocument != null) {
      await Future.delayed(const Duration(seconds: 1));
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      _outofStocks.addAll(querySnapshot.docs.map((doc) {
        return Item.fromStocksFirestore(doc);
      }).toList());
    } else {
      // No more documents to fetch
      _lastDocument = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkOutofStockAfterUpdate(Item item) async {
    updateOutofStockList(item);
    notifyListeners();
  }

  void updateOutofStockList(Item item) {
    // Check whether it has to be in the out of stocks list
    if (item.count > 10) {
      _outofStocks.removeWhere((stock) => stock.id == item.id);
    } else {
      // Update the in memory list
      final index = _outofStocks.indexWhere((stock) => stock.id == item.id);
      if (index != -1) {
        _outofStocks[index] = item;
      } else {
        _outofStocks.add(item);
      }
    }
    notifyListeners();
  }
}
