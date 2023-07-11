import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Providers/getUserInfo.dart';
import '/models/UserModel.dart';
import 'package:provider/provider.dart';
import '/main.dart';

class BadgeScreen extends StatefulWidget {
  @override
  _BadgeScreenState createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> {
  bool isVerified = false;
  UserInformation userInfo = UserInformation();
  String verifiedBy = "";

  checkForVarification() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child('Gov Id')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once();

    Map tempMapData = data.snapshot.value as Map;

    if (data.snapshot.value != null) {
      isVerified = tempMapData['isVerified'];
      verifiedBy = tempMapData['varificationBy'];
      setState(() {});
    }
  }

  bool isPremium = false;
  @override
  void initState() {
    checkForVarification();
    userInfo = Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    isPremium = userInfo.premiumModel?.isActive != null
        ? userInfo.premiumModel?.isActive ?? false
        : false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorCompanion,
        title: Text(
          'Badge',
          style: GoogleFonts.lato(),
        ),
      ),
      body: isPremium
          ? Center(
              child: Container(
                width: width * .5,
                height: height * .3,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/premiumBadge.png',
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Text('Premium member')
                  ],
                ),
              ),
            )
          : isVerified
              ? Center(
                  child: Container(
                    width: width * .5,
                    height: height * .3,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/verified.png',
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Text('Verified by $verifiedBy')
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    child: Text('Verified by Admin'),
                  ),
                ),
    );
  }
}
