import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_manager/models/edit_history.dart';

class EditHistoryProvider with ChangeNotifier {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('editHistories');
  final List<EditHistory> _editHistories = [];
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;

  List<EditHistory> get editHistories => _editHistories;
  bool get isLoading => _isLoading;

  EditHistoryProvider() {
    loadMoreEditHistories();
  }

  // Load more edit histories with pagination
  Future<void> loadMoreEditHistories({int limit = 12}) async {
    if (_isLoading || (_lastDocument == null && _editHistories.isNotEmpty)) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    Query query = _firestore.orderBy('time', descending: true).limit(limit);
    if (_lastDocument != null) {
      await Future.delayed(const Duration(seconds: 1));
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      _editHistories.addAll(querySnapshot.docs.map((doc) {
        return EditHistory.fromMap(doc.data() as Map<String, dynamic>);
      }).toList());
    } else {
      // No more documents to fetch
      _lastDocument = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new edit history entry to Firestore
  Future<void> addEditHistory(EditHistory editHistory) async {
    await _firestore.add(editHistory.toMap());
    _editHistories.insert(
        0, editHistory); // Add the new entry at the start of the list
    notifyListeners();
  }
}
