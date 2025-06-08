import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:incident_tracker/models/app_alerts.dart';
import 'package:incident_tracker/utils/show_toast.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class ImageService {
  Future<String> saveImageToStorage(File image) async {
    try {
      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create a subdirectory for images if it doesn't exist
      final imageDir = Directory('${directory.path}/images');
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      // Generate a unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(image.path);
      final fileName = 'incident_$timestamp$extension';

      // Create the full path
      final savedImagePath = '${imageDir.path}/$fileName';

      // Read the original file as bytes and write to new location
      final bytes = await image.readAsBytes();
      final savedImage = File(savedImagePath);
      await savedImage.writeAsBytes(bytes);

      // Verify the file was saved correctly
      if (await savedImage.exists() && await savedImage.length() > 0) {
        return savedImagePath;
      } else {
        throw Exception('Failed to save image properly');
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
      rethrow;
    }
  }

  // Method to check if image file exists and is valid
  Future<bool> isImageValid(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists() && await file.length() > 0;
    } catch (e) {
      return false;
    }
  }

  // Method to delete image file
  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  Future<void> pickImage(ImageSource source, Function setImage) async {
    try {
      final img =
          await ImagePicker().pickImage(source: source, imageQuality: 25);

      if (img == null) return;
      File imageTemporary = File(img.path);
      setImage(imageTemporary);
    } on PlatformException catch (e) {
      showToast(ErrorAlert(message: 'Failed to pick image ${e.toString()}'));
    }
  }
}
