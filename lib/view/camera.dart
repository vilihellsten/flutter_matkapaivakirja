import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CameraController extends GetxController {
  var imagePath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imagePath.value = image.path;
    }
  }
}

class CameraScreen extends StatelessWidget {
  final CameraController controller = Get.put(CameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => controller.imagePath.value.isEmpty
                ? Text('No image taken')
                : Image.file(File(controller.imagePath.value),
                    width: 200, height: 200)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.pickImage,
              child: Text('Take Picture'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
