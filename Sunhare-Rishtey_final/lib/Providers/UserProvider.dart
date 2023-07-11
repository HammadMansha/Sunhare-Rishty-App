import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  final _url = 'https://sunhare-rishtey-bc161-default-rtdb.firebaseio.com';
  // final _url = 'https://sunhare-rishtey-bc161.firebaseio.com';
  Future<void> addprofile(User user, String name, String email) async {
    final rsp = await http.patch(
        Uri.parse(
            "https://sunhare-rishtey-bc161-default-rtdb.firebaseio.com/User Information/${user.uid}.json"),
            // "https://sunhare-rishtey-bc161.firebaseio.com/User Information/${user.uid}.json"),
        body: json
            .encode({'isPhoneVarified': true, "mobileNo": user.phoneNumber}));
    print(rsp.statusCode);
  }

  Future<bool> checkProfile(String uid) async {
    print("~~~~~~~~~ $uid");
    final res = await http.get(Uri.parse("$_url/User Information/$uid.json"));
    print("body is===>>${res.body}");
    print("url is===>>${_url}");
    final extracted = json.decode(res.body) as Map<String, dynamic>;
    if (extracted.isNotEmpty) {
      if((extracted['isPhoneVarified'] ?? false) as bool){
        return true;
      }else{
        return false;
      }
    }
    return false;
  }

  Future<bool> checkNumber(String id, String number) async {
    print("~~~~~~~~~ $id");
    var data = await FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .orderByChild('mobileNo')
        .equalTo(number)
        .once();
    var oldId;
    if (data.snapshot.value != null) {
      final mapped = data.snapshot.value as Map;
      oldId = mapped.keys.first;
      await FirebaseDatabase.instance
          .reference()
          .child("User Information")
          .update({id: mapped.values.first});
      await FirebaseDatabase.instance
          .reference()
          .child("User Information")
          .child(oldId)
          .remove();
      return true;
    }
    return false;
  }
}
