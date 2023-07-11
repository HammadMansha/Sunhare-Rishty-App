import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/ImageModel.dart';

class ImageListProvider with ChangeNotifier {
  List<ImageModel> imageList = [];
  getImages(String uid) async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child('Images')
        .child(uid)
        .once();
    if (data.snapshot.value != null) {
      final images = data.snapshot.value as Map;
      images.forEach((key, value) {
        imageList.add(ImageModel(id: key, imageUrl: value['imageURL'].toString(), isVerified: false));
      });
    }
  }

  removeImage(String id) {
    imageList.firstWhere((element) => element.id == id);
    notifyListeners();
  }

  addImage(ImageModel image) {
    imageList.add(image);
    notifyListeners();
  }
}
