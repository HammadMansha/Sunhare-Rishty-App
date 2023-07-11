import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:matrimonial_app/Screens/banner_ads_view.dart';
import 'package:matrimonial_app/Screens/intertitial_ads_view.dart';
import 'package:matrimonial_app/Screens/native_ads_view.dart';
import 'package:matrimonial_app/explore/ExploreSearchScreen.dart';
import 'package:upgrader/upgrader.dart';
import 'package:video_player/video_player.dart';

import '../Screens/Splash.dart';
import '/main.dart';
import '/models/LoginScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  VideoPlayerController _controller =
      VideoPlayerController.asset("assets/GetStarted.mp4");

  TextEditingController phone = new TextEditingController();
  bool isLoading = false;
  bool _visible = false;

  @override
  void initState() {
    IntertitialAdsView().createInterstitialAd();
    _controller.initialize().then((value) {
      _controller.setLooping(true);
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });
    super.initState();
  }

  checkAdsStatus() async{
    print("${FirebaseAuth.instance.currentUser!.uid}");
    final hasDta = await FirebaseDatabase.instance
        .reference()
        .child('User Information').child(FirebaseAuth.instance.currentUser!.uid)
        .child('adsStatus')
        .once();
    var data = hasDta.snapshot.value;
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        if (_visible) _controller.play();
        // widget is resumed
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        body: UpgradeAlert(
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 1000),
                child: VideoPlayer(_controller),
              ),
              SingleChildScrollView(
                child: Container(
                  height: height * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height * .03),
                      Row(
                        children: [
                          SizedBox(
                            width: width * .08,
                          ),
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(
                              'assets/shadiLogo.png',
                            ),
                          ),
                          SizedBox(
                            width: width * .075,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * .01,
                              ),
                              Text(
                                'Only for GoldSmith Community',
                                style: theme.text16bold,
                              ),
                              SizedBox(
                                height: height * .006,
                              ),
                              Container(
                                width: width * .6,
                                child: Text(
                                  'Find your perfect soulmate with premium services',
                                  style: theme.text14grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: height * .03),
                      login(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: height * .50),
        /* SizedBox(height: height * .05),
        Container(
            height: height * .45,
            padding: EdgeInsets.all(12),
            child: Image.asset("assets/couple.jpg", fit: BoxFit.contain)), */
        SizedBox(height: height * .08),
        GestureDetector(
            onTap: () {
              if (_visible) _controller.pause();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginOtpScreen()));
            },
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: HexColor('FF1557'),
                elevation: 3,
                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    width: width * 0.5,
                    height: height * 0.06,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Login/Register",
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ))
                            ]))))),
        GestureDetector(
            onTap: () {
              if (_visible) _controller.pause();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExploreSearchScreen()));
            },
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                elevation: 3,
                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    width: width * 0.5,
                    height: height * 0.06,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Explore App",
                                  style: GoogleFonts.openSans(
                                      fontSize: 16, color: theme.colorPrimary))
                            ]))))),
      ],
    );
  }
}
