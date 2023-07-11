// To parse this JSON data, do
//
//     final getImageModel = getImageModelFromJson(jsonString);

import 'dart:convert';

GetImageModel getImageModelFromJson(String str) => GetImageModel.fromJson(json.decode(str));

String getImageModelToJson(GetImageModel data) => json.encode(data.toJson());

class GetImageModel {
  GetImageModel({
    required this.profile,
  });

  List<String> profile;

  factory GetImageModel.fromJson(Map<String, dynamic> json) => GetImageModel(
    profile: List<String>.from(json["profile"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "profile": List<dynamic>.from(profile.map((x) => x)),
  };
}
