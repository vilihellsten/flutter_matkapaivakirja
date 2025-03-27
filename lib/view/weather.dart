import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  String kuvaus = "";
  double lampotila = 0;

  //käyttäjän oma haku
  String haku = "";
  String asema1 = "";
  String kuvaus1 = "";
  double lampotila1 = 0;

  @override
  void initState() {
    super.initState();
    _weather();
  }

  Future<void> _weather() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      log("Virhe sijainnin hakemisessa");
    }

    if (position == null) {
      url =
          "https://api.openweathermap.org/data/2.5/weather?q=$kaupunki&appid=$api&units=metric&lang=fi";
    } else {
      double latitude = position!.latitude;
      double longitude = position!.longitude;
      log(longitude.toString());
      log(latitude.toString());
      url =
          "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$api&units=metric&lang=fi";
    }
    log(url);

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      log(data.toString());

      setState(() {
        kuvaus = data["weather"][0]["description"];
        lampotila = data["main"]["temp"];
        asema = data["name"];
      });
    } else {
      log("Virhe sään hakemisessa");
    }
  }

  Future<void> _haku() async {
    url =
        "https://api.openweathermap.org/data/2.5/weather?q=$haku&appid=$api&units=metric&lang=fi";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      log(data.toString());

      setState(() {
        kuvaus1 = data["weather"][0]["description"];
        lampotila1 = data["main"]["temp"];
        asema1 = data["name"];
      });
    } else {
      log("Virhe sään hakemisessa");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sää')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child:
                    Text("Nykyinen sijainti", style: TextStyle(fontSize: 20)),
              ),
              Text("Lähin sääasema: $asema"),
              Text("Sää: $kuvaus"),
              Text("Lämpötila: ${lampotila.toStringAsFixed(1)} °C"),
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
                child: Text("Kaupunki: $asema1"),
              ),
              Text("Sää: $kuvaus1"),
              Text("Lämpötila: ${lampotila1.toStringAsFixed(1)} °C"),
            ],
          ),
        ),
      ),
    );
  }
}
