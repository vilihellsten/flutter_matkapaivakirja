import 'package:flutter/material.dart';
import 'package:flutter_matkapaivakirja/data/trip_item.dart';
import 'package:flutter_matkapaivakirja/view/map_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/trip_list_manager.dart';
import 'package:flutter_matkapaivakirja/view/add_trip.dart';

class TripListView extends StatefulWidget {
  const TripListView({super.key});

  @override
  _TripListViewState createState() => _TripListViewState();
}

class _TripListViewState extends State<TripListView> {
  String _searchQuery = ""; // Holds the current search query

  @override
  Widget build(BuildContext context) {
    return Consumer<TripListManager>(builder: (context, listManager, child) {
      // Filter the user's trips based on the search query
      final filteredItems = listManager.items.where((item) {
        final query = _searchQuery.toLowerCase();
        return item.title.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query);
      }).toList();

      return Scaffold(
        appBar: AppBar(
          title: const Text("Omat matkat"),
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
                  hintText: "Hae matkoja paikan tai kuvauksen perusteella",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value; // Update the search query
                  });
                },
              ),
            ),
            Expanded(
              child: filteredItems.isEmpty
                  ? const Center(child: Text("Ei tuloksia haulle."))
                  : ListView.builder(
                      itemCount: filteredItems.length, // Use the filtered list
                      itemBuilder: (context, index) {
                        return _buildTodoCard(
                            filteredItems[index], context, listManager);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  Center _buildTodoCard(
      item, BuildContext context, TripListManager listManager) {
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${item.julkinen == true ? "Julkinen" : "Yksityinen"}",
                  )
                ],
              ),
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
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTripView(item: item)),
                      );
                    },
                    child: const Text("Muokkaa")),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  _confirmDelete(context, listManager, item);
                },
                child: const Text("Poista"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void _confirmDelete(context, listmanager, item) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Poista"),
        content: const Text("Oletko varma, että haluat poistaa tämän?"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Ei"),
              ),
              TextButton(
                  onPressed: () {
                    // Call the delete method from FirebaseHelper
                    listmanager.delete(item);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Kyllä")),
            ],
          ),
        ],
      );
    },
  );
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
