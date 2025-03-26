import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Matkapäiväkirja'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () => Get.toNamed('/profile'),
        )
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/add-trip');
              },
              child: Text('Lisää merkintä'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed('/settings'),
              child: Text('Asetukset'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed('/trip-list'),
              child: Text('Matkapäiväkirjalista'),
            ),
          ],
        ),
      ),
    );
  }
}
