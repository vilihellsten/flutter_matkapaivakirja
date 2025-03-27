import 'package:flutter/material.dart';
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
            IconButton(
              icon: const Icon(Icons.camera),
              tooltip: 'Camera',
              onPressed: () {
                Navigator.pushNamed(context, '/camera');
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
                    "${item.julkinen == true ? "Julkinen" : "Privaatti"}",
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Sijaintia ei ole asetettu.")),
                        );
                      }
                    },
                    child: const Text("Näytä sijainti")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTripView(item: item)),
                      );
                    },
                    child: const Text("Muokkaa")),
                ElevatedButton(
                  onPressed: () {
                    listManager.delete(item);
                  },
                  child: const Text("Poista"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
