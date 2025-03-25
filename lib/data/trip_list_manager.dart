/*import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_matkapaivakirja/data/trip_item.dart';

import 'db_helper.dart';
import 'firebase_helper.dart';

class TodoListManager extends ChangeNotifier {
  final List<TripItem> _items = [];
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final FirebaseHelper fbHelper = FirebaseHelper();


  Future<void> init() async {
    //loadFromDB();
    loadFromFirebase(); //uusi
  }

  UnmodifiableListView<TodoItem> get items =>
      UnmodifiableListView(_items.reversed); // !!!

  //CRUD funktiot

  void addItem(TodoItem item) {
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

  void delete(TodoItem item) {
    _items.remove(item);
    //dbHelper.delete(item.id);
    fbHelper.deleteTodoItem(item); //uusi
    notifyListeners();
  }

  void update(TodoItem item) {
    TodoItem? oldItem;

    for (TodoItem i in _items) {
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
      oldItem.deadline = item.deadline;
      oldItem.done = item.done;

      //dbHelper.update(oldItem);
      fbHelper.updateTodoItem(oldItem); //uusi
      notifyListeners();
    }
  }

  void toggleDone(TodoItem item) {
    item.done = !item.done;
    //dbHelper.update(item);
    fbHelper.updateTodoItem(item); //uusi
    notifyListeners();
  }

  /*
  Future<void> loadFromDB() async {
    final list = await dbHelper.queryAllRows();
    for (TodoItem item in list) {
      _items.add(item);
    }
    notifyListeners();
  }*/

  void loadFromFirebase() async {
    //uusi
    final list = await fbHelper.getData();
    int id = 1;
    for (TodoItem item in list) {
      item.id = id;
      _items.add(item);
      id++;
    }
    notifyListeners();
  }
}*/
