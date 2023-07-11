import 'package:flutter/cupertino.dart';

class HideProvider with ChangeNotifier {
  bool hideFor1Week = false;
  bool hideFor2Week = false;
  bool hideFor1Month = false;
  bool hideP = false;
  setHideStatus(bool week1, bool week2, bool month) {
    hideFor1Week = week1;
    hideFor2Week = week2;
    hideFor1Month = month;
    notifyListeners();
  }

  setHide(bool hide) {
    hideP = hide;
    notifyListeners();
  }
}
