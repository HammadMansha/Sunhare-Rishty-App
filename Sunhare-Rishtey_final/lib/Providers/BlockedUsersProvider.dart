import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BlockedUsersProvider with ChangeNotifier {
  List blockedUsers = [];

  getBlockedUsers() async {
    FirebaseDatabase.instance
        .reference()
        .child('BlockedUsers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      final snapShot = event.snapshot.value != null ? event.snapshot.value as Map : {};
      blockedUsers.clear();
      if (snapShot != null) {
        blockedUsers.addAll(snapShot.keys);
      }
      notifyListeners();
    });
  }

  Future toggle(String id) async {
    if (blockedUsers.contains(id)) {
      await FirebaseDatabase.instance
          .reference()
          .child('User Information')
          .child(id)
          .child('Blocked By')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .remove();
      await FirebaseDatabase.instance
          .reference()
          .child('BlockedUsers')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(id)
          .remove();
      return;
    }
    await FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(id)
        .child('Blocked By')
        .update({'${FirebaseAuth.instance.currentUser!.uid}': true});
    await FirebaseDatabase.instance
        .reference()
        .child('BlockedUsers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({'$id': true});
  }

  bool isBlocked(String id) {
    return blockedUsers.contains(id);
  }
}
