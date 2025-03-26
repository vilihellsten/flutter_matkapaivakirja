import 'package:flutter/material.dart';
import 'package:flutter_matkapaivakirja/view/map_screen.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/trip_list_manager.dart';
import 'package:flutter_matkapaivakirja/view/add_trip.dart';

class TripListView extends StatelessWidget {
  const TripListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripListManager>(builder: (context, listManager, child) {
      return Scaffold(
        appBar: AppBar(title: Text("Matkapäiväkirja"), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Lisää uusi',
            onPressed: () {
              Navigator.pushNamed(context, '/add-trip');
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            tooltip: 'Profiili',
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: Icon(Icons.camera),
            tooltip: 'Camera',
            onPressed: () {
              Navigator.pushNamed(context, '/camera');
            },
          ),
        ]),
        body: ListView.builder(
            itemCount: listManager.items.length,
            itemBuilder: (context, index) {
              return _BuildTodoCard(
                  listManager.items[index], context, listManager);
            }),
      );
    });
  }

  Center _BuildTodoCard(
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
                    Text(DateFormat('dd.MM.yyyy').format(item.date)),
                    //Text(item.location != null ? item.location!.toString() : "")
                  ]),
              subtitle: Text(item.description),
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
                    child: Text("Näytä sijainti")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTripView(item: item)),
                      );
                    },
                    child: Text("Muokkaa")),
                ElevatedButton(
                  onPressed: () {
                    //Provider.of<TodoListManager>(context, listen: false)
                    // .delete(item);
                    listManager.delete(item);
                  },
                  child: Text("Poista"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
