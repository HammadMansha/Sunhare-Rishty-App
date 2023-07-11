import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/auth/Info3.dart';
import 'package:upgrader/upgrader.dart';
import '../auth/GetStartedScreen.dart';
import '../auth/Info1.dart';
import '/main.dart';
import 'HomeScreen.dart';
import 'OtpScreenNewUser.dart';

bool isShowAds = true;
bool isBannerShowAds = true;

String nativeID = "ca-app-pub-3940256099942544/2247696110";
String bannerID = "ca-app-pub-3940256099942544/6300978111";
String interID = "ca-app-pub-3940256099942544/1033173712";

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasData = false;
  void initState() {
    super.initState();
    getcurrentUser();
    getAdsSetting();

    /*Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (ctx) => Info3("true")),
      );
    });*/
  }

  bool signedUp = false;
  Future<void> checkForDetails(String id) async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(id)
        .once();

    Map tempData = data.snapshot.value as Map;

    if (tempData != null) {
      if (tempData['hasData'] != null) {
        hasData = true;
        signedUp = true;
      }
    }
  }

  Future<void> getcurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
        );
      });
      return;
    }
    if (user != null) {
      checkForDetails(user.uid).then((value) {
        if (hasData) {
          print("111 aaya yaha");
          Future.delayed(Duration(seconds: 2)).then((value) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(isRedirectingFromLogin: false),
              ),
            );
          });
        } else if (!signedUp) {
          FirebaseAuth.instance.signOut();
          Future.delayed(Duration(seconds: 2)).then((value) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
            );
          });
        } else {
          Future.delayed(Duration(seconds: 2)).then((value) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
            );
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        body: UpgradeAlert(
          child: Container(
            height: height,
            width: width,
            child: Image.asset('assets/splashimage.png', fit: BoxFit.cover),
          ),
        ),
        // body: Container(
        //   height: height,
        //   width: width,
        //   child: Image.asset('assets/splashimage.png', fit: BoxFit.cover),
        // ),
      ),
    );
  }

  void getAdsSetting() {
    FirebaseDatabase.instance
        .reference()
        .child('AdsSetting')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        isShowAds = data['interstitial'];
        isBannerShowAds = data['banner'];
      }});
  }
}
