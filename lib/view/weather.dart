import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final String api = "3a0e25ae7e65b5e0a0196a3c7888720f";
  final String kaupunki = "Lappeenranta";
  Map data = {};
  Position? position;
  String url = "";

  //nykyinen sijainti
  String asema = "";
  String kuvaus = "Ladataan";
  String maa = "";
  double lampotila = 0;

  //käyttäjän oma haku
  String haku = "";
  String asema1 = "Kaupunki";
  String kuvaus1 = "";
  String maa1 = "";
  double lampotila1 = 0;

  @override
  void initState() {
    super.initState();
    _weather();
  }

  Future<void> _weather() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      log("Virhe sijainnin hakemisessa");
    }

    if (position == null) {
      url =
          "https://api.openweathermap.org/data/2.5/weather?q=$kaupunki&appid=$api&units=metric&lang=fi"; // jos ei löydy nykyistä sijaintai
    } else {
      double latitude = position!.latitude;
      double longitude = position!.longitude;
      log(longitude.toString());
      log(latitude.toString());
      url =
          "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$api&units=metric&lang=fi"; //jos sijainti löytyy
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      log(data.toString());

      setState(() {
        kuvaus = data["weather"][0]["description"];
        lampotila = data["main"]["temp"];
        asema = "Lähin sääasema: ${data["name"]},";
        maa = data["sys"]["country"];
      });
    } else {
      log("Virhe sään hakemisessa");
    }
  }

  Future<void> _haku() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$haku&appid=$api&units=metric&lang=fi"));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      log(data.toString());

      setState(() {
        kuvaus1 = data["weather"][0]["description"];
        lampotila1 = data["main"]["temp"];
        asema1 = "${data["name"]},";
        maa1 = data["sys"]["country"];
      });
    } else {
      log("Virhe sään hakemisessa");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Säätiedot')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child:
                    Text("Nykyinen sijainti", style: TextStyle(fontSize: 20)),
              ),
              Text("${lampotila.toStringAsFixed(1)} °C",
                  style: TextStyle(fontSize: 30)),
              Text("$asema $maa"),
              Text(kuvaus),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text("Hae sää kaupungin perusteella",
                    style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Kaupunki",
                      hintText: "",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        haku = value;
                        _haku();
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text("${lampotila1.toStringAsFixed(1)} °C",
                    style: TextStyle(fontSize: 30)),
              ),
              Text("$asema1 $maa1"),
              Text(kuvaus1)
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          onPressed: () {
            Navigator.pop(context); // Close the current view
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
