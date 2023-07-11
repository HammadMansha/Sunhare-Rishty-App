import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/Providers/allUser.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:provider/provider.dart';
import '/models/UserModel.dart';

class UserRequestProvider with ChangeNotifier {
  List<String> pendingUsers = [];
  List<String> acceptedUsers = [];
  List<UserInformation> pendingUserData = [];
  List<UserInformation> acceptedUserData = [];
  bool fetchedOnce = false;

  Future<void> getAllRequest(BuildContext context) async {
    if (fetchedOnce) return;
    fetchedOnce = true;
    bool? isPremium = Provider.of<CurrUserInfo>(context, listen: false).currentUser.isPremium;
    // return
     FirebaseDatabase.instance
        .reference()
        .child('Connection Requests')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      pendingUsers.clear();
      acceptedUsers.clear();
      acceptedUserData.clear();
      pendingUserData.clear();

      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        setConnection(data);
        List sortable = [];
        Map<String, UserInformation> forSorting = {};
        data.forEach((key, value) {
          if (value is bool) {
            if (value) {
              acceptedUsers.add(key);
            } else {
              pendingUsers.add(key);
            }
          } else {
            Map data = value as Map;
            data['uid'] = key;
            sortable.add(data);
          }
        });
        sortable.sort((a, b) => a['time'].compareTo(b['time']));
        sortable.forEach((data) {
          if (data['accepted']) {
            acceptedUsers.insert(0, data['uid']);
          } else {
            pendingUsers.insert(0, data['uid']);
          }
        });

        Provider.of<AllUser>(context, listen: false)
            .allUsers
            .forEach((element) {
          if (acceptedUsers.contains(element.id)) {
            UserInformation userInfo = element;
            userInfo.isImageVisible = element.visibility == 'All Member' ||
                (element.visibility == 'Premium Members only' && (isPremium ?? false) ) ||
                (element.visibility == 'Connected Members' &&
                    checkConnection(element.id));
            forSorting[element.id ?? ""] = userInfo;
          }
        });

        acceptedUserData = [
          for (String acceptedUser in acceptedUsers) forSorting[acceptedUser]??UserInformation()
        ];
        acceptedUserData.removeWhere((element) => element.name == null);
        forSorting.clear();

        Provider.of<AllUser>(context, listen: false)
            .allUsers
            .forEach((element) {
          if (pendingUsers.contains(element.id)) {
            UserInformation userInfo = element;
            userInfo.isImageVisible = element.visibility == 'All Member' ||
                (element.visibility == 'Premium Members only' && (isPremium ?? false)) ||
                (element.visibility == 'Connected Members' &&
                    checkConnection(element.id));
            forSorting[element.id ?? ""] = userInfo;
          }
        });

        pendingUserData = [
          for (String pendingUser in pendingUsers) forSorting[pendingUser] ?? UserInformation()
        ];
        pendingUserData.removeWhere((element) => element.name == null);
        forSorting.clear();
      }
      notifyListeners();
    });
  }

  // Connection related code
  Map<String, bool> connection = {};
  setConnection(Map map) {
    connection.clear();
    map.forEach((key, value) {
      if (value is bool) {
        connection[key] = value;
      } else {
        connection[key] = value['accepted'] ?? false;
      }
    });
    print("------------------------ Connection ${connection.toString()}");
    notifyListeners();
  }

  bool checkConnection(id) {
    if (connection[id] == null) {
      return false;
    }
    return connection[id] ?? false;
  }
}
