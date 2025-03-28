import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_matkapaivakirja/data/trip_item.dart';
import 'package:flutter_matkapaivakirja/view/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import 'package:flutter_matkapaivakirja/data/trip_list_manager.dart';

class AddTripView extends StatelessWidget {
  final TripItem? item;
  const AddTripView({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lisää uusi matka")),
      body: InputForm(item: item),
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

class InputForm extends StatefulWidget {
  final TripItem? item;
  const InputForm({super.key, this.item});

  @override
  State<StatefulWidget> createState() {
    return _InputFormState();
  }
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();

  int _id = 0;
  String _title = "";
  String _description = "";
  DateTime _date = DateTime.now();
  LatLng? _location;
  bool? _julkinen = false;

  bool _isEdit = false; // tarkkailee ollaanko editoimassa

  @override
  void initState() {
    if (widget.item != null) {
      _id = widget.item!.id;
      _title = widget.item!.title;
      _description = widget.item!.description;
      _date = widget.item!.date;
      _location = widget.item!.location;
      _julkinen = widget.item!.julkinen;

      _isEdit = true;
      log("editoidaan${widget.item!.id}");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                    labelText: "Paikka", hintText: "Paikan nimi"),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nimi ei voi olla tyhjä";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                    labelText: "Kuvaus", hintText: "Tapahtuman kuvaus"),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                minLines: 3,
                maxLines: 5,
              ),
            ),
            _FormDatePicker(
                date: _date,
                onChanged: (value) {
                  setState(() {
                    _date = value;
                  });
                }),
            Row(children: [
              Checkbox(
                value: _julkinen,
                onChanged: (bool? value) {
                  setState(() {
                    _julkinen = value ?? false; // Update the state
                  });
                },
              ),
              Text('Julkinen ( kaikkien nähtävissä )'),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child:
                    ElevatedButton(onPressed: null, child: Text("Lisää kuva")),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MapsScreen(initialLocation: _location),
                      ),
                    );
                    if (selectedLocation != null) {
                      setState(() {
                        _location = selectedLocation as LatLng;
                      });
                    }
                  },
                  child: _isEdit
                      ? const Text("Muokkaa sijaintia")
                      : const Text("Lisää sijainti"),
                ),
              ),
            ]),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  TripItem item = TripItem(
                    title: _title,
                    description: _description,
                    date: _date,
                    id: _id,
                    location: _location,
                    julkinen: _julkinen,
                  );

                  if (!_isEdit) {
                    // opettele huutomerkit
                    Provider.of<TripListManager>(context, listen: false).addItem(
                        item); // lisätään uusi tehtävä käyttäen Todolistmanagerin metodeja
                    log("Lisätty: id ${item.id}");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lisätty uusi tehtävä")),
                    );
                  } else {
                    Provider.of<TripListManager>(context, listen: false)
                        .update(item);
                    log("editoitu: id ${item.id}");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Editoitu tehtävää")),
                    );
                  }

                  Navigator.pop(context); //hyppää aloitusnäyttöön, miksi
                }
              },
              child: _isEdit
                  ? const Text(
                      "Muokkaus valmis") // vaihtaa tekstin _isEdit riippuen
                  : const Text("Valmis"), //opettele kysymysmerkki miten toimii
            ),
          ],
        ),
      ),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Päivämäärä',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                DateFormat("d.M.yyyy").format(widget.date),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          ElevatedButton(
            child: const Text('Muuta päivämäärää'),
            onPressed: () async {
              var newDate = await showDatePicker(
                context: context,
                initialDate: widget.date,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );

              // Don't change the date if the date picker returns null.
              if (newDate == null) {
                return;
              }

              widget.onChanged(newDate);
            },
          )
        ],
      ),
    );
  }
}
