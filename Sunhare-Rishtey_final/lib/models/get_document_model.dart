// To parse this JSON data, do
//
//     final getDocumentModel = getDocumentModelFromJson(jsonString);

import 'dart:convert';

GetDocumentModel getDocumentModelFromJson(String str) => GetDocumentModel.fromJson(json.decode(str));

String getDocumentModelToJson(GetDocumentModel data) => json.encode(data.toJson());

class GetDocumentModel {
  GetDocumentModel({
    required this.documents,
  });

  List<String> documents;

  factory GetDocumentModel.fromJson(Map<String, dynamic> json) => GetDocumentModel(
    documents: List<String>.from(json["documents"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "documents": List<dynamic>.from(documents.map((x) => x)),
  };
}
