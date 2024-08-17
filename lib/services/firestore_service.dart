import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stock_manager/models/item.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create operation
  Future<void> createItem(String collection, Map<String, dynamic> data) async {
    try {
      DocumentReference docRef =
          _firestore.collection(collection).doc(data['id']);
      await docRef.set(data);
    } catch (e) {
      debugPrint('Error creating document: $e');
    }
  }

  // Read operation with count filter
  Future<List<Item>> getItemsLessThan(
      String collection, int countThreshold) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(collection)
          .where('count', isLessThan: countThreshold)
          .get();

      if (collection == 'stocks') {
        return snapshot.docs
            .map((doc) => Item.fromStocksFirestore(doc))
            .toList();
      } else {
        return snapshot.docs
            .map((doc) => Item.fromTransactionsFirestore(doc))
            .toList();
      }
    } catch (e) {
      debugPrint('Error reading documents: $e');
      return [];
    }
  }

  // Read operation with timeStamp filter
  Future<List<Item>> getItems(String collection, String isoTimestamp) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (isoTimestamp.isEmpty) {
        snapshot = await _firestore.collection(collection).get();
      } else {
        snapshot = await _firestore
            .collection(collection)
            .where('timeStamp', isGreaterThan: isoTimestamp)
            .get();
      }
      print(snapshot.docs.length);
      if (collection == 'stocks') {
        return snapshot.docs
            .map((doc) => Item.fromStocksFirestore(doc))
            .toList();
      } else {
        return snapshot.docs
            .map((doc) => Item.fromTransactionsFirestore(doc))
            .toList();
      }
    } catch (e) {
      debugPrint('Error reading documents: $e');
      return [];
    }
  }

  // Update operation
  Future<void> updateItem(
      String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(id).update(data);
    } catch (e) {
      debugPrint('Error updating document: $e');
    }
  }

  // Delete operation
  Future<void> deleteItem(String collection, String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting document: $e');
    }
  }
}
