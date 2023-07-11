import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import '/Providers/getUserInfo.dart';
import '/Screens/photoScreen.dart';
import '/models/UserModel.dart';
import 'package:provider/provider.dart';
import '/main.dart';
import '/Screens/EditSection.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> privacyList = [
    'All Member',
    'Premium Members only',
    'Connected Members',
  ];
  List hobbies = [];
  List intrests = [];
  List favMusic = [];
  List sportsFitness = [];
  List favCousine = [];
  List dressStyle = [];
  getHobbies() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('Hobbies')
        .onValue
        .listen((event) {
      List snapShot = event.snapshot.value != null ? event.snapshot.value as List : [];
      if (snapShot.isNotEmpty) hobbies = snapShot;
      setState(() {});
    });
  }

  getIntrests() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('Intrests')
        .onValue
        .listen((event) {
      List snapShot = event.snapshot.value != null ? event.snapshot.value as List : [];
      if (snapShot.isNotEmpty) intrests = snapShot;
      setState(() {});
    });
  }

  getFavMusic() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('music')
        .onValue
        .listen((event) {
      List snapShot = event.snapshot.value != null ? event.snapshot.value as List : [];
      if (snapShot.isNotEmpty) favMusic = snapShot;
      setState(() {});
    });
  }

  getSportsFitness() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('Fitness')
        .onValue
        .listen((event) {
      List snapShot = event.snapshot.value != null ? event.snapshot.value as List : [];
      if (snapShot.isNotEmpty) sportsFitness = snapShot;
      setState(() {});
    });
  }

  getFavCousine() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('Cousine')
        .onValue
        .listen((event) {
      List snapShot = event.snapshot.value != null ? event.snapshot.value as List : [];
      if (snapShot.isNotEmpty) favCousine = snapShot;
      setState(() {});
    });
  }

  getDressStyle() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('dressStyle')
        .onValue
        .listen((event) {
      List snapShot = event.snapshot.value != null ? event.snapshot.value as List : [];
      if (snapShot.isNotEmpty) dressStyle = snapShot;
      setState(() {});
    });
  }

  bool isEditableProfile = true;
  getEditableStatus() {
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('isEditable')
        .onValue
        .listen((event) {
       isEditableProfile = (event.snapshot.value ?? true) as bool;

      setState(() {});
    });
  }


  UserInformation userInfo = UserInformation();
  @override
  void initState() {
    getHobbies();
    getIntrests();
    getFavMusic();
    getSportsFitness();
    getFavCousine();
    getDressStyle();
    getEditableStatus();
    super.initState();
  }

  List<String> images = [];


  void deleteDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(
          'Are you sure you want to Delete',
        ),
        actions: [
          MaterialButton(
            child: Text(
              "Cancel",
              style: GoogleFonts.openSans(
                fontSize: 14,
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          MaterialButton(
            child: Text(
              "Delete",
              style: theme.text14boldPimary,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  String? visibility;

  @override
  void didChangeDependencies() {
    userInfo = Provider.of<CurrUserInfo>(context).currentUser;
    visibility = userInfo.visibility != null ? userInfo.visibility : 'All Member';
    super.didChangeDependencies();
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
            style: GoogleFonts.lato(),
          ),
          actions: [
            InkWell(
              onTap: () {
                if(isEditableProfile){
                  print("editable");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditSection(
                      userInfo: userInfo,
                    ),
                  ),
                );
                }else{
                  Fluttertoast.showToast(msg: "For edit Profile please Contact to Admin.");
                }
              },
              child: Icon(
                Icons.edit,
              ),
            ),
            SizedBox(
              width: width * .05,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .01,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      height: height * .2,
                      child: GestureDetector(
                        onTap: () {
                          // picker();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width * .01,
                            ),
                            Container(
                              height: height * .2,
                              width: width * .3,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: userInfo.imageUrl == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        Text(
                                          'Click Here',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'to upload',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * .01,
                                          width: width * 1,
                                        ),
                                        Icon(
                                          MdiIcons.camera,
                                          size: 35,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Photo',
                                          style: GoogleFonts.lato(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Stack(
                                      // overflow: Overflow.visible,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Center(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PhotoScreen(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: width,
                                              height: height,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  userInfo.imageUrl ?? "",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: width * .05,
                                          child: Container(
                                            color: Colors.black.withOpacity(.8),
                                            child: Text(
                                              'Edit/View',
                                              style: GoogleFonts.workSans(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: width * .02,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    RichText(
                      text: TextSpan(
                        text: userInfo.name?.toUpperCase() ?? 'Loading',
                        style: GoogleFonts.ptSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: theme.colorPrimary,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' (${userInfo.srId ?? ""})',
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .003,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Basic Info',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'Posted for',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.postedBy == null ? 'other ' : userInfo.postedBy}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Age',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${calculateAge(userInfo.dateOfBirth ?? "")}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Gender',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.gender}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Marital Status',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.maritalStatus == null ? 'Not Provided' : userInfo.maritalStatus}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Height',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.height == null ? 'Not Provided' : userInfo.height}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Any Disability?',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.anyDisAbility == null ? 'none' : userInfo.anyDisAbility}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Health Information',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.healthInfo == null ? 'none' : userInfo.healthInfo}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Blood Group',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.bloodGroup == null ? 'none' : userInfo.bloodGroup}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * .85,
                      child: Text(
                        'More about Myself, Partner and Family Member',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: theme.colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Text(
                    userInfo.intro ?? 'Here Bio will be displayed',
                    style: GoogleFonts.ptSans(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Religious Background',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'Religion',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.religion == null ? 'Not Provided' : userInfo.religion}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Mother Tongue',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.motherTongue == null ? 'Not Provided' : userInfo.motherTongue}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Community',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.community == null ? 'Not Provided' : userInfo.community}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Father\'s Gothra',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.fatherGautra == null ? 'Not Provided' : userInfo.fatherGautra}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Mother\'s Gothra',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.motherGautra == null ? 'Not Provided' : userInfo.motherGautra}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Family',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'Family Values',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.familyValues == null ? 'Not Provided' : userInfo.familyValues}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Affluence Level',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.affluenceLevel == null ? 'Not Provided' : userInfo.affluenceLevel}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Father\'s Name',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.fatherName == null ? 'Not Provided' : userInfo.fatherName}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Father\'s Status',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.fatherStatus == null ? 'Not Provided' : userInfo.fatherStatus}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Mother\'s Name',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.motherName == null ? 'Not Provided' : userInfo.motherName}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Mother\'s Status',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.motherStatus == null ? 'Not Provided' : userInfo.motherStatus}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Home Town',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.nativePlace == null ? 'Not Provided' : userInfo.nativePlace}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Married Brothers',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.brothers == null ? 'Not Provided' : userInfo.marriedBrothers}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Unmarried Brothers',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.brothers == null ? 'Not Provided' : userInfo.brothers}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Married Sisters',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.sisters == null ? 'Not Provided' : userInfo.marriedSisters}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Unmarried Sisters',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.sisters == null ? 'Not Provided' : userInfo.sisters}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Astro Details',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'City of Birth',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.city == null ? 'Not Provided' : userInfo.city}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Manglik / Chevvai dosham',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.manglik == null ? 'Not Provided' : userInfo.manglik}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Date of Birth',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.dateOfBirth == null ? 'Not Provided' : userInfo.dateOfBirth.toString()}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Time of Birth',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            userInfo.birthTime != null
                                ? ': ${userInfo.birthTime!.hourOfPeriod}:${userInfo.birthTime!.minute} ${userInfo.birthTime!.period.toString().split('.').last}'
                                : ': Not Provided',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Show Time & City of Birth',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            userInfo?.showHoroscope ?? false ? ": Yes" : ": No",
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Location Education & Career',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'Country Living in',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.country == null ? 'Not Provided' : userInfo.country}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'State Living in',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.state == null ? 'Not Provided' : userInfo.state}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'City Living in',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.city == null ? 'Not Provided' : userInfo.city}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Highest Qualification',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.highestQualification == null ? 'Not Provided' : userInfo.highestQualification}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'College(s) Attended',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Container(
                            width: width * .45,
                            child: Text(
                              ': ${userInfo.collegeAttended == null ? 'Not Provided' : userInfo.collegeAttended}',
                              style: GoogleFonts.ptSans(
                                fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Working with',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Container(
                            width: width * .45,
                            child: Text(
                              ': ${userInfo.workingWith == null ? 'Not Provided' : userInfo.workingWith}',
                              style: GoogleFonts.ptSans(
                                fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Working as',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.workingAs == null ? 'Not Provided' : userInfo.workingAs}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Employed in',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              ': ${userInfo.employedIn == null ? 'Not Provided' : userInfo.employedIn}',
                              style: GoogleFonts.ptSans(
                                fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Annual Income',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.annualIncome == null ? 'Not Provided' : userInfo.annualIncome}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lifestyle',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'Diet',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.diet == null ? 'Not Provided' : userInfo.diet}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hobbies and More',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorPrimary,
                      ),
                    ),
                    /*   GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => HobbiesAndMoreScreen(
                                    hobbies: hobbies,
                                    cousine: favCousine,
                                    dressStyle: dressStyle,
                                    favMusic: favMusic,
                                    intrests: intrests,
                                    fitness: sportsFitness,
                                  )),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                   */
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'Hobbies',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          hobbies.length != 0
                              ? Flexible(
                                  child: Text(
                                    ': ${hobbies == null ? 'Not Provided' : hobbies}',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : Text(
                                  ' : Not Provided',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 16,
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
                            width: width * .4,
                            child: Text(
                              'Intrests',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          intrests.length != 0
                              ? Flexible(
                                  child: Text(
                                    ': ${intrests == null ? 'Not Provided' : intrests}',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : Text(
                                  ' : Not Provided',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 16,
                                  ),
                                )
                        ],
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'FavMusic',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          favMusic.length != 0
                              ? Flexible(
                                  child: Text(
                                    ': ${favMusic == null ? 'Not Provided' : favMusic}',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : Text(
                                  ' : Not Provided',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 16,
                                  ),
                                )
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'Select/fitness Activities',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          sportsFitness.length != 0
                              ? Flexible(
                                  child: Text(
                                    ': ${sportsFitness == null ? 'Not Provided' : sportsFitness}',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : Text(
                                  ' : Not Provided',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 16,
                                  ),
                                )
                        ],
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'Cousine',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          favCousine.length != 0
                              ? Flexible(
                                  child: Text(
                                    ': ${favCousine == null ? 'Not Provided' : favCousine}',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : Text(
                                  ' : Not Provided',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 16,
                                  ),
                                )
                        ],
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'Dress Style',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          dressStyle.length != 0
                              ? Flexible(
                                  child: Text(
                                    ': ${dressStyle == null ? 'Not Provided' : dressStyle}',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : Text(
                                  ' : Not Provided',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 16,
                                  ),
                                )
                        ],
                      ),
                      SizedBox(height: height * .02),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Extras',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * .4,
                            child: Text(
                              'Promote and share my profile outside application',
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Text(
                            ': ${userInfo.allowMarketing ?? false ? "Yes" : "No"}',
                            style: GoogleFonts.ptSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .06,
              )
            ],
          ),
        ),
      ),
    );
  }
}
