import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Matkapäiväkirja'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Lisää uusi',
          onPressed: () {
            Navigator.pushNamed(context, '/add-trip');
          },
        ),
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () => Get.toNamed('/profile'),
          tooltip: "Profiili",
        )
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/trip-list'),
                child: Text('Oma matkapäiväkirja'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/public-trip-list'),
                child: Text('Julkiset matkat'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/add-trip');
                },
                child: Text('Lisää matka'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/weather');
                },
                child: Text('Sää'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/settings'),
                child: Text('Asetukset'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
