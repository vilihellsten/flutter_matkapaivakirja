import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    log("Darkmodevalue ${isDarkMode.value}");
  }
}

class SettingsScreen extends StatelessWidget {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asetukset')),
      body: Center(
        child: Obx(() => SwitchListTile(
              title: Text('Tumma tila'),
              value: controller.isDarkMode.value,
              onChanged: (value) => controller.toggleTheme(),
            )),
      ),
    );
  }
}
