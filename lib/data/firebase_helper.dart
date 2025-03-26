import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_matkapaivakirja/data/trip_item.dart';

class FirebaseHelper {
  /*
  void clearUserData() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance.ref().child('todoitems').child(userId).remove();
  }*/

  DatabaseReference getUserRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No authenticated user found!");
    }
    return FirebaseDatabase.instance.ref().child('todoitems').child(user.uid);
  }

  void saveTodoItem(TripItem item) {
// Ensure ownerId is set correctly
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
}
