import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isDarkMode = true.obs;

  void toggleTheme() => isDarkMode.value = !isDarkMode.value;
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
