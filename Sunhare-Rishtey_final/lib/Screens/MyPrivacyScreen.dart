import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/models/VerifyOtpForDelete.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Providers/hideProvider.dart';
import '../customs/Utils.dart';
import '../models/UserModel.dart';
import '../models/primiumModel.dart';
import '/Screens/contactHideScreen.dart';
import '/Screens/dateOfBirthHideScreen.dart';
import '/Screens/hideProfileScreen.dart';
import '../auth/GetStartedScreen.dart';
import '../main.dart';


class MyPrivacyScreen extends StatefulWidget {
  @override
  _MyPrivacyScreenState createState() => _MyPrivacyScreenState();
}

class _MyPrivacyScreenState extends State<MyPrivacyScreen> {

  int contactSelected = 0;
  int dobSelected = 0;
  int profileSelected = 0;
  int visibilitySelected = 0;
  List<String> contactList = ['Visible to All', 'Hide for 1 Week', 'Hide for 2 Week','Hide for 1 Month'];
  List<String> profileList = ['Visible to All', 'Hide for 1 Week', 'Hide for 2 Week','Hide for 1 Month'];
  List<String> DOBList = ['Visible to All','Hide for All'];
  List<String> visibilityList = [
    'All Member',
    'Premium Members only',
    'Connected Members',
  ];
  bool isLoading = true;

  bool isHide = false;

  String visibilityProfile = "All Member";

  dateOfBirthData() {
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('hideDob')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        isHide = data['dob'];
        if(isHide){
          dobSelected = 1;
        } else{
          dobSelected = 0;
        }
        setState(() {});
      }
    });
  }

  visibilityData() {
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('visibility')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value;
        print("visibility data is--->>${data}");
        visibilityProfile = data as String;
        if(visibilityProfile == "All Member"){
          visibilitySelected = 0;
        }else if(visibilityProfile == "Premium Members only"){
          visibilitySelected = 1;
        }else{
          visibilitySelected = 2;
        }
        setState(() {});
      }
    });
  }

  allowMarketingData(){
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('allowMarketing')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value;
        print("allowMarketing data is--->>${data}");
        checkbox = data as bool;
        // visibilityProfile = data;
        // if(visibilityProfile == "All Member"){
        //   visibilitySelected = 0;
        // }else if(visibilityProfile == "Premium Members only"){
        //   visibilitySelected = 1;
        // }else{
        //   visibilitySelected = 2;
        // }
        setState(() {});
      }
    });
  }

  bool hideForWeek = false;
  bool hideFor2Week = false;
  bool hideForMonth = false;

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
          bool hide = hideFor2Week || hideForWeek || hideForMonth;
          Provider.of<HideProvider>(context, listen: false).setHide(hide);
          if(!hide){
            profileSelected = 0;
          }
          if(hideForWeek){
            profileSelected = 1;
          }
          if(hideFor2Week){
            profileSelected = 2;
          }
          if(hideForMonth){
            profileSelected = 3;
          }
        });
      }
    });
  }


  changeDobSetting(bool val){
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('hideDob')
        .update({'dob': val});
  }

  changeVisibility(String val){
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({'visibility': val});
  }

  changeMarketingData(bool val){
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({'allowMarketing': val});
  }

  UserInformation userinfo = UserInformation();
  late SharedPreferences prefs;
  int hidemobdaysnumber = 0;

  bool checkbox = false;
  @override
  void initState() {
    // TODO: implement initState
    userinfo = Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    dateOfBirthData();
    getHideProfileStatus();
    visibilityData();
    allowMarketingData();
    Future.delayed(Duration.zero, () async{
      prefs = await SharedPreferences.getInstance();
      hidemobdaysnumber = prefs.getInt('hidemobdaysnumber') ?? 0;
      if(hidemobdaysnumber == 0){
        contactSelected = 0;
      }else if(hidemobdaysnumber == 7){
        contactSelected = 1;
      }else if(hidemobdaysnumber == 14){
        contactSelected = 2;
      }else{
        contactSelected = 3;
      }
    });


    Future.delayed(Duration(milliseconds: 500)).then((value) {
      isLoading  = false;
      setState(() {});
    });
    super.initState();
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
            'Privacy Setting',
            style: GoogleFonts.lato(),
          ),
        ),
        body: isLoading ?
        SpinKitThreeBounce(
          color: theme.colorPrimary,
        ) :  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Mobile No.',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),

            Wrap(
              spacing: 8,
              children: List.generate(contactList.length, (index) {
                return ChoiceChip(
                  labelPadding: EdgeInsets.all(2.0),
                  label: Text(
                    contactList[index],
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: contactSelected == index ? Colors.white : Colors.black, fontSize: 14),
                  ),
                  selected: contactSelected == index,
                  selectedColor: Colors.pinkAccent,
                  onSelected: (value) {
                    if (userinfo.isPremium == false) {
                      showAlertDialog(context);
                    } else {
                      setState(() {
                        contactSelected = value ? index : contactSelected;

                        if(contactSelected == 0){
                          unHideMobileNumber();
                        }else if(contactSelected == 1){
                          mobileHideCode(1);
                        }else if(contactSelected == 2){
                          mobileHideCode(2);
                        }else{
                          mobileHideCode(3);
                        }
                      });
                    }
                  },
                   backgroundColor: Colors.grey.withOpacity(0.1),
                  elevation: 1,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                );
              }),
            ),



                SizedBox(
                  height: height * .03,
                ),



                Text(
                  'Profile',
                  style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),

                Wrap(
                  spacing: 8,
                  children: List.generate(profileList.length, (index) {
                    return ChoiceChip(
                      labelPadding: EdgeInsets.all(2.0),
                      label: Text(
                        profileList[index],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: profileSelected == index ? Colors.white : Colors.black, fontSize: 14),
                      ),
                      selected: profileSelected == index,
                      selectedColor: Colors.pinkAccent,
                      onSelected: (value) {
                        if (userinfo.isPremium == false) {
                          showAlertDialog(context);
                        } else {
                        setState(() {
                          profileSelected = value ? index : profileSelected;
                          if(profileSelected == 0){
                            String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                            FirebaseDatabase.instance
                                .reference()
                                .child('User Information')
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .child('hideProfile')
                                .update({'1week': false, '2week': false, 'month': false,'unHideDate': currentDate,});
                          }else if(profileSelected == 1){

                            if (userinfo.isPremium == false) {
                              showAlertDialog(context);
                            } else {
                              DateTime endDate = DateTime.now().add(const Duration(days: 7));
                              String finalEndDate = DateFormat('yyyy-MM-dd').format(endDate);
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('User Information')
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .child('hideProfile')
                                  .update({
                                '1week': true,
                                '2week': false,
                                'month': false,
                                'unHideDate': finalEndDate,
                              });
                            }

                          }else if(profileSelected == 2){
                            if (userinfo.isPremium == false) {
                              showAlertDialog(context);
                            } else {
                              DateTime endDate = DateTime.now().add(const Duration(days: 14));
                              String finalEndDate = DateFormat('yyyy-MM-dd').format(endDate);
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('User Information')
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .child('hideProfile')
                                  .update({
                                '1week': false,
                                '2week': true,
                                'month': false,
                                'unHideDate': finalEndDate ,
                              });
                            }
                          }else{
                            if (userinfo.isPremium == false) {
                              showAlertDialog(context);
                            } else {
                              DateTime endDate = DateTime.now().add(const Duration(days: 30));
                              String finalEndDate = DateFormat('yyyy-MM-dd').format(endDate);
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('User Information')
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .child('hideProfile')
                                  .update({
                                '1week': false,
                                '2week': false,
                                'month': true,
                                'unHideDate':  finalEndDate,
                              });
                            }
                          }

                        });
                          }
                        },
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      elevation: 1,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    );
                  }),
                ),

                SizedBox(
                  height: height * .03,
                ),

                Text(
                  'Date of Birth',
                  style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),

                Wrap(
                  spacing: 8,
                  children: List.generate(DOBList.length, (index) {
                    return ChoiceChip(
                      labelPadding: EdgeInsets.all(2.0),
                      label: Text(
                        DOBList[index],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: dobSelected == index ? Colors.white : Colors.black, fontSize: 14),
                      ),
                      selected: dobSelected == index,
                      selectedColor: Colors.pinkAccent,
                      onSelected: (value) {
                        if (userinfo.isPremium == false) {
                          showAlertDialog(context);
                        } else {
                        setState(() {
                          dobSelected = value ? index : dobSelected;
                          if(dobSelected == 0){
                              changeDobSetting(false);
                          }else{
                              changeDobSetting(true);
                          }
                        });
                      }
                      },
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      elevation: 1,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    );
                  }),
                ),
                SizedBox(
                  height: height * .03,
                ),

                Text(
                  'Pictures Visibility',
                  style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),

                Wrap(
                  spacing: 8,
                  children: List.generate(visibilityList.length, (index) {
                    return ChoiceChip(
                      labelPadding: EdgeInsets.all(2.0),
                      label: Text(
                        visibilityList[index],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: visibilitySelected == index ? Colors.white : Colors.black, fontSize: 14),
                      ),
                      selected: visibilitySelected == index,
                      selectedColor: Colors.pinkAccent,
                      onSelected: (value) {
                        print("val==|>>${visibilityList[index]}");
                        setState(() {
                          visibilitySelected = value ? index : visibilitySelected;
                          if(visibilitySelected == 0){
                            changeVisibility(visibilityList[index]);
                            // changeDobSetting(false);
                          }else if(visibilitySelected == 1){
                            changeVisibility(visibilityList[index]);
                            // changeDobSetting(true);
                          }else{
                            changeVisibility(visibilityList[index]);
                          }
                        });
                      },
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      elevation: 1,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    );
                  }),
                ),
                SizedBox(
                  height: height * .03,
                ),
                Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: checkbox,
                      onChanged: (value) {
                        setState(() {
                          checkbox = !checkbox;
                          changeMarketingData(checkbox);
                        });
                      },
                    ),
                    Expanded(child: Text('Promote and Share my profile outside application')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary:Colors.pinkAccent,
          onPrimary: Colors.white,
          padding: EdgeInsets.all(0)),
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Please purchase membership to use this features."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  mobileHideCode(int selectedIndex) async{
    DateTime currentDate = DateTime.now();
    late  DateTime endDate;
    if(selectedIndex == 1){
      endDate = currentDate.add(const Duration(days: 7));
      await prefs.setInt('hidemobdaysnumber', 7);
    }else if(selectedIndex == 2){
      endDate = currentDate.add(const Duration(days: 14));
      await prefs.setInt('hidemobdaysnumber', 14);
    }else if(selectedIndex == 3){
      endDate = currentDate.add(const Duration(days: 30));
      await prefs.setInt('hidemobdaysnumber', 30);
    }

    DateFormat formatter = DateFormat('yyyy-MM-dd');

    PremiumModel getMembershipExpireDateData = await getExpireActivePlan();
    if(endDate.isBefore(getMembershipExpireDateData.validTill!) == false){
      endDate = getMembershipExpireDateData.validTill!;
    }
    String finalEndDate = formatter.format(endDate);
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('hideMobile')
        .update({'mobile': true, 'expireDate': finalEndDate});

  }

  Future<PremiumModel> getExpireActivePlan() async{
    final premi = await FirebaseDatabase.instance
        .reference()
        .child('ActiveMembership')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once();
    Map tempData = premi.snapshot.value as Map;
    PremiumModel premiumValues;

    if (tempData != null && tempData.isNotEmpty) {
      DateTime validTill2 = DateTime.parse(
          "${tempData['ValidTill'].split('T')[0]} 00:00:00.000");
      validTill2 = validTill2.add(Duration(days: 1));

      premiumValues = PremiumModel(
          dateOfPerchase: DateTime.parse(tempData['DateOfPerchase']),
          validTill: DateTime.parse(tempData['ValidTill']),
          contact: tempData['contacts'],
          name: tempData['name'],
          packageName: tempData['packageName'],
          isActive: tempData['ValidTill'] != null
              ? (validTill2.compareTo(DateTime.now()) > 0)
              : false);
    } else {
      premiumValues = PremiumModel();
    }

    return premiumValues;
  }

  void unHideMobileNumber() async{
    await prefs.setInt('hidemobdaysnumber', 0);

    DateTime endDate = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String finalEndDate = formatter.format(endDate);

    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('hideMobile')
        .update({'mobile': false, 'expireDate': finalEndDate});

  }

}
