import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Providers/BlockedUsersProvider.dart';
import 'package:matrimonial_app/Providers/UserRequestProvider.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/Screens/PremiumPlanScreen.dart';
import 'package:matrimonial_app/Screens/ViewProfileScreen.dart';
import 'package:matrimonial_app/Utils/ChatUtils.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/customs/widgets/PersonCard.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:matrimonial_app/customs/widgets/DateBubble.dart';
import 'package:provider/provider.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Providers/ContactsProvider.dart';
import '/main.dart';
import '/models/UserModel.dart';
import '/models/chatModel.dart';
import 'package:grouped_list/grouped_list.dart';

// ignore: must_be_immutable
class SocialMediaChat extends StatefulWidget {
  String uid;
  UserInformation data;

  SocialMediaChat({required this.uid, required this.data});

  @override
  _SocialMediaChatState createState() => _SocialMediaChatState();
}

class _SocialMediaChatState extends State<SocialMediaChat> {
  List<ChatModel> list = [];
  var key;
  //ChatModel data = ChatModel();
  BlockedUsersProvider blockedUsersProvider = BlockedUsersProvider();
  TextEditingController messageController = TextEditingController();
  List fcmTokens = [];
  String uid = "";
  ChatUtils chatUtils = ChatUtils();
  bool isFirstMessage = false;
  bool isTyping = false;
  bool isLoading = true;
  bool isOnline = false;
  bool isBlocked = false;
  bool isBlockedByMe = false;
  bool canTheyChat = true;

  checkIfTheyCanChat(String id) {
    if (Provider.of<CurrUserInfo>(context, listen: false)
            .currentUser
            .premiumModel!.isActive ??
        false) {
      return;
    }

    FirebaseDatabase.instance
        .reference()
        .child('ActiveMembership')
        .child(id)
        .once()
        .then((premi) {

          Map tempMapData = premi.snapshot.value as Map;
      if (premi.snapshot.value != null) {
        canTheyChat = tempMapData['ValidTill'] != null
            ? (DateTime.parse(tempMapData['ValidTill']).compareTo(DateTime.now()) > 0)
                ? true
                : false
            : false;
      } else {
        canTheyChat = false;
      }
      setState(() {});
    });
  }

  var onlineListener;

  checkOnline(String id) {
    onlineListener = FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(id)
        .child('isOnline')
        .onValue
        .listen((event) {
      setState(() {
        isOnline = (event.snapshot.value ?? false) as bool;
      });
    });
  }

  var blockedListener;

  checkBlocked(String id) {
    blockedListener = FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('Blocked By')
        .child(id)
        .onValue
        .listen((event) {
      setState(() {
        isBlocked = (event.snapshot.value ?? false) as bool;
      });
    });

    FirebaseDatabase.instance
        .reference()
        .child('BlockedUsers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(id)
        .onValue
        .listen((value) {
      setState(() {
        isBlockedByMe = (value.snapshot.value ?? false) as bool;
      });
    });
  }

  static DateTime lastSeenTime = DateTime.now();
  static DateTime lastReceivedTime = DateTime.now();
  static DateTime lastSentTime = DateTime.now();

  static UserInformation userInfo = UserInformation();
  UserInformation currentUserInfo = UserInformation();
  var theirMetaRef, myMetaRef;
  var theirChatRef, myChatRef;
  final ScrollController _scrollController = ScrollController();

  StreamController<String> streamController = StreamController();

  var listener1, listener2, listener3, listener4, listener5;

  bool isVisible = false;
  initState() {
    currentUserInfo =
        Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    blockedUsersProvider =
        Provider.of<BlockedUsersProvider>(context, listen: false);
    ChatModel.currentUser = widget.uid;
    debugPrint("widget.data.idsdsdd ==> ${widget.data.id}");
    if (widget.data.id == "" || widget.data.id == null) {
      getUserData(widget.uid).then((value) {
        userInfo = value;
        checkBlur();
        init();
        setState(() {
          isLoading = false;
        });
      });
    } else {
      userInfo = widget.data;
      checkBlur();
      init();
    }

    super.initState();
  }

  checkBlur() {
    var provider = Provider.of<UserRequestProvider>(context, listen: false);
    provider.getAllRequest(context).then((value) {
      isVisible = userInfo.visibility == 'All Member' ||
          (userInfo.visibility == 'Premium Members only' &&
              (currentUserInfo.isPremium ?? false)) ||
          (userInfo.visibility == 'Connected Members' &&
              provider.checkConnection(userInfo.id));
    });
    setState(() {});
  }

  init() {
    chatUtils = ChatUtils(
        senderId: currentUserInfo.id ?? "",
        receiverId: userInfo.id ?? "",
        senderName: currentUserInfo.name ?? "");
    getFCMTokenbyID(userInfo.id ?? "")
        .then((data) => {fcmTokens = data.keys.toList()});
    // fcmTokens = getFCMTokenbyID(userInfo.id);

    print("::: ${FirebaseAuth.instance.currentUser!.uid}");
    theirMetaRef = FirebaseDatabase.instance
        .reference()
        .child("PersonalChatsPersons")
        .child(widget.uid)
        .child(FirebaseAuth.instance.currentUser!.uid);
    myMetaRef = FirebaseDatabase.instance
        .reference()
        .child("PersonalChatsPersons")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(widget.uid);

    theirChatRef = FirebaseDatabase.instance
        .reference()
        .child("ChatRoomPersonal")
        .child(widget.uid)
        .child(FirebaseAuth.instance.currentUser!.uid);

    myChatRef = FirebaseDatabase.instance
        .reference()
        .child("ChatRoomPersonal")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(widget.uid);

    streamController.stream
        .debounce(Duration(milliseconds: 300))
        .listen((s) => {theirMetaRef.child("isTyping").set(false)});
    getMetaData();
    getMessages();

    checkIfTheyCanChat(widget.uid);
    checkOnline(widget.uid);
    checkBlocked(widget.uid);
  }

  getMetaData() {
    listener1 = theirMetaRef.child("lastSeen").onValue.listen((event) {
      lastSeenTime =
          DateTime.fromMillisecondsSinceEpoch(event.snapshot.value ?? 0);
      setState(() {});
    });

    listener2 = theirMetaRef.child("lastReceived").onValue.listen((event) {
      lastReceivedTime =
          DateTime.fromMillisecondsSinceEpoch(event.snapshot.value ?? 0);
      print("111111lastReceivedTime===>>>$lastReceivedTime");
      /* if (lastReceivedTime.isAfter(lastSeenTime)) {
        lastSeenTime = DateTime.fromMillisecondsSinceEpoch(
            event.snapshot.value + 100 ?? 0);
      } */
      setState(() {});
    });

    listener3 = myMetaRef.child("lastSent").onValue.listen((event) {
      lastSentTime = DateTime.fromMillisecondsSinceEpoch(event.snapshot.value ?? 0);
      print("~~~~~~ Got senttime");
      setState(() {});
    });

    listener4 = myMetaRef.child("isTyping").onValue.listen((event) {
      isTyping = event.snapshot.value ?? false;
      setState(() {});
    });
  }

  void setLast(String type, {var increment = 500}) {
    myMetaRef
        .child(type)
        .set(DateTime.now().millisecondsSinceEpoch + increment);
  }

  void getMessages() {
    listener5 = myChatRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        isFirstMessage = true;
        return;
      }
      final chatdata = event.snapshot.value as Map;

      list.clear();
      chatdata.forEach((key, value) {
        list.insert(
            0,
            ChatModel(
              uid: value['uid'],
              message: value['message'],
              date: DateTime.parse(value['timeStamp']),
              imageURL: value['DpURL'],
              messageID: key,
            ));
      });
      setLast("lastSeen", increment: 1000);
      setState(() {});
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent + 300,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        });
      });
    });
  }

  Widget chatMessageList() {
    return list != null
        ? Container(
            child: GroupedListView<ChatModel, DateTime>(
                elements: list,
                order: GroupedListOrder.ASC,
                floatingHeader: true,
                controller: _scrollController,
                groupBy: (ChatModel chatModel) => DateTime((chatModel.date?.year ?? 0),
                    (chatModel.date?.month ?? 0), (chatModel.date?.day ?? 0)),
                groupHeaderBuilder: (ChatModel chatModel) =>
                    DateBubble(dateTime: chatModel.date ?? DateTime.now()),
                itemBuilder: (_, ChatModel element) {
                  return MessageTile(
                    message: element.message ?? "",
                    isSendByMe: element.uid == userInfo.id,
                    time: element.date ?? DateTime.now(),
                  );
                }))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          backgroundColor: theme.colorBackground,
          appBar: AppBar(
            leadingWidth: 92,
            leading: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    if (isBlocked) {
                      Fluttertoast.showToast(
                          msg: "You are blocked by this user.");
                      return;
                    }
                    if (isBlockedByMe) {
                      Fluttertoast.showToast(msg: "You've blocked this user.");
                      return;
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewProfileScreen(
                            [userInfo], 0, currentUserInfo.isPremium ?? false)));
                  },
                  child: Container (
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration (
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage (
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider (
                              userInfo.imageUrl ?? "",
                            )
/*                            image: userInfo!.imageUrl != null
                                ? CachedNetworkImageProvider(
                                    userInfo.imageUrl ?? "",
                                  )
                                : AssetImage('assets/profile.png')*/
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: isVisible ? 0.0 : 4.0,
                              sigmaY: isVisible ? 0.0 : 4.0),
                          child: Container(),
                        ),
                      )),
                ),

              ],
            ),
            backgroundColor: theme.colorCompanion,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      if (isBlocked) {
                        Fluttertoast.showToast(
                            msg: "You are blocked by this user.");
                        return;
                      }
                      if (isBlockedByMe) {
                        Fluttertoast.showToast(
                            msg: "You've blocked this user.");
                        return;
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewProfileScreen(
                              [userInfo], 0, currentUserInfo.isPremium ?? false)));
                    },
                    child: Text(userInfo != null ? userInfo.name ?? "" : "Loading")),
                Text(
                    isTyping
                        ? 'Typing...'
                        : isOnline
                            ? 'Online'
                            : '',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 12))
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.call),
                onPressed: () {
                  callButtonPressed();
                  /*if(currentUserInfo.isPremium){
                    callButtonPressed();
                  }else{
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PremiuimPlanScreen()));
                  }*/
                },
              ),
              InkWell(
                onTap: () {
                  bottomSheet(context, userInfo, currUser,
                      isBlocked: blockedUsersProvider.isBlocked(userInfo.id ?? ""));
                },
                child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    child: Icon(MdiIcons.dotsVertical,
                        color: Colors.white, size: 23)),
              )
            ],
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: chatMessageList(),
                ),
                Container(
                  color: Colors.teal,
                  child: Row(
                    children: [
                      Container(
                        width: width * .8,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 10,
                            bottom: 10,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            minLines: 1,
                            style: TextStyle(fontSize: 16),
                            controller: messageController,
                            onChanged: (val) {
                              theirMetaRef.child("isTyping").set(true);
                              streamController.add(val);
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'Start Typing....',
                              hintStyle: TextStyle(fontSize: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: theme.colorBackgroundDialog,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * .03,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (isBlocked) {
                              Fluttertoast.showToast(
                                  msg: "You are blocked by this user.");
                              return;
                            }
                            if (isBlockedByMe) {
                              Fluttertoast.showToast(
                                  msg: "You've blocked this user.");
                              return;
                            }
                            if (!(currentUserInfo.isPremium ?? true)) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Premium plan required to chat with this user.",
                                  gravity: ToastGravity.BOTTOM);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PremiuimPlanScreen(),
                                ),
                              );
                              return;
                            }
                            String msg = messageController.text;
                            messageController.clear();
                            if (msg == null || msg.trim() == "") {
                              Fluttertoast.showToast(
                                  msg: "Write some message!",
                                  gravity: ToastGravity.BOTTOM);
                              return;
                            }

                            chatUtils.sendMessage(msg, onComplete: () {
                              setState(() {
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent +
                                        300,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeInOut);
                              });
                            },);
                          },
                          child: messageController.text == null ||
                                  messageController.text == ""
                              ? Text(
                                  'Send',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Icon(
                                  Icons.send,
                                  color: theme.colorBackground,
                                ),
                        ),
                      ),
                      SizedBox(
                        width: width * .05,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    streamController.close();
    listener1?.cancel();
    listener2?.cancel();
    listener3?.cancel();
    listener4?.cancel();
    listener5?.cancel();
    blockedListener?.cancel();
    onlineListener?.cancel();
    ChatModel.currentUser = '';
    super.dispose();
  }

  void callButtonPressed() async{

    var data = await FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(userInfo.id!)
        .child("clickCount").once();
    int clickObject = 0;
    if(data.snapshot.value != null) {
      clickObject = data.snapshot.value as int;
    } else {
      clickObject = 0;
    }
    print('clickObject===>>$clickObject');
    clickObject++;
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(userInfo.id!)
        .update({'clickCount': clickObject});

    Provider.of<ContactProvider>(context, listen: false)
        .getContact(
        context,
        userInfo,
        currentUserInfo,
        currentUserInfo.isPremium, onSuccess: () {
      setState(() {});
      launch("tel://${userInfo.phone}");
    });

    final checkData = await FirebaseDatabase.instance
        .reference()
        .child('PlanWithContactView').child(FirebaseAuth.instance.currentUser!.uid)
        .orderByChild("activePlan").equalTo(true).once();
    Map fdata = checkData.snapshot.value as Map;

    String getKeyName = "";
    List<String> viewContactList = [];
    fdata.forEach((key, value) {
      print("active plan key is===>>>$key");
      getKeyName = key;
      if(value['contact_view'] != null) {
        // viewContactList = value['contact_view'];

        List<Object?> tempData = value['contact_view'] ?? [];
        print(tempData.runtimeType);

        viewContactList = [];
        tempData.forEach((element) {
          viewContactList.add(element.toString() ?? "");
        });

      }
    });

    if(viewContactList.contains(userInfo.id ?? "")) {

    }

    viewContactList.add(userInfo.id ?? "");

    await FirebaseDatabase.instance
        .reference()
        .child('PlanWithContactView')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("${getKeyName}").
    update({"contact_view": viewContactList});
  }
}

// ignore: must_be_immutable
class MessageTile extends StatefulWidget {
  final bool isSendByMe;
  final String message;
  final DateTime time;

  MessageTile({
    required this.isSendByMe,
    required this.message,
    required this.time,
  });

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      alignment:
          widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Container(
          width: width * .8,
          padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
          decoration: BoxDecoration(
            color: widget.isSendByMe ? theme.chatsend : theme.chatrevieve,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(18),
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(widget.isSendByMe ? 18 : 0),
              bottomRight: Radius.circular(widget.isSendByMe ? 0 : 18),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: widget.isSendByMe
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.start,
            children: [
              Text(
                widget.message,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black,
                ),
                //textAlign: widget.isSendByMe ? TextAlign.left : TextAlign.left,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(getTimeInHhMmA(widget.time),
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.grey[500],
                        )),
                  ),
                  widget.isSendByMe ? getIcon() : Container()
                ],
              )
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   padding: EdgeInsets.only(
    //       left: widget.isSendByMe ? width * .25 : 15,
    //       right: widget.isSendByMe ? 15 : width * .2),
    //   width: width,
    //   alignment:
    //       widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
    //   child: InkWell(
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 5),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: widget.isSendByMe ? theme.chatsend : theme.chatrevieve,
    //           borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(15),
    //               topRight: Radius.circular(15),
    //               bottomLeft: widget.isSendByMe
    //                   ? Radius.circular(15)
    //                   : Radius.circular(0),
    //               bottomRight: widget.isSendByMe
    //                   ? Radius.circular(0)
    //                   : Radius.circular(15)),
    //         ),
    //         child: Padding(
    //             padding:
    //                 EdgeInsets.only(right: 15, left: 15, bottom: 10, top: 12),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Container(
    //                   width: width * 0.56,
    //                   child: Text(
    //                     widget.message,
    //                     textAlign:
    //                         widget.isSendByMe ? TextAlign.left : TextAlign.left,
    //                     style: GoogleFonts.lato(
    //                       fontSize: 14,
    //                       color: Colors.black,
    //                     ),
    //                   ),
    //                 ),
    //                 widget.isSendByMe ? getIcon() : Container(),
    //               ],
    //             )),
    //       ),
    //     ),
    //   ),
    // );
  }

  Icon getIcon() {
    if (widget.time.isBefore(_SocialMediaChatState.lastSeenTime)) {
      return const Icon(MdiIcons.checkAll, color: Colors.blueAccent);
    }
     if (widget.time.isBefore(_SocialMediaChatState.lastReceivedTime)) {
      // Check if user is online
      return Icon(MdiIcons.checkAll, color: Colors.grey[600]);
    } else if (widget.time.isBefore(_SocialMediaChatState.lastSentTime)) {
      return Icon(MdiIcons.check, color: Colors.grey[600]);
    } else {
      return Icon(MdiIcons.clockOutline, color: Colors.grey[600]);
    }
  }
}
