import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/Providers/hideProvider.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class HideProfileScreen extends StatefulWidget {
  @override
  _HideProfileScreenState createState() => _HideProfileScreenState();
}

class _HideProfileScreenState extends State<HideProfileScreen> {
  bool hideForWeek = false;
  bool hideFor2Week = false;
  bool hideForMonth = false;
  UserInformation userinfo = UserInformation();

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = ElevatedButton(
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
        });
      }
    });
  }

  @override
  void initState() {
    getHideProfileStatus();
    userinfo = Provider.of<CurrUserInfo>(context, listen: false).currentUser;
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
          'Hide Unhide',
          style: GoogleFonts.lato(),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {},
            child: Card(
              elevation: 8,
              margin: EdgeInsets.symmetric(),
              child: Container(
                height: height * .06,
                width: width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * .1,
                    ),
                    Icon(
                      Icons.calendar_today,
                    ),
                    SizedBox(
                      width: width * .1,
                    ),
                    Text(
                      'Hide for 1 week',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: width * .2,
                    ),
                    Switch(
                        value: hideForWeek,
                        onChanged: (val) {
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
                              '1week': val,
                              '2week': false,
                              'month': false,
                              'unHideDate': val ? finalEndDate : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            });
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Card(
              elevation: 8,
              margin: EdgeInsets.symmetric(),
              child: Container(
                height: height * .06,
                width: width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * .1,
                    ),
                    Icon(
                      Icons.calendar_view_week,
                    ),
                    SizedBox(
                      width: width * .1,
                    ),
                    Text(
                      'Hide for 2 week',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: width * .2,
                    ),
                    Switch(
                        value: hideFor2Week,
                        onChanged: (val) {
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
                              '2week': val,
                              'month': false,
                              'unHideDate': val ? finalEndDate : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            });
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Card(
              elevation: 8,
              margin: EdgeInsets.symmetric(),
              child: Container(
                height: height * .06,
                width: width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * .1,
                    ),
                    Icon(
                      Icons.assignment_outlined,
                    ),
                    SizedBox(
                      width: width * .1,
                    ),
                    Text(
                      'Hide for month',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: width * .2,
                    ),
                    Switch(
                        value: hideForMonth,
                        onChanged: (val) {
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
                              'month': val,
                              'unHideDate': val ? finalEndDate : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            });
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                FirebaseDatabase.instance
                    .reference()
                    .child('User Information')
                    .child(FirebaseAuth.instance.currentUser!.uid)
                    .child('hideProfile')
                    .update({'1week': false, '2week': false, 'month': false,'unHideDate': currentDate,});
              },
              child: Text('UnHide'))
        ],
      ),
    );
  }
}
