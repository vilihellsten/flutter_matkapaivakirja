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
      return Scaffold(
        appBar: AppBar(title: const Text("Julkiset Matkat")),
        body: ListView.builder(
          itemCount: listManager.publicItems.length,
          itemBuilder: (context, index) {
            return _buildTodoCard(
                listManager.publicItems[index], context, listManager);
          },
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
