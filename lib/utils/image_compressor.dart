import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<File> compressImage(File imageFile) async {
  // Read the image file as bytes
  final imageBytes = await imageFile.readAsBytes();

  // Decode the image
  final image = img.decodeImage(imageBytes);

  if (image == null) {
    throw Exception('Failed to decode image');
  }

  // Resize the image
  final resizedImage = img.copyResize(image, width: 800);

  // Compress the image to 60% quality
  final compressedImageBytes = img.encodeJpg(resizedImage, quality: 60);

  // Get temporary directory to store the compressed image
  final tempDir = await getTemporaryDirectory();
  final compressedImagePath = path.join(tempDir.path, 'compressed_image.jpg');

  // Write the compressed image bytes to a new file
  final compressedImageFile = File(compressedImagePath)
    ..writeAsBytesSync(compressedImageBytes);

  return compressedImageFile;
}
