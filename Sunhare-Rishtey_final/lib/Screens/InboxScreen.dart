import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Providers/BlockedUsersProvider.dart';
import 'package:matrimonial_app/Providers/UserRequestProvider.dart';
import 'package:matrimonial_app/Providers/allUser.dart';
import 'package:matrimonial_app/Providers/ContactsProvider.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/Screens/AcceptInvitationScreen.dart';
import 'package:matrimonial_app/Screens/ViewProfileScreen.dart';
import 'package:matrimonial_app/Screens/banner_ads_view.dart';
import 'package:matrimonial_app/Utils/ChatUtils.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'PremiumPlanScreen.dart';
import 'SocialMediaChatRoom.dart';

class InboxScreen extends StatefulWidget {
  final int initialIndex;
  InboxScreen({this.initialIndex = 0});

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  bool isLoading = false;
  List<UserInformation> reqUser = [];
  String id = "";
  List<UserInformation> allUsers = [];
  UserInformation currentUser = UserInformation();
  bool isPremium = false;

  BlockedUsersProvider? blockedUsersProvider;
  ContactProvider? contactProvider;
  UserRequestProvider? userRequestProvider;

  List<UserInformation> acceptedUsers = [];
  List<UserInformation> pendingUsers = [];
  getPendingAndAcceptedRequests() {
    acceptedUsers.addAll(userRequestProvider!.acceptedUserData);
    pendingUsers.addAll(userRequestProvider!.pendingUserData);
    getSentRequest(userRequestProvider!);
    getDeletedRequest(userRequestProvider!);
    userRequestProvider!.addListener(() {
      acceptedUsers.clear();
      pendingUsers.clear();
      acceptedUsers.addAll(userRequestProvider!.acceptedUserData);
      pendingUsers.addAll(userRequestProvider!.pendingUserData);
      sentIDs.removeWhere(
          (element) => userRequestProvider!.acceptedUsers.contains(element));
      sentIDs.removeWhere(
          (element) => userRequestProvider!.pendingUsers.contains(element));
      setState(() {});
    });
  }

  List<String> sentIDs = [];
  List<UserInformation> sentRequestUsers = [];
  getSentRequest(UserRequestProvider userRequestProvider) {
    FirebaseDatabase.instance
        .reference()
        .child('userReq')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      List sortable = [];
      sentIDs = [];
      Map<String, UserInformation> forSorting = {};
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        data.forEach((key, value) {
          if (value is bool) {
            sentIDs.add(key);
          } else {
            Map data = value as Map;
            data['uid'] = key;
            sortable.add(data);
          }
        });

        sortable.sort((a, b) => a['time'].compareTo(b['time']));
        sortable.forEach((data) {
          sentIDs.insert(0, data['uid']);
        });

        sentIDs.removeWhere((element) =>
            userRequestProvider.acceptedUsers.contains(element) ||
            userRequestProvider.pendingUsers.contains(element));

/*      pendingUsers.forEach((element) {
          if (sentIDs.contains(element.id)) {
            sentIDs.remove(element.id);
            FirebaseDatabase.instance
                .reference()
                .child('Connection Requests')
                .child(FirebaseAuth.instance.currentUser!.uid)
                .child(element.id)
                .update({
              'accepted': true,
              'time': DateTime.now().millisecondsSinceEpoch
            });

            FirebaseDatabase.instance
                .reference()
                .child('Connection Requests')
                .child(element.id)
                .child(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'accepted': true,
              'time': DateTime.now().millisecondsSinceEpoch
            }).then((value) {
              setState(() {
                isLoading = false;
              });

              sendNotificationsByUserID(
                  element.id, currentUser.name, 'Accepted your request',
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  target: Constants.USER_ACCEPT_REQUEST);

              var theirChatRef = FirebaseDatabase.instance
                  .reference()
                  .child("ChatRoomPersonal")
                  .child(element.id)
                  .child(FirebaseAuth.instance.currentUser!.uid);
              var myChatRef = FirebaseDatabase.instance
                  .reference()
                  .child("ChatRoomPersonal")
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .child(element.id);

              var theirMetaRef = FirebaseDatabase.instance
                  .reference()
                  .child("PersonalChatsPersons")
                  .child(element.id)
                  .child(FirebaseAuth.instance.currentUser!.uid);
              var myMetaRef = FirebaseDatabase.instance
                  .reference()
                  .child("PersonalChatsPersons")
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .child(element.id);

              final ref = FirebaseDatabase.instance
                  .reference()
                  .child("ChatRoomPersonal");
              final key = ref.push().key;
              String time = DateTime.now().toIso8601String();
              String msg = "I am interested in your profile.";
              myChatRef.child(key).update(
                  {'message': msg, "uid": currentUser.id, "timeStamp": time});

              theirChatRef.child(key).update({
                'message': msg,
                "uid": currentUser.id,
                "timeStamp": DateTime.now().toIso8601String()
              });

              myMetaRef.child("lastMsg").set("#$msg");
              theirMetaRef.child("lastMsg").set("!$msg");
              if (reqUser.length == 1) {
                setState(() {});
              }
            });
          }
        });*/

        allUsers.forEach((element) {
          if (sentIDs.contains(element.id)) {
            UserInformation temp = element;
            temp.isImageVisible = element.visibility == 'All Member' ||
                (element.visibility == 'Premium Members only' && (currentUser.isPremium ?? false)) ||
                (element.visibility == 'Connected Members' &&
                    userRequestProvider.checkConnection(element.id));
            forSorting[(element.id ?? "")] = temp;
          }
        });
        sentRequestUsers = [for (String sentID in sentIDs) (forSorting[sentID] ?? UserInformation())];
        sentRequestUsers.removeWhere((element) => element.name == null);
        forSorting.clear();
      }
      setState(() {});
    });
  }

  List<UserInformation> deletedUsers = [];
  getDeletedRequest(UserRequestProvider userRequestProvider) {
    FirebaseDatabase.instance
        .reference()
        .child('deleted')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      List<String> deletedIDs = [];
      List sortable = [];
      Map<String, UserInformation> forSorting = {};

      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        data.forEach((key, value) {
          if (value is bool) {
            deletedIDs.add(key);
          } else {
            Map data = value as Map;
            data['uid'] = key;
            sortable.add(data);
          }
        });
        sortable.sort((a, b) => a['time'].compareTo(b['time']));
        sortable.forEach((data) {
          deletedIDs.insert(0, data['uid']);
        });

        allUsers.forEach((element) {
          if (deletedIDs.contains(element.id)) {
            bool isVisible = element.visibility == 'All Member' ||
                (element.visibility == 'Premium Members only' &&
                    (currentUser.isPremium ?? false)) ||
                (element.visibility == 'Connected Members' &&
                    userRequestProvider.checkConnection(element.id));
            UserInformation temp = element;
            temp.isImageVisible = isVisible;
            forSorting[(element.id ?? "")] = temp;
          }
        });

        deletedUsers = [
          for (String deletedID in deletedIDs) forSorting[deletedID] ?? UserInformation()
        ];
        deletedUsers.removeWhere((element) => element.name == null);
        forSorting.clear();
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    blockedUsersProvider =
        Provider.of<BlockedUsersProvider>(context, listen: false);
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    userRequestProvider =
        Provider.of<UserRequestProvider>(context, listen: false);
    id = FirebaseAuth.instance.currentUser!.uid;
    allUsers = Provider.of<AllUser>(context, listen: false).allUsers;
    currentUser = Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    contacts = Provider.of<ContactProvider>(context, listen: false).contacts;
    isPremium = currentUser.premiumModel!.isActive != null
        ? currentUser.premiumModel!.isActive ?? false
        : false;

    getPendingAndAcceptedRequests();

    tabController = new TabController(
        length: 4, vsync: this, initialIndex: widget.initialIndex);
    super.initState();
  }

  _acceptReject(double width, double height, String id,String name, String image) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      // ignore: deprecated_member_use
      OutlinedButton(
        // color: Colors.green[400],
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.green[400],
        ),
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          FirebaseDatabase.instance
              .reference()
              .child('Connection Requests')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .child(id)
              .update({
            'accepted': true,
            'time': DateTime.now().millisecondsSinceEpoch
          });

          FirebaseDatabase.instance
              .reference()
              .child('Connection Requests')
              .child(id)
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'accepted': true,
            'time': DateTime.now().millisecondsSinceEpoch
          }).then((value) {
            setState(() {
              isLoading = false;
            });

            sendNotificationsByUserID(
                id, currentUser.name ?? "", 'Accepted your request',
                userId: FirebaseAuth.instance.currentUser!.uid,
                target: Constants.USER_ACCEPT_REQUEST);

            ChatUtils chatUtils = new ChatUtils(
              senderId: currentUser.id ?? "",
              receiverId: id,
              senderName: currentUser.name ?? "",
              fetchTokens: false,
            );
            chatUtils.sendMessage("I am interested in your profile.");

            if (reqUser.length == 1) {
              setState(() {
                reqUser.clear();
              });
            }
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => AcceptInvitationScreen(name: name,image: image,isPremium: currentUser.isPremium)));
        },
        child: Text(
          'Accept',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      // ignore: deprecated_member_use
      OutlinedButton(
        // color: Colors.red[400],
        style: OutlinedButton.styleFrom(
            backgroundColor: theme.colorPrimary,
        ),
        onPressed: () {
          FirebaseDatabase.instance
              .reference()
              .child('Connection Requests')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .child(id)
              .remove()
              .then((value) {
            setState(() {
              sendNotificationsByUserID (
                  id, 'Declined', '${currentUser.name} declined your request'
              );
              isLoading = false;
            });
            if (reqUser.length == 1) {
              setState(() {
                reqUser.clear();
              });
            }
          });
          FirebaseDatabase.instance
              .reference()
              .child('deleted')
              .child(id)
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({"time": DateTime.now().millisecondsSinceEpoch});
        },
        child: Text(
          'Reject',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  List<String> contacts = [];

  Future increaseContactAndUpdate(String id) async {
    FirebaseDatabase.instance
        .reference()
        .child('Contacts viewed')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({'$id': true});
  }

  showPopUp(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Container(
          child: Text('Do you really wants to use your one cotanct to see .'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              increaseContactAndUpdate(id).then((value) {
                //  contacts.add(id);
                log('working');
                Provider.of<ContactProvider>(context, listen: false)
                    .addContacts(id);
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: 'Contact Unlocked');
              });
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  Widget _removePopup(String acceptedUserId) => ElevatedButton(
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          final db = FirebaseDatabase.instance.reference();

          db.child('userReq').child(id).child(acceptedUserId).remove();

          db
              .child('deleted')
              .child(acceptedUserId)
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({'time': DateTime.now().millisecondsSinceEpoch});
          db.child('userReq').child(acceptedUserId).child(id).remove();
          db.child('myMatches').child(id).update({"$acceptedUserId": true});
          db.child('myMatches').child(acceptedUserId).update({id: true});
          db
              .child('Connection Requests')
              .child(acceptedUserId)
              .child(id)
              .remove()
              .then((value) {
            setState(() {
              isLoading = false;
            });
          });
          db
              .child('Connection Requests')
              .child(id)
              .child(acceptedUserId)
              .remove()
              .then((value) {
            setState(() {
              if (acceptedUsers.length == 1 && pendingUsers.length == 0) {
                acceptedUsers.clear();
              }
            });
          });
        },
        child: Text("Remove"),
      );

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  bottom: 12,
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
                            color: theme.colorCompanion,
                            width: 1,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Received (${pendingUsers.length})"),
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
                          border:
                              Border.all(color: theme.colorCompanion, width: 1),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Accepted (${acceptedUsers.length})"),
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
                          border:
                              Border.all(color: theme.colorCompanion, width: 1),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              "Sent requests (${sentRequestUsers.length})"),
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
                          child:
                              Text("Deleted requests (${deletedUsers.length})"),
                        ),
                      ),
                    ),
                  ],
                  controller: tabController,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: HexColor('b3e5fc'),
                ),
                width: width,
                height: height * .045,
                alignment: Alignment.center,
                child: Text(
                  'IF YOU HAVEN’T FOUND IT YET, KEEP LOOKING.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              BannerAdView(),
              SizedBox(
                height: height * .01,
              ),

              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    requestCard(),
                    acceptedCard(),
                    sentRequest(),
                    deletedRequest()
                  ],
                  controller: tabController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  acceptedCard() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return
      acceptedUsers.length == 0
        ? Center(
            child: Text(
              'No requests as of now !',
              style: GoogleFonts.ptSans(
                fontSize: 14,
              ),
            ),
          )
        :
    Container(
            width: width,
            height: height * .742,
            child: ListView.builder(
              itemCount: acceptedUsers.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (blockedUsersProvider!.isBlocked(acceptedUsers[index].id ?? "")) {
                      Fluttertoast.showToast(
                          msg: "You've been blocked by this user");
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewProfileScreen(
                          acceptedUsers,
                          index,
                          currentUser.isPremium ?? false,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * .015,
                              ),
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          acceptedUsers[index].imageUrl ?? ""),
                                      fit: BoxFit.cover),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX:
                                            acceptedUsers[index].isImageVisible
                                                ? 0.0
                                                : 8.0,
                                        sigmaY:
                                            acceptedUsers[index].isImageVisible
                                                ? 0.0
                                                : 8.0),
                                    child: Container(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    acceptedUsers[index].name!.toUpperCase() ??
                                        '',
                                    style: GoogleFonts.ptSans(
                                      color: theme.colorPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * .03,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * .005,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${acceptedUsers[index].height ?? 'height'} ',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * .03,
                                  ),
                                  Text(
                                    ' ${acceptedUsers[index].workingAs ?? 'designation'}',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * .005,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${acceptedUsers[index].motherTongue ?? 'not provided'}',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * .03,
                                  ),
                                  Text(
                                    '${acceptedUsers[index].state ?? 'State'}, ${acceptedUsers[index].city ?? 'City'}',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * .01,
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              SizedBox(
                                height: height * .01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (isPremium) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SocialMediaChat(
                                                      uid: acceptedUsers[index].id ?? "",
                                                      data: acceptedUsers[index],
                                                    )));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PremiuimPlanScreen()));
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              MdiIcons.chat,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Text',
                                           style: GoogleFonts.workSans(fontSize: 13),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      contactProvider!.getContact(
                                          context,
                                          acceptedUsers[index],
                                          currentUser,
                                          isPremium, onSuccess: () {
                                        setState(() {});
                                        launchWhatsApp(
                                            acceptedUsers[index].phone ?? "",
                                            currentUser);
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              MdiIcons.whatsapp,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'WhatsApp',
                                          style: GoogleFonts.workSans(
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      contactProvider!.getContact(
                                          context,
                                          acceptedUsers[index],
                                          currentUser,
                                          isPremium, onSuccess: () {
                                        setState(() {});
                                        launch(
                                            "tel://${acceptedUsers[index].phone}");
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue[300],
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              MdiIcons.phone,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Call',
                                          style: GoogleFonts.workSans(
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: height * .02,
                          right: width * .09,
                          child: _removePopup(acceptedUsers[index].id ?? "")),
                    ],
                  ),
                );
              },
            ),
          );
  }

  deletedRequest() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return deletedUsers.length == 0
        ? Center(
            child: Text(
              'No requests sent !',
              style: GoogleFonts.ptSans(
                // color: Colors.white,
                fontSize: 14,
              ),
            ),
          )
        : Container(
            width: width,
            height: height * .742,
            child: ListView.builder(
              itemCount: deletedUsers.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (blockedUsersProvider!.isBlocked(deletedUsers[index].id ?? "")) {
                      Fluttertoast.showToast(
                          msg: "You've been blocked by this user");
                      return;
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewProfileScreen(
                              deletedUsers,
                              index,
                              currentUser.isPremium ?? false,
                            )));
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .015,
                          ),

                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      deletedUsers[index].imageUrl ?? ""),
                                  fit: BoxFit.cover),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: deletedUsers[index].isImageVisible
                                        ? 0.0
                                        : 8.0,
                                    sigmaY: deletedUsers[index].isImageVisible
                                        ? 0.0
                                        : 8.0),
                                child: Container(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                deletedUsers[index].name!.toUpperCase() ?? '',
                                style: GoogleFonts.ptSans(
                                  color: theme.colorPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: width * .03,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .005,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${deletedUsers[index].height ?? 'height'} ',
                                style: GoogleFonts.ptSans(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: width * .03,
                              ),
                              Text(
                                ' ${deletedUsers[index].workingAs ?? 'designation'}',
                                style: GoogleFonts.ptSans(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .005,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${deletedUsers[index].motherTongue ?? 'not provided'}',
                                style: GoogleFonts.ptSans(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: width * .03,
                              ),
                              Text(
                                '${deletedUsers[index].state ?? 'State'}, ${deletedUsers[index].city ?? 'City'}',
                                style: GoogleFonts.ptSans(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (isPremium) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SocialMediaChat(
                                                  uid: deletedUsers[index].id ?? "",
                                                  data: deletedUsers[index],
                                                )));
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PremiuimPlanScreen()));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          MdiIcons.chat,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Text',
                                      style: GoogleFonts.workSans(fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  contactProvider!.getContact(
                                      context,
                                      deletedUsers[index],
                                      currentUser,
                                      isPremium, onSuccess: () {
                                    setState(() {});
                                    launchWhatsApp(
                                        deletedUsers[index].phone ?? "", currentUser);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          MdiIcons.whatsapp,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'WhatsApp',
                                      style: GoogleFonts.workSans(fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  contactProvider!.getContact(
                                      context,
                                      deletedUsers[index],
                                      currentUser,
                                      isPremium, onSuccess: () {
                                    setState(() {});
                                    launch(
                                        "tel://${deletedUsers[index].phone}");
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue[300],
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          MdiIcons.phone,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Call',
                                      style: GoogleFonts.workSans(fontSize: 13),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: height * .01,
                          ),
                          // Divider(

                          SizedBox(
                            height: height * .02,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  sentRequest() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return sentRequestUsers.length == 0
        ? Center(
            child: Text(
              'No requests sent !',
              style: GoogleFonts.ptSans(
                // color: Colors.white,
                fontSize: 14,
              ),
            ),
          )
        : Container(
            width: width,
            height: height * .742,
            child: ListView.builder(
              itemCount: sentRequestUsers.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (blockedUsersProvider!.isBlocked(sentRequestUsers[index].id ?? "")) {
                      Fluttertoast.showToast(
                          msg: "You've been blocked by this user");
                      return;
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewProfileScreen(
                              sentRequestUsers,
                              index,
                              currentUser.isPremium ?? false,
                            )));
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .015,
                          ),
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      sentRequestUsers[index].imageUrl ?? ""),
                                  fit: BoxFit.cover),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX:
                                        sentRequestUsers[index].isImageVisible
                                            ? 0.0
                                            : 8.0,
                                    sigmaY:
                                        sentRequestUsers[index].isImageVisible
                                            ? 0.0
                                            : 8.0),
                                child: Container(),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: height * .02,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                sentRequestUsers[index].name!.toUpperCase() ??
                                    '',
                                style: GoogleFonts.ptSans(
                                  color: theme.colorPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: width * .03,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .005,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${sentRequestUsers[index].height ?? 'height'} ',
                                style: GoogleFonts.ptSans(
                                  // color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: width * .03,
                              ),
                              Text(
                                ' ${sentRequestUsers[index].workingAs ?? 'designation'}',
                                style: GoogleFonts.ptSans(
                                  // color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .005,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${sentRequestUsers[index].motherTongue ?? 'not provided'}',
                                style: GoogleFonts.ptSans(
                                  // color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: width * .03,
                              ),
                              Text(
                                '${sentRequestUsers[index].state ?? 'State'}, ${sentRequestUsers[index].city ?? 'City'}',
                                style: GoogleFonts.ptSans(
                                  // color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: height * .01,
                          ),
                          OutlinedButton(
                            // color: Colors.red[400],
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                            ),
                            onPressed: () {
                              final String id =
                                  FirebaseAuth.instance.currentUser!.uid;
                              bool? req1, req2, req3;
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('Connection Requests')
                                  .child(sentRequestUsers[index].id ?? "")
                                  .child(id)
                                  .remove()
                                  .then((value) {
                                req1 = true;
                                if ((req1??false) && (req2 ?? false) && (req3 ?? false)) {
                                  Fluttertoast.showToast(
                                      msg: 'Request cancelled.');
                                }
                              });
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('userReq')
                                  .child(sentRequestUsers[index].id ?? "")
                                  .child(id)
                                  .remove()
                                  .then((value) {
                                req2 = true;
                                if ((req1 ?? false) && (req2 ?? false) && (req3 ?? false)) {
                                  Fluttertoast.showToast(
                                      msg: 'Request cancelled.');
                                }
                              });
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('userReq')
                                  .child(id)
                                  .child(sentRequestUsers[index].id ?? "")
                                  .remove()
                                  .then((value) {
                                req3 = true;
                                if ((req1??false) && (req2 ?? false) && (req3??false)) {
                                  Fluttertoast.showToast(
                                      msg: 'Request cancelled.');
                                }
                              });
                            },
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          Divider(thickness: 1),
                          // SizedBox(
                          //   height: height * .03,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (isPremium) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SocialMediaChat(
                                                  uid: sentRequestUsers[index].id ?? "",
                                                  data: sentRequestUsers[index],
                                                )));
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PremiuimPlanScreen()));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          MdiIcons.chat,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Text',
                                      style: GoogleFonts.workSans(fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  contactProvider!.getContact(
                                      context,
                                      sentRequestUsers[index],
                                      currentUser,
                                      isPremium, onSuccess: () {
                                    setState(() {});
                                    launchWhatsApp(
                                        sentRequestUsers[index].phone ?? "",
                                        currentUser);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          MdiIcons.whatsapp,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'WhatsAppp',
                                      style: GoogleFonts.workSans(fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  contactProvider!.getContact(
                                      context,
                                      sentRequestUsers[index],
                                      currentUser,
                                      isPremium, onSuccess: () {
                                    setState(() {});
                                    launch("tel://${sentRequestUsers[index].phone}");
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue[300],
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          MdiIcons.phone,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Call',
                                      style: GoogleFonts.workSans(fontSize: 13),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: height * .01,
                          ),
                          // Divider(

                          SizedBox(
                            height: height * .02,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  requestCard() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return pendingUsers.length == 0
        ? Center(
            child: Text(
              'No requests as of now !',
              style: GoogleFonts.ptSans(
                fontSize: 14,
              ),
            ),
          )
        : Container(
            width: width,
            height: height * .8,
            child: ListView.builder(
              itemCount: pendingUsers.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (blockedUsersProvider!.isBlocked(pendingUsers[index].id ?? "")) {
                      Fluttertoast.showToast(
                          msg: "You've been blocked by this user");
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewProfileScreen(
                          pendingUsers,
                          index,
                          currentUser.isPremium ?? false,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: height * .02),
                              Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(140),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          pendingUsers[index].imageUrl ?? ""),
                                      fit: BoxFit.cover),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(140),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX:
                                            pendingUsers[index].isImageVisible
                                                ? 0.0
                                                : 8.0,
                                        sigmaY:
                                            pendingUsers[index].isImageVisible
                                                ? 0.0
                                                : 8.0),
                                    child: Container(),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * .02),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    pendingUsers[index].name!.toUpperCase() ??
                                        '',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: width * .03),
                                ],
                              ),
                              SizedBox(height: height * .005),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${pendingUsers[index].height ?? 'height'} ',
                                    style: GoogleFonts.ptSans(fontSize: 14),
                                  ),
                                  SizedBox(width: width * .03),
                                  Container(
                                    width: width * .5,
                                    child: Text(
                                      ' ${pendingUsers[index].workingAs ?? 'designation'}',
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: GoogleFonts.ptSans(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * .005),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${pendingUsers[index].motherTongue ?? 'not provided'}',
                                    style: GoogleFonts.ptSans(fontSize: 14),
                                  ),
                                  SizedBox(width: width * .03),
                                  Text(
                                    '${pendingUsers[index].state ?? 'State'}, ${pendingUsers[index].city ?? 'City'}',
                                    style: GoogleFonts.ptSans(fontSize: 14),
                                  ),
                                ],
                              ),
                              _acceptReject(height, width, pendingUsers[index].id ?? "",pendingUsers[index].name ?? "",pendingUsers[index].imageUrl  ?? ""),
                              Divider(thickness: 1),
                              SizedBox(height: height * .01),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (isPremium) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SocialMediaChat(
                                                    uid: pendingUsers[index].id ?? "",
                                                    data: pendingUsers[index]),
                                          ),
                                        );
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PremiuimPlanScreen()),
                                        );
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(MdiIcons.chat,
                                                color: Colors.white, size: 35),
                                          ),
                                        ),
                                        Text(
                                          'Text',
                                          style: GoogleFonts.workSans(
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      contactProvider!.getContact(
                                          context,
                                          pendingUsers[index],
                                          currentUser,
                                          isPremium, onSuccess: () {
                                        setState(() {});
                                        launchWhatsApp(pendingUsers[index].phone ?? "", currentUser);
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(MdiIcons.whatsapp,
                                                color: Colors.white, size: 35),
                                          ),
                                        ),
                                        Text(
                                          'WhatsApp',
                                          style: GoogleFonts.workSans(
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      contactProvider!.getContact(
                                          context,
                                          pendingUsers[index],
                                          currentUser,
                                          isPremium, onSuccess: () {
                                        setState(() {});
                                        launch("tel://${pendingUsers[index].phone}");
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue[300],
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(MdiIcons.phone,
                                                color: Colors.white, size: 35),
                                          ),
                                        ),
                                        Text(
                                          'Call',
                                          style: GoogleFonts.workSans(
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: height * .02),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
