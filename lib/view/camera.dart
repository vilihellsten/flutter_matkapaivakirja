import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? _imagePath; // Holds the local image path
  String? _oldImagePath;
  bool _isUploading = false; // Tracks upload status

  final ImagePicker _picker = ImagePicker();

  // Method to pick an image using the camera
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePath = image.path; // Update the image path
      });
    }
  }

  // Method to upload the image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected!')),
      );
      return null;
    }

    try {
      setState(() {
        _isUploading = true;
      });

      // Delete the old image from Firebase Storage if it exists
      if (_oldImagePath != null) {
        try {
          final oldImageRef =
              FirebaseStorage.instance.refFromURL(_oldImagePath!);
          await oldImageRef.delete();
          _oldImagePath = null; // Reset the old image path
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete old image: $e')),
          );
        }
      }

      // Generate a unique file name for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Reference to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');

      // Upload the file to Firebase Storage
      await storageRef.putFile(File(_imagePath!));

      // Get the download URL of the uploaded image
      final downloadUrl = await storageRef.getDownloadURL();

      // Store the path of the newly uploaded image
      _oldImagePath = downloadUrl;

      return downloadUrl; // Return the image URL
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the selected image
            _imagePath == null
                ? const Text('Ei kuvaa') // No image selected
                : Image.file(
                    File(_imagePath!),
                    width: 200,
                    height: 200,
                  ),
            const SizedBox(height: 20),

            // Button to take a picture
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Ota kuva'),
            ),
            const SizedBox(height: 20),

            // Button to upload the image and return the URL
            _isUploading
                ? const CircularProgressIndicator() // Show progress indicator during upload
                : ElevatedButton(
                    onPressed: () async {
                      final imageUrl = await _uploadImage();
                      if (imageUrl != null) {
                        Navigator.pop(
                            context, imageUrl); // Return the image URL
                      }
                    },
                    child: const Text('Lähetä kuva'),
                  ),
            const SizedBox(height: 20),

            // Button to go back without selecting an image
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Takaisin'),
            ),
          ],
        ),
      ),
    );
  }
}
