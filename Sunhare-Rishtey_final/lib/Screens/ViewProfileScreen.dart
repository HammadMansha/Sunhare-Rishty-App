import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Providers/BlockedUsersProvider.dart';
import 'package:matrimonial_app/Providers/allUser.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/Providers/UserRequestProvider.dart';
import 'package:matrimonial_app/Screens/banner_ads_view.dart';
import 'package:matrimonial_app/Utils/ChatUtils.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:matrimonial_app/customs/widgets/PersonCard.dart';
import 'package:matrimonial_app/models/commonBetweenModel.dart';
import 'package:matrimonial_app/models/parternerInfoModel.dart';
import 'package:matrimonial_app/models/youandme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Providers/ContactsProvider.dart';
import '/models/UserModel.dart';
import 'package:provider/provider.dart';
import '/main.dart';
import 'PremiumPlanScreen.dart';
import 'SocialMediaChatRoom.dart';
import 'allPicturesScreen.dart';

ContactProvider ref = ContactProvider();
BlockedUsersProvider blockedUsersProvider = BlockedUsersProvider();
UserRequestProvider userRequestProvider = UserRequestProvider();
double height = 0.0, width = 0.0;

gotoPremiumPlanScreen(context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PremiuimPlanScreen(),
    ),
  );
}

bool isPremium = false;

Future getImages(List images, UserInformation user) async {
  images.add(user.imageUrl);
  final data = await FirebaseDatabase.instance
      .reference()
      .child('Images')
      .child(user.id ?? "")
      .once();
  final mappedData = data.snapshot.value as Map;
  if (data.snapshot.value != null) {
    mappedData.forEach((key, value) {
      if (value['isVerified'] != null && value['isVerified'])
        images.add(value['imageURL']);
    });
  }
}

Future<List> getHobbiesAndMore(String type, String userID) async {
  var data = await FirebaseDatabase.instance
      .reference()
      .child('HobiesAndMore')
      .child(userID)
      .child(type)
      .once();
  if (data.snapshot.value != null)
    return data.snapshot.value as List;
  else
    return [];
}

UserInformation currUser = UserInformation();

// ignore: must_be_immutable
class ViewProfileScreen extends StatefulWidget {
  List<UserInformation>? users;
  final int index;
  final bool isPremium;
  final String userId;

  ViewProfileScreen(this.users, this.index, this.isPremium, [this.userId = "-99"]);
  @override
  _ViewProfileScreenNewState createState() => _ViewProfileScreenNewState();
}

class _ViewProfileScreenNewState extends State<ViewProfileScreen> {
  bool isMatchingAny = false;
  var currentPosition = 0;

  CarouselController buttonCarouselController = CarouselController();

  int last = 0;
  nothing() {}

  bool isFetchingUser = false;

  @override
  void initState() {

    userRequestProvider =
        Provider.of<UserRequestProvider>(context, listen: false);
    currentPosition = widget.index;
    currUser = Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    ref = Provider.of<ContactProvider>(context, listen: false);
    blockedUsersProvider =
        Provider.of<BlockedUsersProvider>(context, listen: false);
    isFetchingUser = widget.users!.isEmpty && widget.userId != "-99";

    if (isFetchingUser) {
      Provider.of<AllUser>(context, listen: false)
          .getUser(widget.userId)
          .then((value) {
        widget.users = [value];
        setState(() {
          isFetchingUser = false;
        });
      });
    } else {
      last = widget.users!.length - 1;
    }

    isPremium = widget.isPremium;

    super.initState();
  }

  void didChangeDependencies() {
    ref = Provider.of<ContactProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return isFetchingUser
        ? SpinKitThreeBounce(
            color: theme.colorPrimary,
          )
        : Stack(
            children: [
              CarouselSlider(
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  height: height,
                  enableInfiniteScroll: false,
                  initialPage: currentPosition,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    currentPosition = index;
                    setState(() {});
                  },
                ),
                items: widget.users!.map((user) {
                  return Builder(
                    builder: (BuildContext context) {
                      return UserInfoWidget(user);
                    },
                  );
                }).toList(),
              ),
              currentPosition != 0
                  ? Positioned(
                      left: -90,
                      top: height / 2,
                      child: GestureDetector(
                        onTap: () {
                          buttonCarouselController.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 24, bottom: 24, right: 6, left: 96),
                          decoration: BoxDecoration(
                            color: Color(0xddfffffff),
                            borderRadius: BorderRadius.circular(500),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 100.0,
                                  spreadRadius: 0,
                                  offset: Offset(-1.0, 0))
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ))
                  : Container(),
              currentPosition != last
                  ? Positioned(
                      right: -90,
                      top: height / 2,
                      child: GestureDetector(
                        onTap: () {
                          buttonCarouselController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 24, bottom: 24, left: 6, right: 96),
                          decoration: BoxDecoration(
                            color: Color(0xddfffffff),
                            borderRadius: BorderRadius.circular(500),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400]!,
                                blurRadius: 100.0, // soften the shadow
                                spreadRadius: 0, //extend the shadow
                                offset: Offset(
                                  1.0, // Move to right 10  horizontally
                                  0, // Move to bottom 10 Vertically
                                ),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ))
                  : Container(),
            ],
          );
  }
}

class UserInfoWidget extends StatefulWidget {
  final UserInformation user;

  UserInfoWidget(this.user);

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  List<String> images = [];
  bool isMatchingAny = false;

  List hobbies = [];
  List intrests = [];
  List favMusic = [];
  List sportsFitness = [];
  List favCousine = [];
  List dressStyle = [];

  List<CommonBetween> youAndMyMatches = [];
  List<YouAndMe> youAndMeMatches = [];
  int totalPreferences = 0;
  int matchedPreferences = 0;

  bool isVisible = false;
  UserInformation user = UserInformation();

  bool isOnline = false;
  bool isRequestSent = false;
  bool isRequestAccepted = false;
  bool isGotRequestFromUser = false;
  var onlineListener, requestListener, connectionListener;

  checkOnline() {
    onlineListener = FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(widget.user.id ?? "")
        .child('isOnline')
        .onValue
        .listen((event) {
      setState(() {
        isOnline = (event.snapshot.value ?? false) as bool;
      });
    });
  }

  checkRequestStatus() {
    requestListener = FirebaseDatabase.instance
        .reference()
        .child('Connection Requests')
        .child(widget.user.id ?? "")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      isRequestSent = event.snapshot.value != null;
      var value = event.snapshot.value as Map;
      if (isRequestSent) {
        if (value is bool) {
          isRequestAccepted = (event.snapshot.value ?? false) as bool;
        } else {
          isRequestAccepted = (value['accepted'] ?? false) as bool;
        }
      }
      isVisible = widget.user.visibility == 'All Member' ||
          (widget.user.visibility == 'Premium Members only' && isPremium) ||
          (widget.user.visibility == 'Connected Members' && isRequestAccepted);
      setState(() {});
    });
  }

  @override
  initState() {
    print("idu==>>${widget.user.id}");
    user = widget.user;
    isVisible = user.visibility == 'All Member' ||
        (user.visibility == 'Premium Members only' && isPremium) ||
        (user.visibility == 'Connected Members' && isRequestAccepted);
    getHobbiesAndMore('Hobbies', user.id ?? "").then((value) => setState(() {
          hobbies = value;
        }));
    getHobbiesAndMore('Intrests', user.id ?? "").then((value) => setState(() {
          intrests = value;
        }));
    getHobbiesAndMore('music', user.id ?? "").then((value) => setState(() {
          favMusic = value;
        }));
    getHobbiesAndMore('Fitness', user.id ?? "").then((value) => setState(() {
          sportsFitness = value;
        }));
    getHobbiesAndMore('Cousine', user.id ?? "").then((value) => setState(() {
          favCousine = value;
        }));
    getHobbiesAndMore('dressStyle', user.id ?? "").then((value) => setState(() {
          dressStyle = value;
        }));

    getImages(images, user).then((value) => setState(() {}));
    checkMatches(user);
    checkOnline();
    checkRequestStatus();

    FirebaseDatabase.instance
        .reference()
        .child('Visitors')
        .child(user.id ?? "")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((event) {

          Map tempMapData = event.snapshot.value as Map;

      if (tempMapData == null || tempMapData.isEmpty) {
        FirebaseDatabase.instance
            .reference()
            .child('Visitors')
            .child(user.id ?? "")
            .update({'${FirebaseAuth.instance.currentUser!.uid}': true}).then(
                (value) {
          sendNotificationsByUserID(
              user.id ?? "",
              '${currUser.name} visited your profile.',
              "Take the first step. Connect with ${currUser.name}.",
              userId: FirebaseAuth.instance.currentUser!.uid,
              target: Constants.USER_ACCOUNT_VISITED);
        });
      }
    });

    isGotRequestFromUser = userRequestProvider.pendingUserData
            .where((element) => element.name == widget.user.name)
            .length >
        0;

    super.initState();
  }

  String generateFamilyDetails(UserInformation udrtImfo) {
    String familyDetails = '';
    if (user.familyType != null && user.familyType != '') {
      familyDetails += 'My family Type is ${user.familyType}, ';
    }
    if (user.affluenceLevel != null && user.affluenceLevel != '') {
      familyDetails += 'I belong to ${user.affluenceLevel} family. ';
    }

    if (user.fatherName != null && user.fatherName != '') {
      familyDetails += 'My father name is ${user.fatherName} ';
    }

    if (user.fatherStatus != null && user.fatherStatus != '') {
      familyDetails += 'and my father status is ${user.fatherStatus}, ';
    }

    if (user.motherName != null && user.motherName != '') {
      familyDetails += 'My mother name is ${user.motherName} ';
    }

    if (user.motherStatus != null && user.motherStatus != '') {
      familyDetails += 'and my mother status is ${user.motherStatus}, ';
    }

    familyDetails +=
        "I have ${user.brothers} Brother (unmarried) and ${user.sisters} Sisters (unmarried) and my Father gotra is ${user.fatherGautra} and mother gotra is ${user.motherGautra}. ";

    if (user.nativePlace != null && user.nativePlace != '') {
      familyDetails += 'My father\'s family is from ${user.nativePlace}.';
    }
    return familyDetails;
  }

  void onTapBtnSendRequest() {
    if (isGotRequestFromUser) {
      FirebaseDatabase.instance
          .reference()
          .child('Connection Requests')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(widget.user.id ?? "")
          .update({
        'accepted': true,
        'time': DateTime.now().millisecondsSinceEpoch
      });
      FirebaseDatabase.instance
          .reference()
          .child('Connection Requests')
          .child(widget.user.id ?? "")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'accepted': true,
        'time': DateTime.now().millisecondsSinceEpoch
      }).then((value) {
        sendNotificationsByUserID(
            widget.user.id ?? "", currUser.name ?? "", 'Accepted your request',
            userId: FirebaseAuth.instance.currentUser!.uid,
            target: Constants.USER_ACCEPT_REQUEST);

        ChatUtils chatUtils = new ChatUtils(
          senderId: currUser.id ?? "",
          receiverId: widget.user.id ?? "",
          senderName: currUser.name?? "",
          fetchTokens: false,
        );
        chatUtils.sendMessage("I am interested in your profile.");

        Fluttertoast.showToast(msg: 'Request Accepted');
      });
    } else {
      if (isRequestSent) {
        Fluttertoast.showToast(msg: 'Already sent');
      } else {
        setState(() {
          isRequestSent = true;
        });
        final String id = FirebaseAuth.instance.currentUser!.uid;

        FirebaseDatabase.instance
            .reference()
            .child('Connection Requests')
            .child(widget.user.id ?? "")
            .child(id)
            .update({
          'accepted': false,
          'time': DateTime.now().millisecondsSinceEpoch
        }).then((value) {
          Fluttertoast.showToast(msg: 'Request sent Successfully');
        });
        /* FirebaseDatabase.instance
            .reference()
            .child('Connection Requests')
            .child(widget.user.id)
            .update({id: false}).then((value) {
          Fluttertoast.showToast(msg: 'Request sent Successfully');
        }); */

        FirebaseDatabase.instance
            .reference()
            .child('userReq')
            .child(widget.user.id ?? "")
            .child(id)
            .update({
          'accepted': false,
          'time': DateTime.now().millisecondsSinceEpoch
        });
        FirebaseDatabase.instance
            .reference()
            .child('userReq')
            .child(id)
            .child(widget.user.id ?? "")
            .update({
          'accepted': false,
          'time': DateTime.now().millisecondsSinceEpoch
        }).then((value) {
          sendNotificationsByUserID(widget.user.id ?? "", 'New Connection Request',
              (currUser.name ?? "") + ' sent you request',
              userId: currUser.id ?? "", target: Constants.USER_SENT_REQUEST);

          ChatUtils chatUtils = new ChatUtils(
            senderId: currUser.id ?? "",
            receiverId: widget.user.id ?? "",
            senderName: currUser.name ?? "",
            fetchTokens: false,
          );
          chatUtils.sendMessage("I am interested in your profile.");
        });
      }
    }
  }

  @override
  void dispose() {
    if (onlineListener != null) {
      onlineListener.cancel();
    }
    if (requestListener != null) {
      requestListener.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 66,
        decoration: BoxDecoration(color: Colors.white54, boxShadow: [
          BoxShadow(
              color: Colors.black,
              offset: Offset(8.0, 5.0),
              blurRadius: 8.0,
              spreadRadius: 1.0),
          BoxShadow(
            color: Colors.white,
            offset: const Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          )
        ]),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  if (isPremium) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SocialMediaChat(
                          uid: user.id ?? "",
                          data: user,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PremiuimPlanScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: width * .2,
                  child: Column(
                    children: [
                      Icon(
                        MdiIcons.chat,
                        color: Colors.red,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Chat')
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  ref.getContact(context, widget.user, currUser, isPremium,
                      onSuccess: () {
                    setState(() {});
                    launchWhatsApp(widget.user.phone ?? "", currUser);
                  });
                },
                child: Container(
                  width: width * .2,
                  child: Column(
                    children: [
                      Icon(
                        MdiIcons.whatsapp,
                        color: Colors.red,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text('WhatsApp')
                    ],
                  ),
                ),
              ),
              SizedBox(),
              InkWell(
                onTap: () {
                  ref.getContact(context, widget.user, currUser, isPremium,
                      onSuccess: () {
                    setState(() {});
                    launch("tel://${user.phone}");
                  });
                },
                child: Container(
                  width: width * .2,
                  child: Column(
                    children: [
                      Icon(
                        MdiIcons.phone,
                        color: Colors.red,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Phone')
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  onTapBtnSendRequest();
                },
                child: Container(
                  width: width * .25,
                  child: Column(
                    children: [
                      if (isGotRequestFromUser || isRequestAccepted) ...[
                        Image(
                            color: Colors.red,
                            width: 28,
                            height: 28,
                            image: AssetImage('assets/handshake.png'))
                      ] else ...[
                        Transform.rotate(
                          angle: 95,
                          child: Icon(
                            isRequestSent
                                ? MdiIcons.navigation
                                : MdiIcons.navigationOutline,
                            color: Colors.red,
                          ),
                        )
                      ],
                      SizedBox(
                        height: 4,
                      ),
                      if (isGotRequestFromUser) ...[
                        Container(
                          alignment: Alignment.center,
                          width: width * 25,
                          child: Text('Accept'),
                        )
                      ] else if (isRequestAccepted) ...[
                        Container(
                          alignment: Alignment.center,
                          width: width * 25,
                          child: Text('Connected'),
                        )
                      ] else ...[
                        Container(
                          alignment: Alignment.center,
                          width: width * 25,
                          child: Text(isRequestSent ? 'Sent' : 'Send Request'),
                        )
                      ]
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                  onTap: () {
                    print("Id: " + (user.id ?? ""));
                    if (isVisible) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AllPicturesScreen(images),
                        ),
                      );
                    }
                  },
                  child: isVisible
                      ? Container(
                          height: height * .63,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(user.imageUrl ?? ""),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              gradient: LinearGradient(
                                colors: [Colors.black12, Colors.black54],
                                begin: Alignment.center,
                                stops: [0.4, 1],
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Stack(
                              children: [
                                user.isPremium ?? false
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                              color: theme.colorPrimary),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(MdiIcons.crown,
                                                    color: Colors.white),
                                                Text('Premium',
                                                    style: GoogleFonts.workSans(
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ))
                                    : Container(),
                                Positioned(
                                  right: 10,
                                  left: 20,
                                  bottom: 10,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          verificationPopup(
                                              user.isGovIdVerified ?? false,
                                              user.govVerifiedBy ?? ""),
                                          Text(
                                            user.name!.toUpperCase(),
                                            style: GoogleFonts.ptSans(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.height ?? '',
                                            style: GoogleFonts.ptSans(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .03,
                                          ),
                                          Text(
                                            user.workingAs ?? 'Not given',
                                            style: GoogleFonts.ptSans(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * .005,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.motherTongue ?? 'language',
                                            style: GoogleFonts.ptSans(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .03,
                                          ),
                                          Container(
                                            width: width * .7,
                                            child: Text(
                                              (user.state ?? 'State') +
                                                  ', ' +
                                                  (user.city ?? 'City'),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * .015,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 15,
                                  top: height * .08,
                                  child: Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.symmetric(
                                      // horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                      color: Colors.black45,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          MdiIcons.camera,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: width * .01,
                                        ),
                                        Text(
                                          images.length.toString(),
                                          style: GoogleFonts.ptSans(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: width * .01,
                                  top: height * .51,
                                  child: Container(
                                    width: width * 0.2,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: isOnline
                                        ? Row(
                                            children: [
                                              Icon(
                                                MdiIcons.circle,
                                                size: 10,
                                                color: Colors.green,
                                              ),
                                              Text(
                                                'Online',
                                                style: GoogleFonts.workSans(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          )
                                        : Container(),
                                  ),
                                ),
                                Positioned(
                                  left: 18,
                                  top: 20,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white54,
                                      child: Icon(
                                        MdiIcons.arrowLeft,
                                        color: Colors.black87,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 28,
                                  top: height * .08 + 40,
                                  child: InkWell(
                                    onTap: () {
                                      bottomSheet(
                                          context, widget.user, currUser,
                                          isBlocked: blockedUsersProvider
                                              .isBlocked(widget.user.id ?? ""));
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.black45,
                                        ),
                                        child: Icon(MdiIcons.dotsHorizontal,
                                            color: Colors.white, size: 23)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : user.visibility == 'Connected Members'
                          ? Container(
                              height: height * .63,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                image: DecorationImage(
                                  image:
                                      CachedNetworkImageProvider(user.imageUrl ?? ""),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 20, sigmaY: 20),
                                    child: Container(),
                                  ),
                                  Positioned(
                                    top: height * .22,
                                    left: width * .19,
                                    child: Column(
                                      children: [
                                        Icon(
                                          MdiIcons.lock,
                                          color: Colors.white60,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        Text(
                                          'Images will be Visible\nAfter you Connect with Each Other',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: height * .63,
                                    width: width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black12,
                                            Colors.black54
                                          ],
                                          begin: Alignment.center,
                                          stops: [0.4, 1],
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          user.isPremium ?? false
                                              ? Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                        color:
                                                            theme.colorPrimary),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(MdiIcons.crown,
                                                              color:
                                                                  Colors.white),
                                                          Text('Premium',
                                                              style: GoogleFonts
                                                                  .workSans(
                                                                      color: Colors
                                                                          .white)),
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                              : Container(),
                                          Positioned(
                                            right: width * .01,
                                            top: height * .51,
                                            child: Container(
                                              width: width * 0.2,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4,
                                              ),
                                              child: isOnline
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          MdiIcons.circle,
                                                          size: 10,
                                                          color: Colors.green,
                                                        ),
                                                        Text(
                                                          'Online',
                                                          style: GoogleFonts
                                                              .workSans(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : Container() /* Row(
                                                  children: [
                                                    Icon(
                                                      MdiIcons.circle,
                                                      size: 10,
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                      'Offline',
                                                      style:
                                                          GoogleFonts.workSans(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ) */
                                              ,
                                            ),
                                          ),
                                          Positioned(
                                            left: 18,
                                            top: 20,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white54,
                                                child: Icon(
                                                  MdiIcons.arrowLeft,
                                                  color: Colors.black87,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            left: 20,
                                            bottom: 10,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    verificationPopup(
                                                        user.isGovIdVerified ?? false,
                                                        user.govVerifiedBy ?? ""),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      user.name?.toUpperCase() ?? "",
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * .005,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      user.height ?? '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * .03,
                                                    ),
                                                    Text(
                                                      '${calculateAge(user.dateOfBirth ?? "")} yrs',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * .03,
                                                    ),
                                                    Text(
                                                      user.city ?? '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * .005,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      user.highestQualification ??
                                                          '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * .03,
                                                    ),
                                                    Text(
                                                      user.workingAs ?? '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * .015,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      user.maritalStatus ?? '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * .03,
                                                    ),
                                                    Text(
                                                      user.religion ?? '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: height * .63,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                image: DecorationImage(
                                  image:
                                      CachedNetworkImageProvider(user.imageUrl ?? ""),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 20, sigmaY: 20),
                                    child: Container(),
                                  ),
                                  Positioned(
                                    top: height * .22,
                                    width: width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          MdiIcons.lock,
                                          color: Colors.white60,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        Text(
                                          'To Unlock Photos',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PremiuimPlanScreen(),
                                              ),
                                            );
                                          },
                                          child: Center(
                                            child: Container(
                                              width: width * .45,
                                              height: height * .053,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: theme.colorPrimary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Go Premium Now',
                                                style: GoogleFonts.ptSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: theme.colorPrimary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: height * .63,
                                    width: width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black12,
                                            Colors.black54
                                          ],
                                          begin: Alignment.center,
                                          stops: [0.4, 1],
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          user.isPremium ?? false
                                              ? Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                        color:
                                                            theme.colorPrimary),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(MdiIcons.crown,
                                                              color:
                                                                  Colors.white),
                                                          Text('Premium',
                                                              style: GoogleFonts
                                                                  .workSans(
                                                                      color: Colors
                                                                          .white)),
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                              : Container(),
                                          Positioned(
                                            right: width * .01,
                                            top: height * .51,
                                            child: Container(
                                              width: width * 0.2,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4,
                                              ),
                                              child: isOnline
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          MdiIcons.circle,
                                                          size: 10,
                                                          color: Colors.green,
                                                        ),
                                                        Text(
                                                          'Online',
                                                          style: GoogleFonts
                                                              .workSans(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : Container() /* Row(
                                                  children: [
                                                    Icon(
                                                      MdiIcons.circle,
                                                      size: 10,
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                      'Offline',
                                                      style:
                                                          GoogleFonts.workSans(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ) */
                                              ,
                                            ),
                                          ),
                                          Positioned(
                                            left: 18,
                                            top: 20,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white54,
                                                child: Icon(
                                                  MdiIcons.arrowLeft,
                                                  color: Colors.black87,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            left: 20,
                                            bottom: 10,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    verificationPopup(
                                                        user.isGovIdVerified ?? false,
                                                        user.govVerifiedBy ?? ""),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      user.name?.toUpperCase() ?? "",
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * .005,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      user.height ?? '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * .03,
                                                    ),
                                                    Text(
                                                      '${calculateAge(user.dateOfBirth ?? "")} yrs',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * .03,
                                                    ),
                                                    Text(
                                                      user.city ?? '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * .005,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      user.highestQualification ??
                                                          '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * .03,
                                                    ),
                                                    Text(
                                                      user.workingAs ?? '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * .015,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      user.maritalStatus ?? '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * .03,
                                                    ),
                                                    Text(
                                                      user.religion ?? '',
                                                      style: GoogleFonts.ptSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
              SizedBox(
                height: height * .02,
              ),

              BannerAdView(),

              SizedBox(
                height: height * .02,
              ),
              Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Icon(MdiIcons.information),
                          SizedBox(width: 6),
                          Text(
                            'About ${user.name != null ? user.name!.toUpperCase() : ''}',
                            style: GoogleFonts.ptSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Text(
                        user.intro != null ? user.intro ?? "" : '',
                        style: GoogleFonts.ptSans(),
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .005,
              ),
              Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Icon(MdiIcons.accountDetails),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Basic Details',
                            style: GoogleFonts.ptSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: .8,
                                color: theme.colorPrimary,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Created by ${user.postedBy == 'Son' || user.postedBy == 'Daughter' ? 'Parent' : user.postedBy}',
                              style: GoogleFonts.openSans(
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * .015,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: .8,
                                color: theme.colorPrimary,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Profile ID - ${user.srId}',
                              style: GoogleFonts.openSans(
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: .8,
                                color: theme.colorPrimary,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Height - ${user.height ?? ''}',
                              style: GoogleFonts.openSans(
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * .02,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: .8,
                                color: theme.colorPrimary,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Age - ${calculateAge(user.dateOfBirth ?? "")} yrs',
                              style: GoogleFonts.openSans(
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Text(
                        'Profile ID',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '${user.srId}',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Religion & Mother Tongue',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "${user.religion ?? 'not given'} & " +
                            '${user.motherTongue ?? ''}',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Marital Status',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.maritalStatus ?? "not provided",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      // Divider(
                      //   thickness: 1,
                      // ),
                      SizedBox(
                        height: height * .005,
                      ),
                      // Text(
                      //   'Birth Date',
                      //   style: GoogleFonts.ptSans(
                      //     fontSize: 13,
                      //     color: Colors.black54,
                      //   ),
                      // ),
                      // Text(
                      //   user.dateOfBirth != null
                      //       ? '${user.dateOfBirth}'
                      //       : 'not given',
                      //   style: GoogleFonts.lato(
                      //       fontSize: 16, fontWeight: FontWeight.w500),
                      // ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),





                      user.maritalStatus != "Never Married" ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No. of Children',
                            style: GoogleFonts.ptSans(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),

                          Text(
                            '${user.noOfChildren}',
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: height * .005,
                          ),
                        ],
                      ):SizedBox(),


                      user.maritalStatus != "Never Married" ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Living Together',
                            style: GoogleFonts.ptSans(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                      Text(
                        '${user.childrenLivingTogether}',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                        ],
                      ):SizedBox(),




                      Text(
                        'Lives in',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.city ?? 'not given',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Hometown',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.nativePlace ?? 'not given',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Community',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.community ?? 'not given',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Diet Prefrence',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.diet ?? "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Any Disability',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text((user.anyDisAbility != null && user.anyDisAbility != "")
                            ? user.anyDisAbility ?? ""
                            : "not given",
                        style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),

                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Health Information',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        (user.healthInfo != null && user.healthInfo != "")
                            ? user.healthInfo ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Blood Group',
                        style: GoogleFonts.ptSans(
                            fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        (user.bloodGroup != null && user.bloodGroup != "")
                            ? user.bloodGroup ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: height * .005),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .005,
              ),
              isMatchingAny || totalPreferences != 0
                  ? Card(
                      elevation: 6,
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            // vertical: 10,
                            //horizontal: 12,
                            ),
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Color.fromRGBO(251, 215, 244, 1),
                                          Color.fromRGBO(150, 151, 240, 1)
                                        ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(
                                        top: 16,
                                        child: Text(
                                          'You and Her',
                                          style: GoogleFonts.ptSans(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -320,
                                        left: -160,
                                        child: Container(
                                          height: 400,
                                          width: 400,
                                          decoration: BoxDecoration(
                                              color: Color(0x08000000),
                                              borderRadius:
                                                  BorderRadius.circular(500)),
                                        ),
                                      ),
                                      Positioned(
                                        top: -320,
                                        right: -160,
                                        child: Container(
                                          height: 400,
                                          width: 400,
                                          decoration: BoxDecoration(
                                              color: Color(0x08000000),
                                              borderRadius:
                                                  BorderRadius.circular(500)),
                                        ),
                                      ),
                                      Positioned(
                                        top: 64,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          500)),
                                              height: 100,
                                              width: 100,
                                              child: currUser.imageUrl != null
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          currUser.imageUrl ?? "",
                                                      height: 32,
                                                      width: 32,
                                                      fit: BoxFit.cover)
                                                  : Image.asset(
                                                      user.gender == "Female"
                                                          ? 'assets/girl.png'
                                                          : 'assets/boy.png',
                                                      height: 32,
                                                      width: 32),
                                            ),
                                            SizedBox(width: 8),
                                            Container(
                                              clipBehavior: Clip.hardEdge,
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          500)),
                                              child: user.imageUrl != null
                                                  ? ImageFiltered(
                                                      imageFilter:
                                                          ImageFilter.blur(
                                                              sigmaX: isVisible
                                                                  ? 0
                                                                  : 4,
                                                              sigmaY: isVisible
                                                                  ? 0
                                                                  : 4),
                                                      child: CachedNetworkImage(
                                                          imageUrl:
                                                              user.imageUrl ?? "",
                                                          height: 32,
                                                          width: 32,
                                                          fit: BoxFit.cover),
                                                    )
                                                  : Image.asset(
                                                      user.gender == "Female"
                                                          ? 'assets/girl.png'
                                                          : 'assets/boy.png',
                                                      height: 32,
                                                      width: 32),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 96,
                                        child: Container(
                                            padding: EdgeInsets.all(11),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                borderRadius:
                                                    BorderRadius.circular(500)),
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                                'assets/arrow.png',
                                                color: theme.colorPrimary,
                                                height: 12,
                                                width: 16)),
                                      ),
                                    ])),
                            SizedBox(height: 18),
                            totalPreferences != 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      'You Match $matchedPreferences/$totalPreferences of ${currUser.gender == "Male" ? "her" : "his"} Preferences',
                                      style: GoogleFonts.ptSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 6),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: youAndMeMatches
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          e.title,
                                                          style: GoogleFonts
                                                              .ptSans(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                            e.detail,
                                                            style: GoogleFonts.lato(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ]),
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: e.matched
                                                              ? theme
                                                                  .colorPrimary
                                                              : Colors.grey,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: e.matched
                                                          ? Icon(
                                                              Icons
                                                                  .check_rounded,
                                                              size: 21,
                                                              color: theme
                                                                  .colorPrimary)
                                                          : Icon(
                                                              Icons
                                                                  .close_rounded,
                                                              size: 21,
                                                              color: Colors
                                                                  .grey[600])),
                                                ],
                                              ),
                                              Divider(thickness: 1)
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            SizedBox(height: 10),
                            isMatchingAny
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      'Common between the both of you',
                                      style: GoogleFonts.ptSans(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: youAndMyMatches
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.only(
                                              top: 6, bottom: 6),
                                          child: Row(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.purple[300]!,
                                                        Colors.pink[200]!,
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: Icon (
                                                      IconData(e.codePoint,
                                                          fontFamily: 'MaterialIcons'),
                                                      size: 19, color: Colors.white)),
                                              SizedBox(width: 10),
                                              Text(e.text),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: height * .005,
              ),
              Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(MdiIcons.accountBox),
                              SizedBox(width: 6),
                              Text(
                                'Contact Details',
                                style: GoogleFonts.ptSans(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            MdiIcons.crown,
                            size: 22,
                            color: theme.colorCompanion,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Contact No.',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        isPremium && ref.contains(user.id ?? "")
                            ? user.phone ?? 'not given'
                            : '+91 9414******',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Email ID',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        isPremium && ref.contains(user.id ?? "")
                            ? user.email ?? 'not given'
                            : '*******@gmail.com',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: isPremium ? height * .005 : height * .01,
                      ),
                      isPremium && (!ref.contains(user.id ?? ""))
                          ? InkWell(
                              onTap: () {
                                ref.getContact(
                                    context, widget.user, currUser, isPremium,
                                    onSuccess: () {
                                  setState(() {});
                                });
                              },
                              child: Container(
                                width: width,
                                alignment: Alignment.center,
                                child: Text(
                                  'Unlock Contact Details',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      isPremium
                          ? Container()
                          : Container(
                              width: width,
                              alignment: Alignment.center,
                              child: Text(
                                'To Unlock Contact Details',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                      SizedBox(
                        height: isPremium ? height * .0 : height * .01,
                      ),
                      isPremium
                          ? Container()
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PremiuimPlanScreen(),
                                  ),
                                );
                              },
                              child: Center(
                                child: Container(
                                  width: width * .45,
                                  height: height * .053,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorPrimary,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Go Premium Now',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: isPremium ? height * .0 : height * .01,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .005,
              ),
              Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .005,
                      ),
                      Row(
                        children: [
                          Icon(MdiIcons.school),
                          SizedBox(width: 6),
                          Text(
                            'Career & Education',
                            style: GoogleFonts.ptSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Text(
                        'Profession',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.workingAs ?? "not available",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Employed In',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.employedIn == ""
                            ? "not available,"
                            : user.employedIn ?? "",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Company Name',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      isPremium
                          ? Text(
                              user.workingWith ?? "",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PremiuimPlanScreen()));
                              },
                              child: Row(
                                children: [
                                  Text('Only for Priemium'),
                                  Icon(MdiIcons.crown)
                                ],
                              ),
                            ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Annual Income',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.annualIncome ?? "",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Highest Qualification',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.highestQualification ?? "",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'College Name',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      isPremium
                          ? Text(
                              user.collegeAttended ?? "",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PremiuimPlanScreen()));
                              },
                              child: Row(
                                children: [
                                  Text('Only for Priemium'),
                                  Icon(MdiIcons.crown)
                                ],
                              ),
                            ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .005,
              ),
              Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Icon(MdiIcons.homeHeart),
                          SizedBox(width: 6),
                          Text(
                            'Family Details',
                            style: GoogleFonts.ptSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Text(
                        generateFamilyDetails(user),
                        style: GoogleFonts.ptSans(fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Father\'s Name',
                        style: GoogleFonts.ptSans(
                            fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        (user.fatherName != null && user.fatherName != "")
                            ? user.fatherName ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: height * .005),
                      Text(
                        'Father\'s Occupation',
                        style: GoogleFonts.ptSans(
                            fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        (user.fatherStatus != null && user.fatherStatus != "")
                            ? user.fatherStatus ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: height * .005),
                      Text(
                        'Father\'s Gotra',
                        style: GoogleFonts.ptSans(
                            fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        (user.fatherGautra != null && user.fatherGautra != "")
                            ? user.fatherGautra ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: height * .005),
                      Text(
                        'Mother\'s Name',
                        style: GoogleFonts.ptSans(
                            fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        (user.motherName != null && user.motherName != "")
                            ? user.motherName ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: height * .005),
                      Text(
                        'Mother\'s Occupation',
                        style: GoogleFonts.ptSans(
                            fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        (user.motherStatus != null && user.motherStatus != "")
                            ? user.motherStatus ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: height * .005),
                      Text(
                        'Mother\'s Gothra',
                        style: GoogleFonts.ptSans(
                            fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        (user.motherGautra != null && user.motherGautra != "")
                            ? user.motherGautra ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: height * .005),
                      Text(
                        'Family Type',
                        style: GoogleFonts.ptSans(
                            fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        (user.familyType != null && user.familyType != "")
                            ? user.familyType ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: height * .005),
                      Text(
                        'Affluence Level',
                        style: GoogleFonts.ptSans(
                            fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        (user.affluenceLevel != null &&
                                user.affluenceLevel != "")
                            ? user.affluenceLevel ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: height * .005),
                      Text(
                        'Family Value',
                        style: GoogleFonts.ptSans(
                            fontSize: 13, color: Colors.black54),
                      ),
                      Text(
                        (user.familyValues != null && user.familyValues != "")
                            ? user.familyValues ?? ""
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: height * .005),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .005,
              ),
              Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Icon(MdiIcons.calendarEdit),
                          SizedBox(width: 6),
                          Text(
                            'Astro Details',
                            style: GoogleFonts.ptSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Text(
                        'Birth Date',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      user.hideDob ?? false
                          ? Text(
                              "hidden",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          : isPremium
                              ? Text(
                                  user.dateOfBirth != null
                                      ? '${user.dateOfBirth}'
                                      : 'not given',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              : InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PremiuimPlanScreen()));
                                  },
                                  child: Row(
                                    children: [
                                      Text('Only for Priemium'),
                                      Icon(MdiIcons.crown)
                                    ],
                                  ),
                                ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Divider(thickness: 1),
                      Text(
                        'Born in',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      !(user.showHoroscope ?? true)
                          ? Text(
                              "hidden",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          : isPremium
                              ? Text(
                                  user.cityOfBirth ?? "not given",
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              : InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PremiuimPlanScreen()));
                                  },
                                  child: Row(
                                    children: [
                                      Text('Only for Priemium'),
                                      Icon(MdiIcons.crown)
                                    ],
                                  ),
                                ),
                      Divider(thickness: 1),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Time of birth',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      (user.birthTime == null || (user.showHoroscope ?? false))
                          ? Text(
                              "hidden",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          : isPremium
                              ? Text(
                                  '${user.birthTime!.hourOfPeriod}:${user.birthTime!.minute} ${user.birthTime!.period.toString().split('.').last}',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              : InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PremiuimPlanScreen()));
                                  },
                                  child: Row(
                                    children: [
                                      Text('Only for Priemium'),
                                      Icon(MdiIcons.crown)
                                    ],
                                  ),
                                ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Manglik',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.manglik ?? 'not given',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Icon(MdiIcons.note),
                          SizedBox(width: 6),
                          Text(
                            'Gotra',
                            style: GoogleFonts.ptSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Text(
                        'Father Gotra',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.fatherGautra != null
                            ? '${user.fatherGautra}'
                            : 'not given',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Text(
                        'Mother Gotra',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        user.motherGautra ?? "",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Icon(MdiIcons.more),
                          SizedBox(width: 6),
                          Text(
                            'Hobbies and More',
                            style: GoogleFonts.ptSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Text(
                        'Hobbies',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        hobbies.length != 0 ? hobbies.toString() : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Intrests',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        intrests.length != 0
                            ? intrests.toString()
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'FavMusic',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        favMusic.length != 0
                            ? favMusic.toString()
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Select/fitness Activities',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        sportsFitness.length != 0
                            ? sportsFitness.toString()
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Cousine',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        favCousine.length != 0
                            ? favCousine.toString()
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height * .005,
                      ),
                      Text(
                        'Dress Style',
                        style: GoogleFonts.ptSans(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        dressStyle.length != 0
                            ? dressStyle.toString()
                            : "not given",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkPrefs(List selectedList, String partnerInfo, bool openForAll,
      String yourStatus) {
    return (openForAll != null && openForAll) ||
        (selectedList != null &&
            partnerInfo != null &&
            (selectedList.contains(partnerInfo) || selectedList.length == 0));
  }

  checkAndAddAge(List<YouAndMe> youAndMeMatches, String minAge, String maxAge,
      String myDOB) {
    if (myDOB != null) {
      int myAge = calculateAge(myDOB);
      if (minAge != null && maxAge != null) {
        totalPreferences++;
        int min = int.parse(minAge);
        int max = int.parse(maxAge);
        bool matches = (myAge >= min && myAge <= max);
        matchedPreferences += matches ? 1 : 0;

        youAndMeMatches.add(YouAndMe("Age", "$min to $max", matches));
      } else if (minAge != null) {
        totalPreferences++;
        int min = int.parse(minAge);
        bool matches = (myAge >= min);
        matchedPreferences += matches ? 1 : 0;

        youAndMeMatches.add(YouAndMe("Age", "$min <", matches));
      } else if (maxAge != null) {
        totalPreferences++;
        int max = int.parse(maxAge);
        bool matches = (myAge <= max);
        matchedPreferences += matches ? 1 : 0;
        youAndMeMatches.add(YouAndMe("Age", "< $max", matches));
      }
    }
  }

  int calculateHeight(String height) {
    String str = height.split(' - ')[1];
    return int.parse(str.substring(0, str.length - 2));
  }

  checkAndAddHeight(List<YouAndMe> youAndMeMatches, String minHeight,
      String maxHeight, String myHeight) {
    if (myHeight != null) {
      int height = calculateHeight(myHeight);
      if (minHeight != null && maxHeight != null) {
        totalPreferences++;
        int min = calculateHeight(minHeight);
        int max = calculateHeight(maxHeight);
        bool matches = (height >= min && height <= max);
        matchedPreferences += matches ? 1 : 0;

        youAndMeMatches
            .add(YouAndMe("Height", "$minHeight to $maxHeight", matches));
      } else if (minHeight != null) {
        totalPreferences++;
        int min = calculateHeight(minHeight);
        bool matches = (height >= min);
        matchedPreferences += matches ? 1 : 0;

        youAndMeMatches.add(YouAndMe("Height", "$minHeight <", matches));
      } else if (maxHeight != null) {
        totalPreferences++;
        int max = calculateHeight(maxHeight);
        bool matches = (height <= max);
        matchedPreferences += matches ? 1 : 0;

        youAndMeMatches.add(YouAndMe("Height", "< $maxHeight", matches));
      }
    }
  }

  int calculateIncome(String annualIncome) {
    String str = annualIncome.replaceAll("-", "").replaceAll(" lakhs", "");
    if (str.contains("<")) {
      return 10;
    } else if (str.contains(">")) {
      return 1000;
    } else if (str == "Not Working") {
      return 0;
    } else {
      return int.parse(str);
    }
  }

  checkAndAddIncome(List<YouAndMe> youAndMeMatches, String minIncome,
      String maxIncome, String myIncome) {
    if (myIncome != null) {
      int income = calculateIncome(myIncome);
      if (minIncome != null && maxIncome != null) {
        totalPreferences++;
        int min = calculateIncome(minIncome);
        int max = calculateIncome(maxIncome);
        bool matches = (income >= min && income <= max);
        matchedPreferences += matches ? 1 : 0;
        if (minIncome == maxIncome) {
          youAndMeMatches.add(YouAndMe("Income", "$minIncome", matches));
        } else {
          youAndMeMatches
              .add(YouAndMe("Income", "$minIncome to $maxIncome", matches));
        }
      } else if (minIncome != null) {
        totalPreferences++;
        int min = calculateIncome(minIncome);
        bool matches = (income >= min);
        matchedPreferences += matches ? 1 : 0;
        youAndMeMatches
            .add(YouAndMe("Income", "< ${minIncome.substring(1)}", matches));
      } else if (maxIncome != null) {
        totalPreferences++;
        int max = calculateIncome(maxIncome);
        bool matches = (income <= max);
        matchedPreferences += matches ? 1 : 0;

        youAndMeMatches
            .add(YouAndMe("Income", "> ${maxIncome.substring(1)}", matches));
      }
    }
  }

  checkAndAdd(List<YouAndMe> youAndMeMatches,
      {
        String title = "",
      bool openForAll = false,
      String yourInfo = "",
      List? partnerRequirement
      }) {
    if (openForAll) {
      totalPreferences++;
      matchedPreferences++;
      youAndMeMatches.add(YouAndMe(title, "Open for All", true));
    } else if (partnerRequirement!.length != 0) {
      totalPreferences++;
      bool matches = partnerRequirement.contains(yourInfo);
      matchedPreferences += matches ? 1 : 0;
      youAndMeMatches
          .add(YouAndMe(title, partnerRequirement.join(", "), matches));
    }
  }

  checkMatches(UserInformation user) async {
    final pref = await FirebaseDatabase.instance
        .reference()
        .child('Partner Prefrence')
        .child(user.id ?? "")
        .once();

    PartnerInfo partnerInfo;
    bool msForAll = user.maritalStatus != "Never Married";
    List selectedmsList = [];

    Map tempMapData = pref.snapshot.value as Map;

    if (!msForAll) {
      selectedmsList = ["Never Married"];
    }
    if (tempMapData != null) {
      partnerInfo = PartnerInfo(
          maritalStatusForAll: tempMapData['maritalStatusForAll'] ?? msForAll,
          motherToungueForAll: tempMapData['motherToungeForAll'] ?? true,
          manglikForAll: tempMapData['manglikForAll'] ?? true,
          religionForAll: tempMapData['religionForAll'] ?? true,
          designationOpenForAll: tempMapData['desigForAll'] ?? true,
          dietForAll: tempMapData['dietForAll'] ?? true,
          qualificationOpenForAll: tempMapData['qualificationForAll'] ?? true,
          locationForAll: tempMapData['locationForAll'] ?? true,
          city: tempMapData['city'],
          country: tempMapData['country'],
          workingWith: tempMapData['workingWith'],
          workingAs: tempMapData['designation'],
          diet: tempMapData['diet'],
          maritalStatus: tempMapData['maritalStatus'],
          maxAge: tempMapData['maxAge'],
          minAge: tempMapData['minAge'],
          maxIncome: tempMapData['maxIncome'],
          minIncome: tempMapData['minIncome'],
          motherTong: tempMapData['motherTounge'],
          qualification: tempMapData['qualification'],
          community: tempMapData['community'],
          religion: tempMapData['religion'],
          state: tempMapData['state'],
          maxHeight: tempMapData['maxHeight'],
          selectedManglikList:
              new List<String>.from(tempMapData['selectedManglikList'] ?? []),
          selectedMaritalStatusList: new List<String>.from(
              tempMapData['maritalStatusList'] ?? selectedmsList),
          selectedMotherToungueList:
              new List<String>.from(tempMapData['motherToungueList'] ?? []),
          selectedDesignation:
              new List<String>.from(tempMapData['designationList'] ?? []),
          selectedReligionList:
              new List<String>.from(tempMapData['religionList'] ?? []),
          selectedDietList: new List<String>.from(tempMapData['dietList'] ?? []),
          selectedQualificationList:
              new List<String>.from(tempMapData['qualificationList'] ?? []),
          selectedLocationList:
              new List<String>.from(tempMapData['locationList'] ?? []),
          minHeight: tempMapData['minHeight']);
    } else {
      partnerInfo = PartnerInfo(
          maritalStatusForAll: msForAll,
          selectedMaritalStatusList: new List<String>.from(selectedmsList),
          selectedManglikList: new List<String>.from([]),
          manglikForAll: true,
          motherToungueForAll: true,
          selectedMotherToungueList: new List<String>.from([]),
          religionForAll: true,
          selectedReligionList: new List<String>.from([]),
          city: '',
          selectedDesignation: new List<String>.from([]),
          selectedDietList: new List<String>.from([]),
          selectedQualificationList: new List<String>.from([]),
          designationOpenForAll: true,
          dietForAll: true,
          qualificationOpenForAll: true,
          locationForAll: true,
          selectedLocationList: new List<String>.from([]));
    }
    //Age
    youAndMeMatches.clear();
    youAndMyMatches.clear();

    checkAndAddAge(youAndMeMatches, (partnerInfo.minAge ?? "0"), (partnerInfo.maxAge ?? "0"),
        currUser.dateOfBirth ?? "");
    checkAndAdd(
      youAndMeMatches,
      title: 'Marital Status',
      openForAll: partnerInfo.maritalStatusForAll ?? false,
      yourInfo: currUser.maritalStatus ?? "",
      partnerRequirement: partnerInfo.selectedMaritalStatusList,
    );
    //Height
    checkAndAddHeight(youAndMeMatches, partnerInfo.minHeight ?? "",
        partnerInfo.maxHeight ?? "", currUser.height ?? "");
    //Diet
    checkAndAdd(
      youAndMeMatches,
      title: 'Diet',
      openForAll: partnerInfo.dietForAll ?? false,
      yourInfo: currUser.diet ?? "",
      partnerRequirement: partnerInfo.selectedDietList,
    );
    //Religion
    checkAndAdd(
      youAndMeMatches,
      title: 'Religion / Community',
      openForAll: partnerInfo.religionForAll ?? false,
      yourInfo: currUser.religion ?? "",
      partnerRequirement: partnerInfo.selectedReligionList,
    );
    //Mother Tongue
    checkAndAdd(
      youAndMeMatches,
      title: 'Mother Tongue',
      openForAll: partnerInfo.motherToungueForAll ?? false,
      yourInfo: currUser.motherTongue ?? "",
      partnerRequirement: partnerInfo.selectedMotherToungueList,
    );
    //State
    checkAndAdd(
      youAndMeMatches,
      title: 'State',
      openForAll: partnerInfo.locationForAll ?? false,
      yourInfo: currUser.state ?? "",
      partnerRequirement: partnerInfo.selectedLocationList,
    );

    //Qualification
    checkAndAdd(
      youAndMeMatches,
      title: 'Qualification',
      openForAll: partnerInfo.qualificationOpenForAll ?? false,
      yourInfo: currUser.highestQualification ?? "",
      partnerRequirement: partnerInfo.selectedQualificationList,
    );

    //Designation
    checkAndAdd(
      youAndMeMatches,
      title: 'Designation',
      openForAll: partnerInfo.designationOpenForAll ?? false,
      yourInfo: currUser.workingAs ?? "",
      partnerRequirement: partnerInfo.selectedDesignation,
    );
    //Income
    checkAndAddIncome(youAndMeMatches, partnerInfo.minIncome ?? "",
        partnerInfo.maxIncome ?? "", currUser.annualIncome ?? "");

    var gender = currUser.gender == "Male" ? "She" : "He";
    if (currUser.diet == user.diet) {
      youAndMyMatches.add(CommonBetween('$gender is ${currUser.diet} as well',
          Icons.local_dining_rounded.codePoint));
      isMatchingAny = true;
    }
    if (currUser.city == user.city) {
      youAndMyMatches.add(CommonBetween(
          '$gender also lives in ${currUser.city} city',
          Icons.location_city.codePoint));
      isMatchingAny = true;
    }

    if (currUser.state == user.state) {
      youAndMyMatches.add(CommonBetween(
          '$gender also lives in ${currUser.state} state',
          Icons.location_on_sharp.codePoint));
      isMatchingAny = true;
    }
    if (currUser.country == user.country) {
      youAndMyMatches.add(CommonBetween(
          '$gender also lives in ${currUser.country}',
          Icons.map_sharp.codePoint));
      isMatchingAny = true;
    }
    if (currUser.motherTongue == user.motherTongue) {
      youAndMyMatches.add(CommonBetween(
          '$gender also speaks ${currUser.motherTongue}',
          Icons.translate.codePoint));
      isMatchingAny = true;
    }
    if (currUser.collegeAttended == user.collegeAttended) {
      youAndMyMatches.add(CommonBetween(
          '$gender went to the same college ${currUser.collegeAttended} as you',
          Icons.school.codePoint));
      isMatchingAny = true;
    }
    if (currUser.workingAs == user.workingAs) {
      youAndMyMatches.add(CommonBetween(
          '$gender is also working as ${currUser.workingAs}',
          Icons.cases.codePoint));
      isMatchingAny = true;
    }
    if (currUser.dateOfBirth == user.dateOfBirth) {
      youAndMyMatches.add(CommonBetween(
          '$gender was also born ${currUser.dateOfBirth}',
          Icons.baby_changing_station_rounded.codePoint));
      isMatchingAny = true;
    }
    if (currUser.familyType == user.familyType) {
      youAndMyMatches.add(CommonBetween(
          '$gender have same family values ${currUser.familyType}',
          Icons.family_restroom.codePoint));
      isMatchingAny = true;
    }
    if (currUser.manglik == user.manglik) {
      youAndMyMatches.add(CommonBetween(
          '$gender is also ${currUser.manglik}', Icons.wb_sunny.codePoint));
      isMatchingAny = true;
    }
    setState(() {});
  }
}
