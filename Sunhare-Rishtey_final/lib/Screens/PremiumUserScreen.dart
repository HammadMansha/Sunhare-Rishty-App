import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Screens/banner_ads_view.dart';
import 'package:matrimonial_app/Screens/intertitial_ads_view.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/main.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../Providers/ContactsProvider.dart';
import '/Providers/getUserInfo.dart';
import '/Screens/ContactsViewedScreen.dart';
import '/Screens/PremiumPlanScreen.dart';
import '/models/UserModel.dart';
import '/models/primiumModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Splash.dart';

class PremiumUsersScreen extends StatefulWidget {
  @override
  _PremiumUsersScreenState createState() => _PremiumUsersScreenState();
}

class _PremiumUsersScreenState extends State<PremiumUsersScreen> {
  UserInformation userinfo = UserInformation();
  List<String> contacts = [];
  @override
  void initState() {
    if(isShowAds){
      IntertitialAdsView().showInterstitialAd();
    }
    userinfo = Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    contacts = Provider.of<ContactProvider>(context, listen: false).contacts;
    checkForPremium();
    log(contacts.toString());

    super.initState();
  }

  bool isPlanActive = false;
  bool isAboutToEnd = false;
  PremiumModel plan = PremiumModel();
  checkForPremium() {
    bool isPremium = userinfo.premiumModel!.isActive ?? false;
    plan = userinfo.premiumModel ?? PremiumModel();
    if (plan != null && (isPremium)) {
      isPlanActive = true;
      isAboutToEnd = (plan.validTill!.difference(plan.dateOfPerchase!).inHours / 24).round() <= 15;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width * 1,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(width * .15),
                      bottomRight: Radius.circular(width * .15))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                      '${userinfo.name!.split(' ').first}, ' +
                          (isPlanActive
                              ? (isAboutToEnd
                                  ? 'Your membership is expiring soon, Please upgrade subscription.'
                                  : 'Welcome to your\nPremium experience')
                              : "Your membership is expired, Please renew subscription"),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.workSans(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontSize: 24)),
                  SizedBox(
                    height: height * .02,
                  ),
                  Stack(
                    children: [
                      Icon(
                        MdiIcons.crown,
                        size: 30,
                        color: Colors.white,
                      ),
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withAlpha(40),
                                  spreadRadius: 4,
                                  blurRadius: 10,
                                ),
                                BoxShadow(
                                  color: Colors.white.withAlpha(30),
                                  spreadRadius: -4,
                                  blurRadius: 5,
                                )
                              ])),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * .01,
            ),
            Container(
              width: width * 0.9,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: isPlanActive ? Colors.green : Colors.red,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.all(0)),
                  onPressed: () {
                    if(isShowAds){
                      IntertitialAdsView().showInterstitialAd();
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PremiuimPlanScreen()));
                  },
                  child: Ink(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isPlanActive
                                ? [Colors.blue, Colors.green]
                                : [Colors.red, Colors.pinkAccent])),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    child: Text(
                      isPlanActive
                          ? "Upgrade Subscription"
                          : "Renew  Subscription",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
            ),
            SizedBox(
              height: height * .01,
            ),
            Container(
              width: width * .9,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      plan.packageName ?? "",
                                      style: GoogleFonts.workSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * .03,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: isPlanActive
                                                  ? [Colors.blue, Colors.green]
                                                  : [Colors.red, Colors.red])),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        child: Text(
                                          isPlanActive ? 'Active' : 'Expired',
                                          style: GoogleFonts.workSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height * .03,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Start Date - '),
                                          Text(
                                            plan.dateOfPerchase != null ? '${plan.dateOfPerchase!.day}/${plan.dateOfPerchase!.month}/${plan.dateOfPerchase!.year}' : "",
                                            style: GoogleFonts.workSans(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * .06,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Expiry- '),
                                          Text(
                                            plan.validTill != null ? '${plan.validTill!.day}/${plan.validTill!.month}/${plan.validTill!.year}' : "",
                                            style: GoogleFonts.workSans(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: height * .005,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ContactsViewedScreen(),
                  ),
                );
              },
              child: Container(
                height: height * .15,
                width: width * .9,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Contacts',
                                        style: GoogleFonts.workSans(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * .03,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${contacts.length} ',
                                        style: GoogleFonts.workSans(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('Of '),
                                      Text(
                                        '${isPlanActive ? plan.contact : contacts.length} ',
                                        style: GoogleFonts.workSans(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('Contacts Viewed')
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 24),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.blue, Colors.green])),
                              height: height * .11,
                              width: width * .11,
                              child: Icon(
                                MdiIcons.chevronRight,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(
              height: height * .005,
            ),
            InkWell(
              onTap: () {
                var phone = "+919634395495";
                final link = WhatsAppUnilink(phoneNumber: '$phone');
                launch('$link');
                //launch("tel://+919634395495");
              },
              child: Container(
                width: width * .9,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Premium Assist',
                                        style: GoogleFonts.workSans(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * .02,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'We are available from',
                                            style: GoogleFonts.workSans(),
                                          ),
                                          Text(
                                            '10am-7pm',
                                            style: GoogleFonts.workSans(),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.blue, Colors.green]),
                              ),
                              height: height * .11,
                              width: width * .11,
                              child: Icon(
                                MdiIcons.whatsapp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: height * .005,
            ),
            BannerAdView(),
          ],
        ),
      ),
    );
  }
}
