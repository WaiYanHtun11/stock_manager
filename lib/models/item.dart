import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String name;
  int count;
  final String image;
  final String? date;
  final String timeStamp; // Store timeStamp as String
  final String? sid;
  final String? status; // Make status nullable
  final String? location; // Make location nullable
  String? note; // Add note as a nullable field

  Item({
    required this.id,
    required this.name,
    required this.count,
    required this.image,
    this.date,
    required this.timeStamp, // Store timeStamp as String
    this.sid,
    this.status, // Include status field
    this.location, // Include location field
    this.note, // Include note field
  });

  // Method to convert Firestore DocumentSnapshot to Item object for stocks
  factory Item.fromStocksFirestore(DocumentSnapshot doc) {
    Map data = doc.data()! as Map<String, dynamic>;
    return Item(
      id: doc.id,
      name: data['name'] ?? '',
      count: data['count'] ?? 0,
      image: data['image'] ?? '',
      timeStamp: data['timeStamp'] ?? '',
      location: data['location'],
      date: data['date'] ?? '',
      note: data['note'] ?? 'No note', // Retrieve note from Firestore
    );
  }

  // Method to convert Firestore DocumentSnapshot to Item object for transactions
  factory Item.fromTransactionsFirestore(DocumentSnapshot doc) {
    Map data = doc.data()! as Map<String, dynamic>;
    return Item(
        id: doc.id,
        name: data['name'] ?? '',
        count: data['count'] ?? 0,
        image: data['image'] ?? '',
        date: data['date'] ?? '',
        timeStamp: data['timeStamp'] ?? '',
        status: data['status'], // Retrieve status from Firestore
        sid: data['sid'],
        note: data['note'] ?? 'No note'); // Retrieve note from Firestore
  }

  // Method to convert Item object to a Map for stocks
  Map<String, dynamic> toStocksMap() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'image': image,
      'timeStamp': timeStamp,
      'date': date,
      'location': location, // Include location field
      'note': note, // Include note field
    };
  }

  // Method to convert Item object to a Map for transactions
  Map<String, dynamic> toTransactionsMap() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'image': image,
      'date': date,
      'timeStamp': timeStamp,
      'status': status, // Include status field
      'sid': sid,
      'note': note, // Include note field
    };
  }

  // Method to convert a Map object to Item
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        id: map['id'],
        name: map['name'],
        count: map['count'],
        image: map['image'],
        date: map['date'],
        timeStamp: map['timeStamp'], // Store timeStamp as String
        status: map['status'],
        location: map['location'],
        sid: map['sid'],
        note: map['note']); // Include note field
  }
}
