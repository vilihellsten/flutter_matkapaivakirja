import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_matkapaivakirja/data/trip_item.dart';
import 'package:flutter_matkapaivakirja/view/map_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/trip_list_manager.dart';

class PublicTripListView extends StatefulWidget {
  const PublicTripListView({super.key});

  @override
  _PublicTripListViewState createState() => _PublicTripListViewState();
}

class _PublicTripListViewState extends State<PublicTripListView> {
  String haku = "";

  @override
  void initState() {
    super.initState();
    _loadPublic();
  }

  Future<void> _loadPublic() async {
    final listManager = Provider.of<TripListManager>(context, listen: false);
    await listManager.loadPublicFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripListManager>(builder: (context, listManager, child) {
      final filtteroidyt = listManager.publicItems.where((item) {
        final filtteri = haku.toLowerCase();
        return item.title.toLowerCase().contains(filtteri) ||
            item.description.toLowerCase().contains(filtteri);
      }).toList();

      return Scaffold(
        appBar: AppBar(
          title: const Text("Julkiset Matkat"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Lisää uusi',
              onPressed: () {
                Navigator.pushNamed(context, '/add-trip');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Profiili',
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Haku",
                  hintText: "Hae matkoja otsikon tai kuvauksen perusteella",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    haku = value; // Update the search query
                  });
                },
              ),
            ),
            Expanded(
              child: filtteroidyt.isEmpty
                  ? const Center(child: Text("Ei tuloksia haulle."))
                  : ListView.builder(
                      itemCount: filtteroidyt.length, // Use the filtered list
                      itemBuilder: (context, index) {
                        return _buildTodoCard(
                            filtteroidyt[index], context, listManager);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  Center _buildTodoCard(
      TripItem item, BuildContext context, TripListManager listManager) {
    return Center(
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.title),
                    Text(DateFormat('dd.MM.yyyy').format(item.date))
                  ]),
              subtitle: Text(item.description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (item.imageUrl != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageScreen(imageUrl: item.imageUrl!),
                        ),
                      );
                    }
                  },
                  child: item.imageUrl != null
                      ? const Text("Näytä kuva")
                      : const Text("Ei kuvaa"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (item.location != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapsScreen(
                            initialLocation: item.location,
                            readOnly: true, // Open in read-only mode
                          ),
                        ),
                      );
                    }
                  },
                  child: item.location != null
                      ? const Text("Näytä sijainti")
                      : const Text("Ei sijaintia"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageScreen extends StatelessWidget {
  final String imageUrl;

  const ImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kuva"),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
