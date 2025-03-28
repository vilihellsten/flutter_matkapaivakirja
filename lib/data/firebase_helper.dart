import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_matkapaivakirja/data/trip_item.dart';

class FirebaseHelper {
  /*
  void clearUserData() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance.ref().child('tripitems').child(userId).remove();
  }*/

  DatabaseReference getUserRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No authenticated user found!");
    }
    return FirebaseDatabase.instance.ref().child('todoitems').child(user.uid);
  }

  getPublicRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No authenticated user found!");
    }
    return FirebaseDatabase.instance.ref().child("todoitems").once();
  }

  void saveTodoItem(TripItem item) {
    final userRef = getUserRef();
    var itemRef = userRef.push();
    item.fbid = itemRef.key;
    item.ownerId = FirebaseAuth.instance.currentUser!.uid;
    itemRef.set(item.toJson());
  }

  void deleteTodoItem(TripItem item) {
    if (item.fbid != null) {
      getUserRef().child(item.fbid!).remove();
    }

    if (item.imageUrl != null) {
      try {
        final oldImageRef = FirebaseStorage.instance.refFromURL(item.imageUrl!);
        oldImageRef.delete();
        item.imageUrl = null; // Reset the old image path
      } catch (e) {
        log('Error deleting image: $e');
      }
    }
  }

  void updateTodoItem(TripItem item) {
    if (item.fbid != null) {
      getUserRef().child(item.fbid!).update(item.toJson());
    }
  }

  Future<List<TripItem>> getData() async {
    List<TripItem> items = [];

    DatabaseEvent event = await getUserRef().once();
    var snapshot = event.snapshot;

    for (var child in snapshot.children) {
      TripItem item = TripItem.fromJson(child.value as Map<dynamic, dynamic>);
      item.fbid = child.key;
      items.add(item);
    }
    return items;
  }

  Future<List<TripItem>> getPublicData() async {
    List<TripItem> items = [];

    DatabaseEvent event = await getPublicRef();

    var snapshot = event.snapshot;

    // Iterate through each user's node
    for (var user in snapshot.children) {
      // Iterate through each trip item in the user's node
      for (var trip in user.children) {
        final tripData = trip.value as Map<dynamic, dynamic>;
        if (tripData['julkinen'] == true) {
          TripItem item = TripItem.fromJson(tripData);
          item.fbid = trip.key; // Save the Firebase ID
          items.add(item);
        }
      }
    }

    return items;
  }
}
