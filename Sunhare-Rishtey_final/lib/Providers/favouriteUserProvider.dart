import 'package:flutter/cupertino.dart';

class FavUsers with ChangeNotifier {
  List<String> favUserIds = [];

  addToFav(String id) {
    favUserIds.add(id);
    notifyListeners();
  }

  removeId(String id) {
    favUserIds.removeWhere((element) => element == id);
    notifyListeners();
  }
}
