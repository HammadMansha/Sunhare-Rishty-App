import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

final headers = {
  'content-type': 'application/json',
  'Authorization':
      'key=AAAAWkHk10g:APA91bGxdRzp5PJ6o_-Wm_MZsFbkOlqxSuGPpMMKu_20tUI9Z5UgCrdfjCXJ7jz18BoG7aXyh7SLaxvPFNmgyQT94KVrP93z0IYXOs4nNQLb2NpNTUmMiLlpOeIvZCDCLwXhS0wpFijh'
};

final postUrl = 'https://fcm.googleapis.com/fcm/send';

Future<bool> sendPushNotificationToAdmin(String title, String body,
    {String target = '-1', String userId = ''}) async {
  final data = {
    "notification": {"body": body, "title": title},
    "priority": "high",
    "data": {
      "target": target,
      "userId": userId,
    },
    "android_channel_id": 'Notifications',
    "to": "/topics/admin",
  };

  final response = await http.post(Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  return response.statusCode == 200;
}

Future<Map> getFCMTokenbyID(String uid) async {
  final data = await FirebaseDatabase.instance
      .reference()
      .child('Push Notifications')
      .child(uid)
      .once();
  return data.snapshot.value as Map;
}

sendChatNotificationByTokens(List tokens, String title, String body,
    {String target = '-1', String userId = ''}) async {
  final data = {
    "data": {
      "body": body,
      "title": title,
      "target": target,
      "userId": userId,
      "fromChat": true,
    },
    "android_channel_id": 'Notifications',
    "registration_ids": tokens,
  };

  final response = await http.post(Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  return response.statusCode == 200;
}

Future<bool> sendNotificationByTokens(List userToken, String title, String body,
    {String target = '-1', String userId = ''}) async {
  final data = {
    "notification": {"body": body, "title": title},
    "priority": "high",
    "data": {
      "target": target,
      "userId": userId,
    },
    "android_channel_id": 'Notifications',
    "registration_ids": userToken,
  };

  final response = await http.post(Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  return response.statusCode == 200;
}

sendNotificationsByUserID(String uid, String title, String body,
    {String target = '-1', String userId = ''}) async {
  final notificationData = await FirebaseDatabase.instance
      .reference()
      .child('Push Notifications')
      .child(uid)
      .once();
  Map tokens = notificationData.snapshot.value as Map;

  final data = {
    "notification": {"body": body, "title": title},
    "priority": "high",
    "data": {
      "target": target,
      "userId": userId,
    },
    "android_channel_id": 'Notifications',
    "registration_ids": tokens.keys.toList(),
  };

  final response = await http.post(Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  return response.statusCode == 200;
}
