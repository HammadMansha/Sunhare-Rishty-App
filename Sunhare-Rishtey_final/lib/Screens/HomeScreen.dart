import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Providers/BlockedUsersProvider.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/Providers/UserRequestProvider.dart';
import 'package:matrimonial_app/Screens/IDVerificationScreen.dart';
import 'package:matrimonial_app/Screens/PartnerPreferenceScreen.dart';
import 'package:matrimonial_app/auth/GetStartedScreen.dart';
// import 'package:native_updater/native_updater.dart';
import 'package:matrimonial_app/Providers/adsProvider.dart';
import 'package:matrimonial_app/Providers/hideProvider.dart';
import 'package:matrimonial_app/Screens/SocialMediaChatRoom.dart';
import 'package:matrimonial_app/Screens/advertisementScreen.dart';
import 'package:matrimonial_app/Screens/hideMessageScreen.dart';
import 'package:matrimonial_app/Screens/ViewProfileScreen.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/models/advertisementModel.dart';
import 'package:matrimonial_app/models/chatModel.dart';
import 'package:matrimonial_app/models/parternerInfoModel.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:upgrader/upgrader.dart';
import '/Providers/allUser.dart';
import '../Providers/ContactsProvider.dart';
import '/Providers/imagesProvider.dart';
import '../Providers/UserRequestProvider.dart';
import '/Screens/MatchScreen.dart';
import '/Screens/PremiumUserScreen.dart';
import '/Screens/ProfileScreen.dart';
import '/Screens/suspendedScreen.dart';
import '/main.dart';
import '/models/UserModel.dart';
import '/models/primiumModel.dart';
import 'AllChatScreen.dart';
import 'InboxScreen.dart';
import 'PremiumPlanScreen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  bool isRedirectingFromLogin;
  HomeScreen({required this.isRedirectingFromLogin});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool gotUserInfo = true;
  advertisementScreen() {
    return AdvertisementScreen(advertisementList[0]);
  }
  AppUpdateInfo? _updateInfo;

  Future<void> checkForNewAppUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        if(_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable){
          InAppUpdate.performImmediateUpdate().then((value) {
            if(value == AppUpdateResult.userDeniedUpdate){
              exit(0);
            }
          });
        }
      });
    });
  }

  bool hideForWeek = false;
  bool hideFor2Week = false;
  bool hideForMonth = false;
  bool hide = false;
  getHideProfileStatus() {
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('hideProfile')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        hideFor2Week = data['2week'];
        hideForWeek = data['1week'];
        hideForMonth = data['month'];
        setState(() {
          hide = hideFor2Week || hideForWeek || hideForMonth;
          Provider.of<HideProvider>(context, listen: false).setHide(hide);
        });
      }
    });
  }

  List<UserInformation> allUsers = [];
  List<UserInformation> tempUsers = [];
  UserInformation userInformation = UserInformation();
  Future getAllUsers(String gender, List blockedBy,int maxUsersLength) async {

    final ref = Provider.of<AllUser>(context, listen: false);
    print("Test data 5");
    await ref.getAllUsers(
        gender: userInformation.gender == "Male" ? "Female" : "Male",maxUser: maxUsersLength);
    setState(() {
      ref.removeSameGender(gender);
      ref.removeBlockedByUsers(blockedBy);
      allUsers = ref.allUsers;

      allUsers.forEach((element) {
        if (element.isPremium ?? false) {
          tempUsers.add(element);
        }
      });
      allUsers.forEach((element) {
        if (!(element.isPremium ?? false)) {
          tempUsers.add(element);
        }
      });
      print("Test data 6");

      // This code removed requested profiles
      // tempUsers.removeWhere((element) => requestStatus.containsKey(element.id));
      isLoading = false;


    });
  }

  PremiumModel premiumValues = PremiumModel();
  bool isFresh = true;
  assignMemberShip() async {
    FirebaseDatabase.instance
        .reference()
        .child('ActiveMembership')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {


          Map premMap = {};

          if(event.snapshot.value != null) {
            premMap = event.snapshot.value as Map;
          }


      DateTime validTill2;

      if (premMap != null) {
        print("ValidTill${premMap['ValidTill']}");
        /*DateTime validTill2 = DateTime.parse(
            "${premi['ValidTill'].split('T')[0]} 00:00:00.000");
        validTill2 = validTill2.add(Duration(days: 1));*/

        if(premMap['ValidTill'].toString().contains("T")){
          validTill2 = DateTime.parse(
              "${premMap['ValidTill'].split('T')[0]} 00:00:00.000");
          validTill2 = validTill2.add(Duration(days: 1));
        }else{
          validTill2 = DateTime.parse(
              "${(premMap['ValidTill'] ?? DateTime.now()).toString().replaceFirst(" ","T").split('T')[0]} 00:00:00.000");
          validTill2 = validTill2.add(Duration(days: 1));
        }


        premiumValues = PremiumModel(
            dateOfPerchase: DateTime.parse(premMap['DateOfPerchase'] ?? DateTime.now().toString()),
            validTill: DateTime.parse(premMap['ValidTill'] ?? DateTime.now().toString()),
            contact: premMap['contacts'],
            name: premMap['name'],
            packageName: premMap['packageName'],
            isActive: premMap['ValidTill'] != null
                ? (validTill2.compareTo(DateTime.now()) > 0)
                    ? true
                    : false
                : false);

        Provider.of<CurrUserInfo>(context, listen: false)
            .currentUser
            .premiumModel = premiumValues;
        FirebaseDatabase.instance
            .reference()
            .child('User Information')
            .child(FirebaseAuth.instance.currentUser!.uid)
            .update({'isPremium': premiumValues.isActive});

        setState(() {});
        if (profileScreen != null && barIndex == 0) {
          profileScreen!.updateState(premiumValues);
        }

        // ToDO: Remove this code.
        /* if (!isFresh) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()),
              (route) => false);
        }
        Future.delayed(Duration(seconds: 5), () {
          isFresh = false;
        }); */
      }
    });
  }

  getImages() async {
    final ref = Provider.of<ImageListProvider>(context, listen: false);
    await ref.getImages(FirebaseAuth.instance.currentUser!.uid);
  }

  String gender = "";
  List blockedBy = [];
  CurrUserInfo currentUserRef = CurrUserInfo();
  Future getCurrUser() async {
    currentUserRef = Provider.of<CurrUserInfo>(context, listen: false);
    await currentUserRef.getData();
    setState(() {
      gotUserInfo = false;
      userInformation = currentUserRef.currentUser;
      isVerificationRequired = currentUserRef.isVerificationRequired;
      initPushNotification();
      gender = currentUserRef.currentUser.gender ?? "";
      blockedBy = currentUserRef.currentUser.blockedByList ?? [];
      isSuspended = userInformation.isSuspended ??false;
    });
  }

  bool firstTimeSuspended = true;
  getSuspendedStatus() {
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('isSuspended')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        if (firstTimeSuspended) {
          firstTimeSuspended = false;
          return;
        }
        setState(() {
          isSuspended = (event.snapshot.value ?? false) as bool;
          if (isSuspended) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        });
      }
    });
  }

  getVerificationRequiredStatus() {
    bool firstTimeVerified = true;
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('isVerificationRequired')
        .onValue
        .listen((event) {
      if (firstTimeVerified) {
        firstTimeVerified = false;
        return;
      }
      if (event.snapshot.value != null) {
        isVerificationRequired = event.snapshot.value as bool;
        if (isVerificationRequired) {
          currentUserRef.isVerificationPending = false;
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          FirebaseDatabase.instance
              .reference()
              .child('User Information')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .child("isVerificationPending")
              .once()
              .then((value) => {
                    setState(() {
                      if (value.snapshot.value == null) {
                        currentUserRef.isVerificationPending = false;
                      } else {
                        currentUserRef.isVerificationPending = value.snapshot.value as bool;
                      }
                    })
                  });
          // FirebaseDatabase.instance
          //     .reference()
          //     .child('User Information')
          //     .child(FirebaseAuth.instance.currentUser!.uid)
          //     .child('isVerificationRequired')
          //     .remove();
        }
        setState(() {});
      }
    });
  }

  getDeletedOrRejectedStatus() {
    FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      if (event.snapshot.value == null) {
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
        );
      }
    });
  }

  Map requestStatus = {};
  getRequests() async {
    FirebaseDatabase.instance
        .reference()
        .child('userReq')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        requestStatus = event.snapshot.value as Map;
        setState(() {});
      }
    });
    // print(req.value);
  }

  List blockedId = [];
  getBlockedId() {
    var ref = Provider.of<BlockedUsersProvider>(context, listen: false);
    ref.getBlockedUsers();
    ref.addListener(() {
      blockedId.addAll(ref.blockedUsers);
      setState(() {});
    });
  }

  List<AdvertisementModel> advertisementList = [];
  getAdvertisement() async {
    final ref = Provider.of<AdsProvider>(context, listen: false);
    await ref.getAds().then((value) => timer(true));
    advertisementList = ref.interestialAdsList;
    advertisementList.shuffle();
  }

  accountDeleteReqCancel() async{
    final data = await FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid).once();
    Map fdata = data.snapshot.value as Map;

    if(fdata.containsKey("AccountDeleteDate")){
      await FirebaseDatabase.instance
          .reference()
          .child('User Information')
          .child(FirebaseAuth.instance.currentUser!.uid).child("AccountDeleteDate").remove();

      accountRecovery();
    }
  }

  accountRecovery() async{
    DateTime endDate = DateTime.now();
    String finalEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('hideProfile')
        .update({
      '1week': false,
      '2week': false,
      'month': false,
      'unHideDate': finalEndDate,
    });
  }

  bool isLoading = true;
  bool isSuspended = false;
  bool isVerificationRequired = false;

  UserRequestProvider userRequestProvider = UserRequestProvider();
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1)).then((value) {
      scrollAuto();
    });
    userRequestProvider = Provider.of<UserRequestProvider>(context, listen: false);
    getCurrUser().then((value) {
      getAllUsers(gender, blockedBy,0).then((value) {
        userRequestProvider.getAllRequest(context).then((value) => setState(() {}));
      });
    });

     //profileCompleteDialog();
    getSuspendedStatus();
    getVerificationRequiredStatus();
    getDeletedOrRejectedStatus();
    getHideProfileStatus();
    assignMemberShip();
    getImages();
    getRequests();
    getBlockedId();
    getAdvertisement();

    getProfilePercentage();
    accountDeleteReqCancel();
    checkForNewAppUpdate();

    Provider.of<ContactProvider>(context, listen: false)
        .getContacts()
        .then((value) => setState(() {}));

    setupOnlineStatus();
    lastLoginUpdate();
    setState(() {});


    /*Future.delayed(Duration(seconds: 2)).then((value) {
      userRequestProvider = Provider.of<UserRequestProvider>(context, listen: false);
      getAllUsers(gender, blockedBy,0).then((value) {
        setState(() {
          isLoading = true;
          isLoading = false;
        });
      });
    });*/

    super.initState();
  }

  lastLoginUpdate()async{
    await FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({'Lastlogin': DateTime.now().toIso8601String()});
  }

  /*Future<void> checkVersion() async {
    Future.delayed(Duration.zero, () {
      NativeUpdater.displayUpdateAlert(
        context,
        forceUpdate: true,
        iOSDescription: '<Your iOS description>',
        iOSUpdateButtonLabel: 'Upgrade',
        iOSCloseButtonLabel: 'Exit',
      );
    });
  }*/
  void setupOnlineStatus() {
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({'isOnline': true});
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onDisconnect()
        .update({'isOnline': false});
  }

  bool showAd = false;
  void timer(bool isAd) {
    if (isAd) {
      Future.delayed(Duration(minutes: 5)).then((value) {
        showAd = advertisementList.length != 0;
        setState(() {});
        timer(false);
      });
    } else {
      Future.delayed(Duration(seconds: 10)).then((value) {
        showAd = false;
        setState(() {});
        timer(true);
      });
    }
  }

  FirebaseMessaging? messaging;
  void initPushNotification() async {
    messaging = FirebaseMessaging.instance;
    String? token = await messaging!.getToken();
    final databaseReference = FirebaseDatabase.instance.reference();
    debugPrint("tokensdsdsdsd ==> ${token}");
    databaseReference
        .child('Push Notifications')
        .child(userInformation.id ??"")
        .set({token: true});
    messaging!.subscribeToTopic("discount");

    assert(() {
      messaging!.subscribeToTopic("testing");
      return true;
    }());

    print("::: ${userInformation.id}");

    initReceivePushNotifications();
  }

  String title = "";
  String body = "";
  String target = "";
  String userId = "";
  bool fromChat = false;

  void getNotificationData(RemoteMessage msg) {
    var noti = msg.notification;
    if (noti != null) {
      title = noti.title ?? "";
      body = noti.body ?? "";
    } else if (msg.data['title'] != null && msg.data['body'] != null) {
      title = msg.data['title'] as String;
      body = msg.data['body'] as String;
    }

    fromChat = msg.data['fromChat'] != null;
    target = msg.data['target'] as String;
    userId = msg.data['userId'] as String;
  }

  void initReceivePushNotifications() {
    var flnPlugin = FlutterLocalNotificationsPlugin();
    flnPlugin.initialize(
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/noti_icon')),
        onSelectNotification: (payload) {
      router();
    });

    var nDetails = NotificationDetails(
        android: AndroidNotificationDetails('Notifications', 'Notifications',
            channelDescription: 'This is primary notification channel',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound("noti_sound"),
            playSound: true,
            styleInformation: BigTextStyleInformation("")));

    FirebaseMessaging.instance.getInitialMessage().then((event) => {
          setState(() {
            print("::: Initial Message");
            if (event != null) getNotificationData(event);
            if (target != null && target != Constants.DEFAULT_TARGET) {
              router();
            }
          })
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {

      print("Get message : ${event.senderId}");

      getNotificationData(event);
      // print("::: message recieved: ${event.notification!.body.toString()}");


      print("ff ${currentUserRef.currentUser.id}");
      print("ff ${userId ?? ""}");
      print("ff ${event.senderId ?? ""}");

/*      var theirMetaRef = FirebaseDatabase.instance
          .reference()
          .child("PersonalChatsPersons")
          .child(currentUserRef.currentUser.id ?? "")
          .child(event.senderId ?? "");
      theirMetaRef.child("lastReceived").set("#${DateTime.now().toIso8601String()}");*/


      if (!fromChat && ChatModel.currentUser != userId) {
        flnPlugin.show(0, title, body, nDetails);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("msg tapped:::");
      getNotificationData(event);
      router();
    });
  }

  var initialIndex = 0;
  void router() {
    switch (target) {
      case Constants.USER_CHAT_MESSAGE:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => SocialMediaChat(uid: userId, data: UserInformation(id: ""))));
        break;
      case Constants.USER_DISCOUNT:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => PremiuimPlanScreen()));
        break;
      case Constants.USER_ACCEPT_REQUEST:
        {
          setState(() {
            initialIndex = 1;
            barIndex = 2;
          });
          Navigator.of(context).popUntil((route) => route.isFirst);
          break;
        }
      case Constants.USER_SENT_REQUEST:
        {
          setState(() {
            barIndex = 2;
          });
          Navigator.of(context).popUntil((route) => route.isFirst);
          break;
        }
      case Constants.USER_NEW_MATCH:
      case Constants.USER_ACCOUNT_VISITED:
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ViewProfileScreen(
                  [], 0, userInformation.isPremium ?? false, userId)));
          break;
        }
      case Constants.USER_PREMIUM_MEMBERSHIP:
        {
          setState(() {
            barIndex = 4;
          });
          break;
        }
      default:
        {}
    }
  }

  int barIndex = 1;
  Future willPop() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'No',
              style: GoogleFonts.workSans(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            },
            child: Text(
              'Yes',
              style: GoogleFonts.workSans(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        content: Container(
          child: Text('Do you really wants to exit'),
        ),
      ),
    );
  }

  GlobalKey _bottomNavigationKey = GlobalKey();
  ProfileScreen? profileScreen;
  bool isPlaying = false;

  playClickSound(){
    AudioPlayer player = AudioPlayer();
    player.play(AssetSource('click_sound.mp3'));

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying  = state == PlayerState.playing;
      });
    });

    player.setVolume(0.02);

  }

  getProfilePercentage() async{
    final data = await FirebaseDatabase.instance
        .reference()
        .child('profileCompleted')
        .child(FirebaseAuth.instance.currentUser!.uid).child("profileCompletePercentage").once();
    var fdata = data.snapshot.value;
    setState(() {
      totalProfileCompleted = (fdata ?? 0) as int;
    });
    print("percentage data---->>>>>>$fdata");
  }


  var width;
  var height;

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;


    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return await willPop();
        },
        child: UpgradeAlert(
          child: Scaffold(
            bottomNavigationBar: showAd
                ? SizedBox()
                : CurvedNavigationBar(
                    key: _bottomNavigationKey,
                    buttonBackgroundColor: theme.colorBackground,
                    index: barIndex,
                    height: 50,
                    color: theme.colorCompanion,
                    backgroundColor: theme.colorBackground!,
                    onTap: (selectedindex) {
                      setState(() {
                        barIndex = selectedindex;
                        playClickSound();
                      });
                    },
                    items: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.account,
                            color:
                                barIndex == 0 ? theme.colorCompanion : Colors.white,
                          ),
                          Text("Profile",style: TextStyle(color:barIndex == 0 ?theme.colorCompanion : Colors.white ,fontSize: 10,fontWeight: FontWeight.w500),)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.accountMultiple,
                            color:
                                barIndex == 1 ? theme.colorCompanion : Colors.white,
                          ),
                          Text("Users",style: TextStyle(color:barIndex == 1 ? theme.colorCompanion: Colors.white ,fontSize: 10,fontWeight: FontWeight.w500),)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.inboxFull,
                            color:
                                barIndex == 2 ? theme.colorCompanion : Colors.white,
                          ),
                          Text("Requests",style: TextStyle(color:barIndex == 2 ?theme.colorCompanion : Colors.white ,fontSize: 10,fontWeight: FontWeight.w500),)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.chat,
                            color:
                                barIndex == 3 ? theme.colorCompanion : Colors.white,
                          ),
                          Text("Chat",style: TextStyle(color:barIndex == 3 ?theme.colorCompanion : Colors.white ,fontSize: 10,fontWeight: FontWeight.w500),)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.crown,
                            color:
                                barIndex == 4 ? theme.colorCompanion : Colors.white,
                          ),
                          Text("Premium",style: TextStyle(color:barIndex == 4 ?theme.colorCompanion : Colors.white ,fontSize: 10,fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ],
                  ),
            body: isSuspended
                ? SuspendedScreen()
                : isVerificationRequired
                    ? IDVerificationScreen(userName: userInformation.name ?? "",image: userInformation.imageUrl ?? "")
                    : currentUserRef.isVerificationPending
                        ? Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Icon(
                                  MdiIcons.timer,
                                  size: 40,
                                )),
                                SizedBox(height: 16),
                                Center(child: Text('Verification Pending')),
                              ],
                            ),
                          )
                        : showAd
                            ? advertisementScreen()
                            : isLoading
                                ? shimmerPart()
                                  /*SpinKitThreeBounce(
                                    color: theme.colorPrimary,
                                  )*/
                                : barIndex == 0
                                    ? profileScreen = ProfileScreen(
                                        userInformation,
                                        gotUserInfo,
                                      )
                                    : barIndex == 1
                                        ? hide
                                            ? HideMessageScreen()
                                            :
                                          // PartnerPreferenceScreen(
                                          //   partnerInfo: (userInformation.partnerInfo ?? PartnerInfo()),
                                          // )
                                              MatchScreen(
                                                tempUsers,
                                                requestStatus,
                                                blockedId,
                                                allUsers)
                                        : barIndex == 2
                                            ? hide
                                                ? HideMessageScreen()
                                                : InboxScreen(
                                                    initialIndex: initialIndex)
                                            : barIndex == 3
                                                ? hide
                                                    ? HideMessageScreen()
                                                    : AllChatScreen()
                                                : hide
                                                    ? HideMessageScreen()
                                                    : (premiumValues != null)
                                                        ? PremiumUsersScreen()
                                                        : PremiuimPlanScreen(),
          ),
        ),
      ),
    );
  }

  int selectedIndex = 1 ;
  List<String> mainTabView = ["All Users (300)","New Members (50)","My Matches (50)","Near Me (50)","Profile Visitor (50)","Intrested in me (50)","Shortlisted (50)","Blocked (50)"];

  shimmerPart() {
    return Container(
      height:  MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            height:60,
            color: theme.colorCompanion,
            padding: EdgeInsets.only(left: 20,right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                Row(
                  children: [
                    Icon(
                      MdiIcons.genderMaleFemale,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .09,
                    ),
                    Text(
                      'Find Your Soulmate',
                      style: GoogleFonts.karla(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),







                Icon(
                  MdiIcons.magnify,
                  size: 26,
                  color: Colors.white,
                ),

              ],


            ),
          ),
          Container(
            height: 75,
              width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 18, top: 6),

            child: ListView.builder(
              controller:  _controller,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: mainTabView.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    selectedIndex = index;
                    setState(() {});
                  },
                  child: Container(
                    //height: selectedIndex == index ? height * 0.7 : height * .05,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    margin:  EdgeInsets.symmetric(horizontal: 5,vertical: selectedIndex == index ? 0 : 5 ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: selectedIndex == index ? theme.colorCompanion: Colors.white,
                      border: Border.all(
                        color: theme.colorCompanion,
                        width: 1,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(mainTabView[index],style: TextStyle(color: selectedIndex == index ? Colors.white : Colors.black,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                );
              },
            )
          ),
          Container(
            child: shimmerUi()
          ),
        ],
      ),
    );

  }
  final ScrollController _controller = ScrollController();

  scrollAuto(){
    _controller.jumpTo(60);
  }

  shimmerUi() {
    return Container(
      height: height*0.7,
      width: MediaQuery.of(context).size.width,

        child:ListView.builder(
          itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context,index){
          return  Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                //top: height * .01,
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
                    child: Container(
                      height: height * .63,
                      width: width * .92,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red,width: 2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7)),
                            child: Container(height: 350,width: width,color: Colors.pink,),

                          ),

                          Positioned(
                            right: 25,
                            top: height * .07,
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
                          Positioned(
                            right: 20,
                            top: height * .13,
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child:  Icon(
                                  MdiIcons.heart,
                                  color: Colors.red,
                                  size: 30,
                                )
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
                              child:
                              Row(
                                children: [

                                  Container(height: 20,width: 60,color: Colors.red,),
                                ],
                              )

                              ,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            left: 10,
                            bottom: 10,
                            child: Column(
                              children: [
                                Row(
                                  children: [

                                    Container(height: 20,width: 110,color: Colors.red,)
                                  ],
                                ),
                                SizedBox(
                                  height: height * .005,
                                ),
                                Row(
                                  children: [
                                    Container(height: 15,width: 80,color: Colors.red,),
                                    SizedBox(
                                      width: width * .03,
                                    ),
                                    Container(height: 15,width: 25,color: Colors.red,),

                                  ],
                                ),
                                SizedBox(
                                  height: height * .005,
                                ),
                                Row(
                                  children: [
                                    Container(height: 20,width: 70,color: Colors.red,),
                                    SizedBox(
                                      width: width * .03,
                                    ),
                                    Container(height: 20,width: 60,color: Colors.red,),
                                  ],
                                ),
                                SizedBox(
                                  height: height * .005,
                                ),
                                Row(
                                  children: [
                                    Container(height: 20,width: 60,color: Colors.red,),
                                    SizedBox(
                                      width: width * .03,
                                    ),

                                    Container(height: 20,width: 40,color: Colors.red,),

                                  ],
                                ),
                                SizedBox(
                                  height: height * .005,
                                ),
                                Row(
                                  children: [
                                    Container(height: 20,width: 150,color: Colors.red,),
                                  ],
                                ),


                              ],
                            ),
                          ),


                        ],
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

                              child: Container(
                                  width: width * .2,
                                  child: Column(children: [
                                    Icon(MdiIcons.phone, color: Colors.red),
                                    SizedBox(height: 4),
                                    Text('Phone')
                                  ]))),
                          InkWell(
                            onTap: () {
                            },
                            child: Container(
                              width: width * .25,
                              child: Column(
                                children: [

                                  Transform.rotate(
                                    angle: 95,
                                    child: Icon(
                                      MdiIcons.navigation,

                                      color: Colors.red,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 4,
                                  ),

                                  Container(
                                    alignment: Alignment.center,
                                    width: width * 25,
                                    child: Text(
                                        'Send Request'),
                                  )

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
          );
        })
    );
  }
}
