import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_matkapaivakirja/data/trip_item.dart';

import 'firebase_helper.dart';

class TripListManager extends ChangeNotifier {
  final List<TripItem> _items = [];
  final List<TripItem> _publicItems = [];
  //final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final FirebaseHelper fbHelper = FirebaseHelper();

  Future<void> init() async {
    //loadFromDB();
    loadFromFirebase();
  }

  UnmodifiableListView<TripItem> get items =>
      UnmodifiableListView(_items.reversed);

  UnmodifiableListView<TripItem> get publicItems =>
      UnmodifiableListView(_publicItems.reversed); // !!!

  void clearItems() {
    _items.clear();
    _publicItems.clear();
    notifyListeners();
  }

  //CRUD funktiot

  void addItem(TripItem item) {
    if (_items.isEmpty) {
      item.id = 1;
    } else {
      item.id = _items.last.id + 1;
    }
    _items.add(item);
    //dbHelper.insert(item);
    fbHelper.saveTodoItem(item);
    notifyListeners();
  }

  void delete(TripItem item) {
    _items.remove(item);
    //dbHelper.delete(item.id);
    fbHelper.deleteTodoItem(item); //uusi
    notifyListeners();
  }

  void update(TripItem item) {
    TripItem? oldItem;

    for (TripItem i in _items) {
      if (i.id == item.id) {
        oldItem = i;
        break;
      }
    }
    if (oldItem != null) {
      log("TODOLISTMANAGER: editoidaan: ${oldItem.id}");
      // päivittyy tiedot, tarkasta
      oldItem.title = item.title;
      oldItem.description = item.description;
      oldItem.date = item.date;
      oldItem.location = item.location;
      oldItem.julkinen = item.julkinen;
      oldItem.imageUrl = item.imageUrl;

      //dbHelper.update(oldItem);
      fbHelper.updateTodoItem(oldItem); //uusi
      notifyListeners();
    }
  }

  void loadFromFirebase() async {
    log("loadFromFirebase");
    final list = await fbHelper.getData();
    int id = 1;
    for (TripItem item in list) {
      item.id = id;
      _items.add(item);
      id++;
    }
    notifyListeners();
  }

  Future<void> loadPublicFromFirebase() async {
    log("loadPublicFromFirebase");
    _publicItems.clear();
    final list = await fbHelper.getPublicData();
    int id = 1;
    for (TripItem item in list) {
      item.id = id;
      _publicItems.add(item);
      id++;
    }
    notifyListeners();
  }
}
