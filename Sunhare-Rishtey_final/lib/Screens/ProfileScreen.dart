import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Screens/ShareUserScreen.dart';
import 'package:matrimonial_app/Screens/banner_ads_view.dart';
import 'package:matrimonial_app/models/parternerInfoModel.dart';
import 'package:matrimonial_app/models/primiumModel.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '/Screens/EditProfileScreen.dart';
import '/Screens/GalleryPage.dart';
import '/Screens/PremiumPlanScreen.dart';
import '../models/GovIdModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '/Screens/PartnerPreferenceScreen.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'AccountSettingsScreen.dart';
import 'MyPrivacyScreen.dart';
import 'MySubscriptionsScreen.dart';
import 'ProfileVerificationScreen.dart';
import '/main.dart';

class ProfileScreen extends StatefulWidget {
  final UserInformation userInfo;
  final bool gotData;
  ProfileScreen(this.userInfo, this.gotData);

  updateState(PremiumModel premiumValues) {
    pcs.updateState(premiumValues);
  }

  _ProfileScreenState pcs = _ProfileScreenState();

  @override
  _ProfileScreenState createState() => pcs;
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isVerified = false;
  bool isPremium = false;
  String version = "";

  @override
  void initState() {
    // getProfilePercentage();
    isVerified = widget.userInfo.isVerified ?? false;
    isPremium = widget.userInfo.premiumModel?.isActive != null
        ? widget.userInfo.premiumModel?.isActive ?? false
        : false;
    getData();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      setState(() {});
    });

    super.initState();
  }

  getProfilePercentage() async{
    final data = await FirebaseDatabase.instance
        .reference()
        .child('profileCompleted')
        .child(FirebaseAuth.instance.currentUser!.uid).child("profileCompletePercentage").once();
    var fdata = data.snapshot.value;
    setState(() {
      totalProfileCompleted = fdata as int;
    });
    print("percentage data---->>>>>>$fdata");
  }

  GovIdModel govId = GovIdModel();
  getData() {
    FirebaseDatabase.instance
        .reference()
        .child('Gov Id')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map;
      if (data != null && data.isNotEmpty) {
        govId = GovIdModel(
            imageUrl: data['imageUrl'],
            isVerified: data['isVerified'],
            name: data['name'],
            srId: data['srId'],
            userId: data['userId'],
            verifiedBy: data['varificationBy']);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorCompanion,
          title: Text(
            'My Profile',
            style: GoogleFonts.karla(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Icon(
            MdiIcons.account,
            size: 20,
          ),
        ),
        body: widget.gotData
            ? SpinKitThreeBounce(
                color: Colors.blue,
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            HexColor('7E4288'),
                            HexColor('7E4288'),
                          ],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GalleryPage(widget.userInfo.imageUrl ?? ''),
                                  ),
                                );
                              },
                              child: widget.userInfo.imageUrl == null
                                  ? Image.asset("assets/profile.png",height: 100,width: 100,)
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage: CachedNetworkImageProvider(widget.userInfo.imageUrl ?? ""),
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: width * .02,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                        widget.userInfo.name == null
                                            ? "Unknown"
                                            : '${widget.userInfo.name!.toUpperCase()}',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      !(widget.userInfo.isVerified ?? true)
                                          ? Text(
                                              "Waiting for approval",
                                              style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  SizedBox(
                                    width: width * .02,
                                  ),
                                  isVerified
                                      ? Icon(
                                          Icons.check_circle,
                                          color: theme.status,
                                        )
                                      : Icon(
                                          Icons.error_rounded,
                                          semanticLabel: 'Verification pending',
                                          color: theme.status,
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: height * .018,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Text(
                                      "ID-" + (widget.userInfo.srId ?? ""),
                                      style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * .01,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Text(
                                        'EDIT PROFILE',
                                        style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w800,
                                          color: theme.status,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * .018,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: isPremium
                                    ? Text(
                                        'Account - Premium',
                                        style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Account - Free',
                                        style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  'Profile Completed - ${totalProfileCompleted}%',
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              !isPremium
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PremiuimPlanScreen(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: width * .4,
                                        height: height * .053,
                                        decoration: BoxDecoration(
                                          color: theme.colorPrimary,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              MdiIcons.crown,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: width * 0.02,
                                            ),
                                            Text(
                                              'Upgrade Now',
                                              style: GoogleFonts.ptSans(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: height * .02,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    BannerAdView(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        // add this
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PartnerPreferenceScreen(
                                    partnerInfo: (widget.userInfo.partnerInfo ?? PartnerInfo()),
                                  ),
                                ),
                              );
                            },
                            leading: Icon(
                              MdiIcons.accountMultiple,
                              color: Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              'Partner Preferences',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              MdiIcons.chevronRight,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileVerificationScreen(govId),
                                ),
                              );
                            },
                            leading: Icon(
                              MdiIcons.check,
                              color: Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              'Verify Profile',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              MdiIcons.chevronRight,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AccountSettingsScreen(),
                                ),
                              );
                            },
                            leading: Icon(
                              Icons.settings,
                              color: Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              'Account Settings',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              MdiIcons.chevronRight,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),

                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MyPrivacyScreen(),
                                ),
                              );
                            },
                            leading: Icon(
                              Icons.privacy_tip,
                              color: Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              'Privacy Setting',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              MdiIcons.chevronRight,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),


                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MySubscriptionsScreen(),
                                ),
                              );
                            },
                            leading: Icon(
                              MdiIcons.crown,
                              color: Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              'My Subscriptions',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              MdiIcons.chevronRight,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              final link = WhatsAppUnilink(
                                phoneNumber: '+919634395495',
                                text:
                                    "Hey! I'm inquiring about SUNHARE Rishtey",
                              );
                              await launch('$link');
                              /* Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HelpScreen(),
                                ),
                              ); */
                            },
                            leading: Icon(
                              MdiIcons.helpCircle,
                              color: Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              'Help & Support',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              MdiIcons.chevronRight,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              launch(
                                  'https://play.google.com/store/apps/details?id=com.sunhare.rishtey');
                            },
                            leading: Icon(
                              MdiIcons.star,
                              color: Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              'Rate App',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              MdiIcons.chevronRight,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          /* ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PrivacyPolicyScreen(),
                                ),
                              );
                            },
                            leading: Icon(
                              MdiIcons.clipboard,
                              color: Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              'Privacy Policy',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              MdiIcons.chevronRight,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ), */
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShareUserScreen(user: widget.userInfo),
                                ),
                              );
                            },
                            leading: Icon(
                              MdiIcons.shareVariant,
                              color: Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              'Share Profile',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              MdiIcons.chevronRight,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Share.share(
                                'Find a best match for you . https://play.google.com/store/apps/details?id=com.sunhare.rishtey',
                                subject:
                                    'Sunhare Rhistey.. click on the link to download',
                              );
                            },
                            leading: Icon(
                              MdiIcons.share,
                              color: Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              'Share App',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              MdiIcons.chevronRight,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 56),
                    Text("v" + version,
                        style: GoogleFonts.lato(color: Colors.grey)),
                    SizedBox(height: 28),
                  ],
                ),
              ),
      ),
    );
  }

  void updateState(PremiumModel premiumValues) {
    isPremium = premiumValues.isActive != null ? premiumValues.isActive ?? false : false;
    setState(() {});
  }
}
