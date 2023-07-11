import 'package:flutter/cupertino.dart';

class ConnectionProvider with ChangeNotifier {
  Map<String, bool> connection = {};
  setConnection(Map map) {
    map.forEach((key, value) {
      connection[key] = value;
    });
    notifyListeners();
  }

  bool checkConnection(id) {
    if (connection[id] == null) {
      return false;
    }
    return connection[id] ?? false;
  }
}
