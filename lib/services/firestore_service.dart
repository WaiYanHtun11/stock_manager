import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create operation
  Future<void> create(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (e) {
      print('Error creating document: $e');
    }
  }

  // Read operation with timeStamp filter
  Future<List<Map<String, dynamic>>> read(String collection, String isoTimestamp) async {
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
    }
  }

  // Update operation
  Future<void> update(String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(id).update(data);
    } catch (e) {
      print('Error updating document: $e');   
    }
  }

  // Delete operation
  Future<void> delete(String collection, String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      print('Error deleting document: $e');  
    }
  }
}
