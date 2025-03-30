import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    log("Teema ${isDarkMode.value}");
  }
}

class SettingsScreen extends StatelessWidget {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asetukset')),
      body: Center(
        child: Obx(() => Padding(
              padding: const EdgeInsets.all(100.0),
              child: SwitchListTile(
                title: Text('Tumma tila'),
                value: controller.isDarkMode.value,
                onChanged: (value) => controller.toggleTheme(),
              ),
            )),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
