import 'package:flutter/material.dart';
import 'package:flutter_matkapaivakirja/view/settings_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  Get.put(SettingsController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => HomeScreen()),
            GetPage(name: '/counter', page: () => CounterScreen()),
            GetPage(name: '/settings', page: () => SettingsScreen()),
            GetPage(name: '/camera', page: () => CameraScreen()),
          ],
        ));
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Matkapäiväkirja')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed('/counter'),
              child: Text('Lisää merkintä'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed('/settings'),
              child: Text('Asetukset'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed('/camera'),
              child: Text('Open Camera'),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterController extends GetxController {
  var count = 0.obs;

  void increment() => count++;
}

class CounterScreen extends StatelessWidget {
  final CounterController controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text('Count: ${controller.count}',
                style: TextStyle(fontSize: 24))),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.increment,
              child: Text('Increment'),
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
