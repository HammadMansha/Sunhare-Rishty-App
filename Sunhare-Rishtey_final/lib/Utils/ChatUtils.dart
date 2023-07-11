import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';

class ChatUtils {
  String senderId = "", receiverId = "";
  String senderName = "";
  var theirMetaRef, myMetaRef;
  var theirChatRef, myChatRef;
  List fcmTokens = [];

  ChatUtils(
      {String senderId = "",
       String receiverId = "",
      String senderName = "User",
      bool fetchTokens = true}) {
    this.senderId = senderId;
    this.receiverId = receiverId;
    this.senderName = senderName;
    theirMetaRef = FirebaseDatabase.instance
        .reference()
        .child("PersonalChatsPersons")
        .child(receiverId)
        .child(senderId);
    myMetaRef = FirebaseDatabase.instance
        .reference()
        .child("PersonalChatsPersons")
        .child(senderId)
        .child(receiverId);

    theirChatRef = FirebaseDatabase.instance
        .reference()
        .child("ChatRoomPersonal")
        .child(receiverId)
        .child(senderId);

    myChatRef = FirebaseDatabase.instance
        .reference()
        .child("ChatRoomPersonal")
        .child(senderId)
        .child(receiverId);

    if (fetchTokens) {
      getFCMTokenbyID(receiverId).then((data) {
        fcmTokens = data.keys.toList();
      });
    }
  }

  void _setLast(String type, {var increment = 500}) {
    myMetaRef
        .child(type)
        .set(DateTime.now().millisecondsSinceEpoch + increment);
  }

  sendMessage(String msg,
      {bool isSilentMessage = false,
      Function? onComplete, Function? onFetching
      }) async {
    String time = DateTime.now().toIso8601String();
    print("time is===>>>>$time");
    final key = myChatRef.push().key;
    await myChatRef.child(key).update({
      'message': msg,
      "uid": receiverId,
      "timeStamp": time,
    });

    await theirChatRef.child(key).update({
      'message': msg,
      "uid": receiverId,
      "timeStamp": DateTime.now().toIso8601String(),
    });

    await myMetaRef.child("lastMsg").set("#$msg");
    await theirMetaRef.child("lastMsg").set("!$msg");

    _setLast("lastSent");

    print("receiverId =>>< $receiverId");
    print("senderId =>>< $senderId");

    String message = msg.length > 50 ? msg.substring(0, 46) + '....' : msg;
    if (isSilentMessage) {
      await getFCMTokenbyID(receiverId).then((data) {
        fcmTokens = data.keys.toList();
      });
    }

    if (!isSilentMessage) {
      sendNotificationByTokens(fcmTokens, senderName, message,
          target: Constants.USER_CHAT_MESSAGE, userId: senderId);
    }
    sendChatNotificationByTokens(fcmTokens, senderName, message,
        target: Constants.USER_CHAT_MESSAGE, userId: senderId);

    if (onComplete != null) {
      onComplete();
    }
  }
}
