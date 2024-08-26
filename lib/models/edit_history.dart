class EditHistory {
  String itemName;
  String userName;
  String image;
  int fromCount;
  int toCount;
  String time;

  EditHistory({
    required this.itemName,
    required this.userName,
    required this.image,
    required this.fromCount,
    required this.toCount,
    required this.time,
  });

  // Convert an EditHistory object into a map object
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'userName': userName,
      'image': image,
      'fromCount': fromCount,
      'toCount': toCount,
      'time': time,
    };
  }

  // Create an EditHistory object from a map object
  factory EditHistory.fromMap(Map<String, dynamic> map) {
    return EditHistory(
      itemName: map['itemName'] ?? '',
      userName: map['userName'] ?? '',
      image: map['image'] ?? '',
      fromCount: map['fromCount'] ?? 0,
      toCount: map['toCount'] ?? 0,
      time: map['time'] ?? '',
    );
  }
}
