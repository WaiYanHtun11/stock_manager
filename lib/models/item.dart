import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String name;
  final int count;
  final String image;
  final String timeStamp; // Store timeStamp as String
  final String? status; // Make status nullable

  Item({
    required this.id,
    required this.name,
    required this.count,
    required this.image,
    required this.timeStamp, // Store timeStamp as String
    this.status,
  });

  // Method to convert Firestore DocumentSnapshot to Item object
  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data()!;
    return Item(
      id: doc.id,
      name: data['name'] ?? '',
      count: data['count'] ?? 0,
      image: data['image'] ?? '',
      timeStamp: data['timeStamp'] ?? '',
      status: data['status'], // Include status field if provided
    );
  }

  // Method to convert Item object to a Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'count': count,
      'image': image,
      'timeStamp': timeStamp, // Store timeStamp as String
    };

    if (status != null) {
      map['status'] = status; // Include status field only if not null
    }

    return map;
  }

  // Method to convert a Map object to Item
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      count: map['count'],
      image: map['image'],
      timeStamp: map['timeStamp'], // Store timeStamp as String
      status: map['status'],
    );
  }
}
