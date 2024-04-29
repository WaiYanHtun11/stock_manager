import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create operation
  Future<void> createItem(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (e) {
      print('Error creating document: $e');
    }
  }

    // Read operation with count filter
  Future<List<Map<String, dynamic>>> getItemsLessThan(String collection, int countThreshold) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(collection)
          .where('count', isLessThan: countThreshold)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error reading documents: $e');
      return [];
    }
  }

  // Read operation with timeStamp filter
  Future<List<Map<String, dynamic>>> getItems(String collection, String isoTimestamp) async {
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

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error reading documents: $e');
      return [];
    }
  }

  // Update operation
  Future<void> updateItem(String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(id).update(data);
    } catch (e) {
      print('Error updating document: $e');   
    }
  }

  // Delete operation
  Future<void> deleteItem(String collection, String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      print('Error deleting document: $e');  
    }
  }
}
