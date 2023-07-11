import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrimonial_app/Providers/allUser.dart';
import 'package:matrimonial_app/Screens/PremiumPlanScreen.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:provider/provider.dart';

import 'BlockedUsersProvider.dart';

gotoPremiumPlanScreen(context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PremiuimPlanScreen(),
    ),
  );
}

class ContactProvider with ChangeNotifier {
  List<String> contacts = [];

  setContacts(List<String> contacts) {
    this.contacts = contacts;
    notifyListeners();
  }

  addContacts(String id) {
    this.contacts.add(id);
    notifyListeners();
  }

  /* getContact(context, UserInformation user, UserInformation currentUser,
      bool isPremium,
      {Function onSuccess}) async {
    print("======================== ${user.hideContact}");
    if (!isPremium) {
      gotoPremiumPlanScreen(context);
    } else if (contacts.contains(user.id)) {
      if (user.hideContact) {
        Fluttertoast.showToast(msg: 'Contact is hidden by user');
      } else if (onSuccess != null) {
        onSuccess();
      }
    } else if (contacts.length < currentUser.premiumModel.contact) {
      showPopUp(context, user.id, onSuccess);
    } else if (user.hideContact) {
      Fluttertoast.showToast(msg: 'Contact is hidden by user');
    } else if (Provider.of<BlockedUsersProvider>(context, listen: false)
        .isBlocked(user.id)) {
      Fluttertoast.showToast(msg: "You've been blocked by this user");
    } else {
      Fluttertoast.showToast(msg: 'You have exceed the plan');
      gotoPremiumPlanScreen(context);
    }
  } */

  getContact(context, UserInformation user, UserInformation currentUser,
      bool isPremium, {Function? onSuccess}) async {

    if (contacts.contains(user.id) && (!user.hideContact)) {
      if (onSuccess != null) onSuccess();
    } else if (!isPremium) {
      gotoPremiumPlanScreen(context);
    } else if (contacts.length >= (currentUser.premiumModel?.contact ?? 0)) {
      Fluttertoast.showToast(msg: 'You have exceed the plan');
      gotoPremiumPlanScreen(context);
    } else if ((user.hideContact)) {
    // } else if ((user.hideContact) && (user.isPremium)) {
      Fluttertoast.showToast(msg: 'Contact is hidden by user');
    } else if (contacts.length < (currentUser.premiumModel?.contact ?? 0)) {
      showPopUp(context, user.id ?? "", onSuccess);
    } else if (Provider.of<BlockedUsersProvider>(context, listen: false)
        .isBlocked(user.id ?? "")) {
      Fluttertoast.showToast(msg: "You've been blocked by this user");
    }
  }

  showPopUp(context, String? id, [Function? onSuccess]) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Container(
                child: Text(
                    'Do you really wants to use your one cotanct to see .'),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    FirebaseDatabase.instance
                        .reference()
                        .child('Contacts viewed')
                        .child(FirebaseAuth.instance.currentUser!.uid)
                        .update({'$id': true}).then((value) {
                      contacts.add(id!);
                      Navigator.of(context).pop();
                      if (onSuccess != null) onSuccess();
                      Fluttertoast.showToast(msg: 'Contact Unlocked');
                    });
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            ));
  }

  bool contains(String id) {
    return contacts.contains(id);
  }

  Future getContacts() async {
    contacts.clear();
    final contactsData = await FirebaseDatabase.instance
        .reference()
        .child('Contacts viewed')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once();
    if (contactsData.snapshot.value != null) {
      final data = contactsData.snapshot.value as Map;
      data.forEach((key, value) {
        contacts.add(key);
      });
    }
  }

  List getContactUsers(BuildContext context) {
    List allUsers = Provider.of<AllUser>(context, listen: false).allUsers;
    allUsers.removeWhere((element) => !contacts.contains(element.id));
    return allUsers;
  }
}
