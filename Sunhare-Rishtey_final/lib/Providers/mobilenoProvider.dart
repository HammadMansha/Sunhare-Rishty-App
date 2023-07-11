import 'package:flutter/material.dart';

class Mobileno with ChangeNotifier {
  String? phoneno;
  setPhoneNo(String phone) {
    this.phoneno = phone;
    notifyListeners();
  }
}
