import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageService {
  static Future<String?> uploadImage(File imageFile, String imageName) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child(imageName);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  static Future<void> deleteImage(String imageUrl) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .refFromURL(imageUrl)
          .delete();
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }

  static Future<String?> updateImage(File newImageFile, String imageUrl) async {
    try {
      // Delete old image
      await deleteImage(imageUrl);

      // Upload new image
      final imageName = imageUrl.split('/').last;
      return await uploadImage(newImageFile, imageName);
    } catch (e) {
      print('Failed to update image: $e');
      return null;
    }
  }
}
