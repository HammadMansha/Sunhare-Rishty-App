import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/main.dart';

class DateOfBirthHideScreen extends StatefulWidget {
  @override
  _DateOfBirthHideScreenState createState() => _DateOfBirthHideScreenState();
}

class _DateOfBirthHideScreenState extends State<DateOfBirthHideScreen> {
  bool hide = false;
  dateOfBirthHideScreen() {
    FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('hideDob')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        hide = data['dob'];
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    dateOfBirthHideScreen();
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
          'Hide Date of Birth',
          style: GoogleFonts.lato(),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * .02,
          ),
          Card(
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
                    'Hide ',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: width * .2,
                  ),
                  Switch(
                      value: hide,
                      onChanged: (val) {
                        FirebaseDatabase.instance
                            .reference()
                            .child('User Information')
                            .child(FirebaseAuth.instance.currentUser!.uid)
                            .child('hideDob')
                            .update({'dob': val});
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
