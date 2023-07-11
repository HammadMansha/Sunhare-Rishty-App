import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Providers/UserRequestProvider.dart';
import 'package:matrimonial_app/Providers/allUser.dart';
import 'package:matrimonial_app/models/ChatMetadataModel.dart';
import 'package:provider/provider.dart';
import '../Providers/getUserInfo.dart';
import '../models/UserModel.dart';
import '/main.dart';
import 'SocialMediaChatRoom.dart';

var width;
List<ChatMetaDataModel> onlineUsersMeta = [];

class AllChatScreen extends StatefulWidget {
  @override
  _AllChatScreenState createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> with SingleTickerProviderStateMixin {

  TabController? tabController;
  List<String> ids = [];
  List<String> chatUserIDs = [];
  Map<String, ChatMetaDataModel> allUsersMap = {};
  List<ChatMetaDataModel> allUsersMeta = [];
  UserRequestProvider userRequestProvider = UserRequestProvider();
  UserInformation currentUserInfo = UserInformation();

  var listener;
  getPremiumChat(UserRequestProvider userRequestProvider) {
    listener = FirebaseDatabase.instance
        .reference()
        .child('PersonalChatsPersons')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        print("::::: changed");
        final data = event.snapshot.value as Map;
        chatUserIDs = List<String>.from(data.keys.toList());
        data.forEach((key, value) {
          allUsersMap[key] = ChatMetaDataModel(
              uID: key,
              lastMsg: value['lastMsg'] ?? '',
              isTyping: value['isTyping'] ?? false,
              lastSeen: value['lastSeen'] ?? 0,
              lastSent: value['lastSent'] ?? 0,
              lastReceived: value['lastReceived'] ?? 0);
        });

        final allUsers =
            Provider.of<AllUser>(context, listen: false).unremovedUsers;
        onlineUsersMeta.clear();
        allUsers.forEach((element) {
          if (chatUserIDs.contains(element.id)) {
            allUsersMap[element.id]!.setUser(element);
            if (element.isOnline ?? false) {
              onlineUsersMeta.add(allUsersMap[element.id]!);
            }
          }
        });
        allUsersMeta = allUsersMap.values.toList();
        allUsersMeta.removeWhere((element) => element.user == null);
        onlineUsersMeta.removeWhere((element) => element.user == null);
        sortUsers();
        allUsersMeta.forEach((element) {
          bool isVisible = element.user!.visibility == 'All Member' ||
              (element.user!.visibility == 'Premium Members only' && (currentUserInfo?.isPremium ?? false) ) ||
              (element.user!.visibility == 'Connected Members' &&
                  userRequestProvider.checkConnection(element.user!.id));
          element.user!.isImageVisible = isVisible;
        });
        setState(() {});
      }
    });
  }

  sortUsers() {
    allUsersMeta.sort((a, b) {
      if (((a.lastReceived ?? 0) > (b.lastReceived ?? 0) && (a.lastReceived ?? 0) > (b.lastSent ?? 0)) ||
          ((a.lastSent ?? 0)  > (b.lastSent ?? 0) && (a.lastSent ?? 0) > (b.lastReceived ?? 0))) {
        return -1;
      } else {
        return 1;
      }
    });
    onlineUsersMeta.sort((a, b) {
      if (((a.lastReceived ?? 0) > (b.lastReceived ?? 0) && (a.lastReceived ?? 0) > (b.lastSent ?? 0)) ||
          ((a.lastSent ?? 0) > (b.lastSent ?? 0) && (a.lastSent ?? 0) > (b.lastReceived ?? 0))) {
        return -1;
      } else {
        return 1;
      }
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // getAcceptedChanges();
    currentUserInfo =
        Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    userRequestProvider =
        Provider.of<UserRequestProvider>(context, listen: false);
    getPremiumChat(userRequestProvider);
    tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            MdiIcons.accountMultiple,
            size: 20,
          ),
          title: Text(
            'Connect with People',
            style: GoogleFonts.karla(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: theme.colorCompanion,
        ),
        body: allUsersMeta.length == 0
            ? Center(
                child: Text(
                  'No Chats as of now !',
                  style: GoogleFonts.ptSans(
                    // color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              )
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: height * .015,
                    ),
                    width: width,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: TabBar(
                      isScrollable: true,
                      labelPadding: EdgeInsets.only(
                        left: 6,
                        right: 6,
                      ),
                      unselectedLabelColor: Colors.black54,
                      labelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: theme.colorCompanion,
                      ),
                      tabs: [
                        Tab(
                          child: Container(
                            height: height * .05,
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: theme.colorCompanion, width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("All Chats"),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: height * .05,
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: theme.colorCompanion, width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Online Users"),
                            ),
                          ),
                        ),
                      ],
                      controller: tabController,
                    ),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        getUsers(allUsersMeta, height, width,
                            emptyMsg: 'No Chats as of now !'),
                        getUsers(onlineUsersMeta, height, width,
                            emptyMsg: 'No one is online'),
                      ],
                      controller: tabController,
                    ),
                  ),
                  SizedBox(
                    height: height * .002,
                  ),
                ],
              ),
      ),
    );
  }

  getUsers(List<ChatMetaDataModel> users, double height, double width, {String? emptyMsg}) {
    return Container(
      width: width,
      height: height * .8,
      color: theme.colorBackground,
      child: users.length == 0
          ? Center(
              child: Container(
                child: Text(
                  'No Chats as of now !',
                  style: GoogleFonts.workSans(fontWeight: FontWeight.bold),
                ),
              ),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserWidget(users[index]);
              },
            ),
    );
  }
}

Stream checkOnline(String id) {
  return FirebaseDatabase.instance
      .reference()
      .child('User Information')
      .child(id)
      .child('isOnline')
      .onValue;
}

class UserWidget extends StatefulWidget {
  ChatMetaDataModel user;
  UserWidget(this.user);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  bool isOnline = false;
  var onlineListener;

  @override
  void dispose() {
    super.dispose();
    if (onlineListener != null) onlineListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    onlineListener = checkOnline((widget.user.uID ?? "")).listen((event) {
      setState(() {
        isOnline = event.snapshot.value ?? false;
        if (isOnline) {
          if (!onlineUsersMeta.contains(widget.user)) {
            onlineUsersMeta.add(widget.user);
            onlineUsersMeta.sort((a, b) {
              if (((a.lastReceived ?? 0) > (b.lastReceived ?? 0) &&
                      (a.lastReceived ?? 0) > (b.lastSent ?? 0)) ||
                  ((a.lastSent ?? 0) > (b.lastSent ?? 0) && (a.lastSent ?? 0) > (b.lastReceived ?? 0))) {
                return -1;
              } else {
                return 1;
              }
            });
          }
        } else {
          onlineUsersMeta.remove(widget.user);
        }
      });
    });
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SocialMediaChat(
              uid: widget.user.uID ?? "",
              data: widget.user.user ?? UserInformation(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 12,
            top: 10,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(widget.user.user?.imageUrl ?? "")
 /*                         image: widget.user.user.imageUrl != null
                              ? CachedNetworkImageProvider(widget.user.user?.imageUrl ?? "")
                              : AssetImage ('assets/profile.png')*/
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: widget.user.user!.isImageVisible ? 0.0 : 4.0,
                            sigmaY:
                                widget.user.user!.isImageVisible ? 0.0 : 4.0),
                        child: Container(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * .05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width * .7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.user.user!.name ?? "",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            isOnline ?? false
                                ? Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                    size: 10,
                                  )
                                : Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                    size: 10,
                                  )
                          ],
                        ),
                      ),
                      widget.user.isTyping ?? false
                          ? Text("Typing...",
                              style: TextStyle(color: Colors.pinkAccent))
                          : Container(
                              width: width * .66,
                              child: Text(
                                  (widget.user.lastMsg!.startsWith('#')
                                          ? 'You: ' : '') +
                                      ((widget.user.lastMsg != "")
                                          ? widget.user.lastMsg!.substring(1)
                                          : ""),
                                  style: (widget.user.lastSeen ?? 0) <
                                          (widget.user.lastReceived ?? 0)
                                      ? TextStyle(fontWeight: FontWeight.bold)
                                      : TextStyle(color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            )
                    ],
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
