import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Providers/ContactsProvider.dart';
import 'package:matrimonial_app/Providers/favouriteUserProvider.dart';
import 'package:matrimonial_app/Providers/UserRequestProvider.dart';
import 'package:matrimonial_app/Screens/PremiumPlanScreen.dart';
import 'package:matrimonial_app/Screens/ReportScreen.dart';
import 'package:matrimonial_app/Screens/SocialMediaChatRoom.dart';
import 'package:matrimonial_app/Screens/ViewProfileScreen.dart';
import 'package:matrimonial_app/Screens/intertitial_ads_view.dart';
import 'package:matrimonial_app/Utils/ChatUtils.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:matrimonial_app/main.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:matrimonial_app/models/advertisementModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Screens/Splash.dart';
import '../Constants.dart';

class PersonCard extends StatefulWidget {
  final UserInformation user;
  final UserInformation currentUserInfo;
  final bool isFavourite;
  final bool isRequestSent;
  final List<UserInformation> users;
  final int index;
  final AdvertisementModel ad;
  final bool? isVarified;

  PersonCard({
    required this.user,
    required this.currentUserInfo,
    required this.isFavourite,
    required this.isRequestSent,
    required this.users,
    required this.index,
    required this.ad,
    this.isVarified,
  });

  @override
  _PersonCardState createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  bool isFavourite = false;
  bool isRequestSent = false;
  bool isOnline = false;
  bool isVisible = true;
  bool isRequestAccepted = false;
  bool isPremium = false;
  bool isGotRequestFromUser = false;
  List<UserInformation> reqUsers = [];
  bool isSentRequest = false;
  var onlineListener, requestListener, connectionListener, favListener;
  int tempTotalClick = 0;

  checkOnline() {
    onlineListener = FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(widget.user.id ?? "")
        .child('isOnline')
        .onValue
        .listen((event) {
         bool? getIsOnline = (event.snapshot.value ?? false) as bool;
      setState(() {
        isOnline = getIsOnline ?? false;
      });
    });
  }

  checkFavourite() {
    favListener = FirebaseDatabase.instance
        .reference()
        .child('FavUsers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(widget.user.id ?? "")
        .onValue
        .listen((event) {
      bool? getIsOnline = (event.snapshot.value ?? false) as bool;
      setState(() {
        isFavourite = getIsOnline ?? false;
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

      Map value = {};

      if(event.snapshot.value != null) {
        value = event.snapshot.value as Map;
      }

      if (value == null) {
        isRequestAccepted = false;
      } else if (value is bool) {
        isRequestAccepted = value is bool;
      } else {
        isRequestAccepted = (value['accepted'] ?? false ) as bool;
      }

      isVisible = widget.user.visibility == 'All Member' ||
          (widget.user.visibility == 'Premium Members only' && isPremium) ||
          (widget.user.visibility == 'Connected Members' && isRequestAccepted);
    });
  }

  String visibility= "";

  @override
  void initState() {
    print("isVerified-->>>${widget.isVarified}");
    IntertitialAdsView().createInterstitialAd();
    isFavourite = widget.isFavourite;
    isRequestSent = widget.isRequestSent;
    visibility = widget.user.visibility ?? 'All Member';
    final ref = Provider.of<UserRequestProvider>(context, listen: false);

    isPremium = widget.currentUserInfo.premiumModel?.isActive ?? false;

    isVisible = visibility == 'All Member' ||
        (visibility == 'Premium Members only' && isPremium) ||
        (visibility == 'Connected Members' &&
            Provider.of<UserRequestProvider>(context, listen: false)
                .checkConnection(widget.user.id));

    checkOnline();
    checkRequestStatus();
    checkFavourite();

    var user = ref.pendingUserData
        .where((element) => element.name == widget.user.name);
    if (user.length > 0) {
      isGotRequestFromUser = true;
    } else {
      isGotRequestFromUser = false;
    }

    super.initState();
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
        sendNotificationsByUserID(widget.user.id ?? "", widget.currentUserInfo.name ?? "",
            'Accepted your request',
            userId: FirebaseAuth.instance.currentUser!.uid,
            target: Constants.USER_ACCEPT_REQUEST);

        ChatUtils chatUtils = new ChatUtils(
          senderId: widget.currentUserInfo.id ?? "",
          receiverId: widget.user.id ?? "",
          senderName: widget.currentUserInfo.name ?? "",
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
              (widget.currentUserInfo.name ?? "") + ' sent you request',
              userId: (widget.currentUserInfo.id ?? ""),
              target: Constants.USER_SENT_REQUEST);

          ChatUtils chatUtils = new ChatUtils(
            senderId: widget.currentUserInfo.id ?? "",
            receiverId: widget.user.id ?? "",
            senderName: widget.currentUserInfo.name ?? "",
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
    if (favListener != null) {
      favListener.cancel();
    }
    if (ref != null) {
      ref.removeListener(() {});
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double adWidth = 0;
    double adHeight = 0;
    if (widget.ad.title != null) {
      adWidth = 0.92 * width;
      adHeight = adWidth * (5 / 8);
    }
    return Column(
      children: [
        widget.ad != null
            ? Container(
                height: adHeight,
                width: adWidth,
                decoration: BoxDecoration(
                  color: theme.colorBackground,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.ad.image ?? "")),
                ),
                child: Stack(
                  children: [],
                ),
              )
            : SizedBox(),
        Padding(
          padding: EdgeInsets.only(
              top: height * .01,
              bottom: height * .01,
              left: width * .04,
              right: width * .04),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: InkWell(
                  onTap: () {
                    print("1111111");
                    if(isShowAds){
                      IntertitialAdsView().showInterstitialAd();
                    }
                    if(widget.isVarified == true){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewProfileScreen(
                            widget.users, widget.index, isPremium),
                      ));
                    }else{
                      Fluttertoast.showToast(msg: 'Waiting for Approval');
                    }
                  },
                  child: isVisible
                      ? Container(
                          height: height * .63,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    (widget.user.imageUrl ?? "")),
                                fit: BoxFit.cover),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                gradient: LinearGradient(
                                    colors: [Colors.black12, Colors.black54],
                                    begin: Alignment.center,
                                    stops: [0.4, 1],
                                    end: Alignment.bottomCenter)),
                            child: Stack(
                              children: [
                                widget.user.isPremium ?? false
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
                                  right: 25,
                                  top: height * .07,
                                  child: InkWell(
                                    onTap: () {
                                      if(widget.isVarified == true){
                                        bottomSheet(context, widget.user,
                                            widget.currentUserInfo);
                                      }else{
                                        Fluttertoast.showToast(msg: 'Waiting for Approval');
                                      }
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
                                Positioned(
                                  right: 20,
                                  top: height * .13,
                                  child: InkWell(
                                    onTap: () {
                                      if(widget.isVarified == true){
                                        onFavTap(
                                            context, isFavourite, widget.user)
                                            .then((value) {
                                          setState(() {
                                            isFavourite = !isFavourite;
                                          });
                                        });
                                      }else{
                                        Fluttertoast.showToast(msg: 'Waiting for Approval');
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: isFavourite
                                          ? Icon(MdiIcons.heart,
                                              color: Colors.red, size: 30)
                                          : Icon(MdiIcons.heartOutline,
                                              color: Colors.white, size: 30),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: width * .01,
                                  top: height * .51,
                                  child: Container(
                                    width: width * 0.2,
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: isOnline
                                        ? Row(
                                            children: [
                                              Icon(MdiIcons.circle,
                                                  size: 10,
                                                  color: Colors.green),
                                              Text('Online',
                                                  style: GoogleFonts.workSans(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          )
                                        : Container() /* Row(
                                            children: [
                                              Icon(MdiIcons.circle,
                                                  size: 10, color: Colors.red),
                                              Text('Offline',
                                                  style: GoogleFonts.workSans(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ) */
                                    ,
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
                                              widget.user.isGovIdVerified ?? false,
                                              widget.user.govVerifiedBy ?? ""),
                                          SizedBox(width: 10),
                                          Text(
                                              widget.user.name!.toUpperCase() ??
                                                  "",
                                              style: GoogleFonts.ptSans(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: height * .005),
                                      Row(
                                        children: [
                                          Text(
                                            widget.user.height ?? '',
                                            style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                          SizedBox(width: width * .03),
                                          Text(
                                              "${calculateAge(widget.user.dateOfBirth ?? "")} yrs",
                                              style: GoogleFonts.ptSans(
                                                  color: Colors.white,
                                                  fontSize: 14)),
                                          SizedBox(width: width * .03),
                                          Container(
                                            width: width * .24,
                                            child: Text(
                                              widget.user.city ?? '',
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
                                      SizedBox(height: height * .005),
                                      Row(
                                        children: [
                                          Text(
                                            widget.user.highestQualification ??
                                                '',
                                            style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                          SizedBox(width: width * .03),
                                          Text(
                                            widget.user.workingAs ?? '',
                                            style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * .005),
                                      widget.user.employedIn != null &&
                                              widget.user.employedIn != ""
                                          ? Row(
                                              children: [
                                                Text(
                                                  widget.user.employedIn ?? "",
                                                  style: GoogleFonts.ptSans(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                )
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(height: height * .005),
                                      Row(
                                        children: [
                                          Text(
                                            widget.user.maritalStatus ?? '',
                                            style: GoogleFonts.ptSans(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .03,
                                          ),
                                          Text(
                                            widget.user.noOfChildren != "" && widget.user.noOfChildren != null ? "Children: "+widget.user.noOfChildren! : '',
                                            style: GoogleFonts.ptSans(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .03,
                                          ),
                                          Text(
                                            widget.user.childrenLivingTogether != ""  && widget.user.childrenLivingTogether != null ?"Living Together: "+ widget.user.childrenLivingTogether! : '',
                                            style: GoogleFonts.ptSans(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            widget.user.religion ?? '',
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
                        )
                      : visibility == 'Connected Members'
                          ? Container(
                              height: height * .63,
                              width: width * .92,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      widget.user.imageUrl ?? ""),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 20, sigmaY: 20),
                                        child: Container()),
                                  ),
                                  Positioned(
                                    top: height * .25,
                                    child: Column(
                                      children: [
                                        Icon(MdiIcons.lock,
                                            color: Colors.white60, size: 50),
                                        SizedBox(height: height * .02),
                                        Text(
                                          'Images will be Visible\nAfter you Connect with Each Other',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        SizedBox(height: height * .02),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: height * .63,
                                    width: width,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.black12,
                                              Colors.black54
                                            ],
                                            begin: Alignment.center,
                                            stops: [0.4, 1],
                                            end: Alignment.bottomCenter),
                                      ),
                                      child: Stack(
                                        children: [
                                          widget.user.isPremium ?? false
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
                                            right: 25,
                                            top: height * .08,
                                            child: InkWell(
                                              onTap: () {
                                                if(widget.isVarified == true){
                                                  bottomSheet(
                                                      context,
                                                      widget.user,
                                                      widget.currentUserInfo);
                                                }else{
                                                  Fluttertoast.showToast(msg: 'Waiting for Approval');
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.black45,
                                                ),
                                                child: Icon(
                                                    MdiIcons.dotsHorizontal,
                                                    color: Colors.white,
                                                    size: 23),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: width * .01,
                                            top: height * .51,
                                            child: Container(
                                              width: width * 0.2,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: isOnline
                                                  ? Row(
                                                      children: [
                                                        Icon(MdiIcons.circle,
                                                            size: 10,
                                                            color:
                                                                Colors.green),
                                                        Text(
                                                          'Online',
                                                          style: GoogleFonts
                                                              .workSans(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )
                                                      ],
                                                    )
                                                  : Container(),
                                            ),
                                          ),
                                          Positioned(
                                            right: 13,
                                            top: height * .15,
                                            child: InkWell(
                                              onTap: () {
                                                if(widget.isVarified == true){
                                                  onFavTap(context, isFavourite,
                                                      widget.user)
                                                      .then((value) {
                                                    setState(() {
                                                      isFavourite = !isFavourite;
                                                    });
                                                  });
                                                }else{
                                                  Fluttertoast.showToast(msg: 'Waiting for Approval');
                                                }
                                              },
                                              child: Container(
                                                width: width * 0.15,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 4,
                                                ),
                                                child: isFavourite
                                                    ? Icon(
                                                        MdiIcons.heart,
                                                        color: Colors.red,
                                                        size: 30,
                                                      )
                                                    : Icon(
                                                        MdiIcons.heartOutline,
                                                        color: Colors.white,
                                                        size: 30,
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
                                                        widget.user
                                                                .isGovIdVerified ??
                                                            false,
                                                        widget.user.govVerifiedBy ?? ""),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      widget.user.name!.toUpperCase() ?? "",
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: height * .005),
                                                Row(
                                                  children: [
                                                    Text(
                                                      widget.user.height ?? '',
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                        width: width * .03),
                                                    Text(
                                                      "${calculateAge(widget.user.dateOfBirth ?? "")} yrs",
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                        width: width * .03),
                                                    Text(
                                                      widget.user.city ?? '',
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: height * .005),
                                                Row(
                                                  children: [
                                                    Text(
                                                      widget.user
                                                              .highestQualification ??
                                                          '',
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                        width: width * .03),
                                                    Text(
                                                      widget.user.workingAs ??
                                                          '',
                                                      style: GoogleFonts.ptSans(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: height * .005),
                                                Row(
                                                  children: [
                                                    Text(
                                                        widget.user
                                                                .maritalStatus ??
                                                            '',
                                                        style:
                                                            GoogleFonts.ptSans(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14)),
                                                    SizedBox(
                                                        width: width * .03),
                                                    Text(
                                                        widget.user.religion ??
                                                            '',
                                                        style:
                                                            GoogleFonts.ptSans(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14)),
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
                              width: width * .92,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      widget.user.imageUrl ?? ""),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 20, sigmaY: 20),
                                      child: Container(),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      isPremium
                                          ? Container()
                                          : InkWell(
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
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Go Premium Now',
                                                    style: GoogleFonts.ptSans(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: theme.colorPrimary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 25,
                                    top: height * .07,
                                    child: InkWell(
                                      onTap: () {
                                        if(widget.isVarified == true){
                                          bottomSheet(context, widget.user,
                                              widget.currentUserInfo);
                                        }else{
                                          Fluttertoast.showToast(msg: 'Waiting for Approval');
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          color: Colors.black45,
                                        ),
                                        child: Icon(
                                          MdiIcons.dotsHorizontal,
                                          color: Colors.white,
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 20,
                                    top: height * .13,
                                    child: InkWell(
                                      onTap: () {
                                        if(widget.isVarified == true){
                                          onFavTap(context, isFavourite,
                                              widget.user)
                                              .then((value) {
                                            setState(() {
                                              isFavourite = !isFavourite;
                                            });
                                          });
                                        }else{
                                          Fluttertoast.showToast(msg: 'Waiting for Approval');
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        child: isFavourite
                                            ? Icon(
                                                MdiIcons.heart,
                                                color: Colors.red,
                                                size: 30,
                                              )
                                            : Icon(
                                                MdiIcons.heartOutline,
                                                color: Colors.white,
                                                size: 30,
                                              ),
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
                                          : Container() /* Row(
                                              children: [
                                                Icon(
                                                  MdiIcons.circle,
                                                  size: 10,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  'Offline',
                                                  style: GoogleFonts.workSans(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ) */
                                      ,
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
                                                widget.user.isGovIdVerified ??
                                                    false,
                                                widget.user.govVerifiedBy ?? ""),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.user.name!.toUpperCase() ??
                                                  "",
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
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
                                              widget.user.height ?? '',
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * .03,
                                            ),
                                            Text(
                                              "${calculateAge(widget.user.dateOfBirth ?? "")} yrs",
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * .03,
                                            ),
                                            Text(
                                              widget.user.city ?? '',
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
                                              widget.user
                                                      .highestQualification ??
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
                                              widget.user.workingAs ?? '',
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
                                              widget.user.maritalStatus ?? '',
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * .03,
                                            ),

                                            Text(
                                              widget.user.noOfChildren != "" && widget.user.noOfChildren != null ? "Children: "+widget.user.noOfChildren! : '',
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * .03,
                                            ),
                                            Text(
                                              widget.user.childrenLivingTogether != ""  && widget.user.childrenLivingTogether != null ?"Living Together: "+ widget.user.childrenLivingTogether! : '',
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),

                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Text(
                                              widget.user.religion ?? '',
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
                                  !widget.user.isPremium
                                      ? Container() : Positioned(
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
                                      )),
                                ],
                              ),
                            ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: theme.colorPrimary),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          if(widget.isVarified == true){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => isPremium
                                      ? SocialMediaChat(
                                    uid: widget.user.id ?? "",
                                    data: widget.user,
                                  )
                                      : PremiuimPlanScreen()),
                            );
                          }
                          else{
                            print("not varified");
                            Fluttertoast.showToast(msg: 'Waiting for Approval');
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
                        onTap: () async{
                          if(widget.isVarified == true){
                            print("varified");
                            print('id clickObject===>>${widget.user.id!}');
                            var data = await FirebaseDatabase.instance
                                .reference()
                                .child('User Information')
                                .child(widget.user.id!)
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
                                  .child(widget.user.id!)
                                  .update({'clickCount': clickObject});

                            Provider.of<ContactProvider>(context, listen: false)
                                .getContact(
                                    context,
                                    widget.user,
                                    widget.currentUserInfo,
                                    isPremium, onSuccess: () {
                              setState(() {});
                              launchWhatsApp(
                                  widget.user.phone ?? "", widget.currentUserInfo);
                            });
                          }
                          else{
                            print("not varified");
                            Fluttertoast.showToast(msg: 'Waiting for Approval');
                          }
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
                          onTap: () async{
                            if(widget.isVarified == true){
                              print('id clickObject===>>${widget.user.id!}');

                              var data = await FirebaseDatabase.instance
                                  .reference()
                                  .child('User Information')
                                  .child(widget.user.id!)
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
                                  .child(widget.user.id!)
                                  .update({'clickCount': clickObject});

                              Provider.of<ContactProvider>(context, listen: false)
                                  .getContact(
                                  context,
                                  widget.user,
                                  widget.currentUserInfo,
                                  isPremium, onSuccess: () {
                                setState(() {});
                                launch("tel://${widget.user.phone}");
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

                              if(viewContactList.contains(widget.user.id ?? "")) {

                              }

                              viewContactList.add(widget.user.id ?? "");

                              await FirebaseDatabase.instance
                                  .reference()
                                  .child('PlanWithContactView')
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .child("${getKeyName}").
                              update({"contact_view": viewContactList});
                            }
                            else{
                              print("not varified");
                              Fluttertoast.showToast(msg: 'Waiting for Approval');
                            }
                          },
                          child: Container(
                              width: width * .2,
                              child: Column(children: [
                                Icon(MdiIcons.phone, color: Colors.red),
                                SizedBox(height: 4),
                                Text('Phone')
                              ]))),
                      InkWell(
                        onTap: () {
                         if(widget.isVarified == true){
                           onTapBtnSendRequest();
                         }else{
                           print("not varified");
                           Fluttertoast.showToast(msg: 'Waiting for Approval');
                         }
                        },
                        child: Container(
                          width: width * .25,
                          child: Column(
                            children: [
                              if (isGotRequestFromUser ||
                                  isRequestAccepted) ...[
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
                                  child: Text(
                                      isRequestSent ? 'Sent' : 'Send Request'),
                                )
                              ]
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

bottomSheet(context, UserInformation user, UserInformation currentUserInfo,
    {isBlocked = false}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18), topRight: Radius.circular(18)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 140,
        padding: EdgeInsets.symmetric(horizontal: 23, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 17,
            ),
            GestureDetector(
              onTap: () {
                // if(widget.isVarified == true){
                //
                // }else{
                //   print("not varified");
                //   Fluttertoast.showToast(msg: 'Waiting for Approval');
                // }
                if (isBlocked) {
                  print(":::: $user.id");
                  FirebaseDatabase.instance
                      .reference()
                      .child('User Information')
                      .child(user.id ?? "")
                      .child('Blocked By')
                      .child(FirebaseAuth.instance.currentUser!.uid)
                      .remove();
                  FirebaseDatabase.instance
                      .reference()
                      .child('BlockedUsers')
                      .child(FirebaseAuth.instance.currentUser!.uid)
                      .child(user.id ?? "")
                      .remove()
                      .then((value) {
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(msg: 'Successfully UnBlocked');
                  });
                  return;
                }
                print("::: ${user.name}: ${user.id}");
                FirebaseDatabase.instance
                    .reference()
                    .child('User Information')
                    .child(user.id ?? "")
                    .child('Blocked By')
                    .update({'${FirebaseAuth.instance.currentUser!.uid}': true});
                FirebaseDatabase.instance
                    .reference()
                    .child('BlockedUsers')
                    .child(FirebaseAuth.instance.currentUser!.uid)
                    .update({'${user.id}': true}).then((value) {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(msg: 'Successfully Blocked');
                });
              },
              child: Row(
                children: [
                  Icon(
                    MdiIcons.cancel,
                    size: 28,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Text(
                    isBlocked ? 'UnBlock this Profile' : 'Block this Profile',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 23,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReportScreen(user, currentUserInfo),
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    MdiIcons.alertOutline,
                    size: 28,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Text(
                    'Report this Profile',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

PopupMenuButton verificationPopup(bool isGovIdVerified, String govVerifiedBy) {
  isGovIdVerified = isGovIdVerified ?? false;
  print("isGovIdVerified===>>>$isGovIdVerified");
  print("govVerifiedBy===>>>$govVerifiedBy");
  return PopupMenuButton(
      padding: EdgeInsets.only(left: 4, right: 10),
      iconSize: 34,
      color: Colors.black,
      offset: Offset(12, isGovIdVerified ? -60 : -44),
      icon: Image.asset(
        isGovIdVerified ? 'assets/govVerifycheck.png' : 'assets/verified.png',
        fit: BoxFit.contain,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            height: 30,
            child: Column(
              children: [
                isGovIdVerified && govVerifiedBy != ""
                    ? Row(
                        children: [
                          Icon(
                            Icons.check_rounded,
                            color: Colors.green,
                            size: 22.0,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            govVerifiedBy + " verified",
                            style: GoogleFonts.workSans(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Row(
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 22.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Mobile Number verified",
                      style: GoogleFonts.workSans(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ];
      });
}

Future onFavTap(context, bool isFavourite, UserInformation user) async {
  if (!isFavourite) {
    FirebaseDatabase.instance
        .reference()
        .child('FavUsers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({'${user.id}': true}).then((value) {
      Provider.of<FavUsers>(context, listen: false).addToFav(user.id ?? "");
    });
  } else {
    FirebaseDatabase.instance
        .reference()
        .child('FavUsers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('${user.id}')
        .remove()
        .then((value) {
      Provider.of<FavUsers>(context, listen: false).removeId(user.id ?? "");
    });
  }
}
