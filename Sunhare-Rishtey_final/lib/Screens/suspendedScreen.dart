import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import '../auth/GetStartedScreen.dart';

class SuspendedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * .4,
          width: MediaQuery.of(context).size.width * .88,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      child: Text('LogOut'),
                      onPressed: () async {
                        final fbm = FirebaseMessaging.instance;
                        String token = await fbm.getToken() ?? "";
                        FirebaseDatabase.instance
                            .reference()
                            .child("Push Notifications")
                            .child(FirebaseAuth.instance.currentUser!.uid)
                            .child(token)
                            .remove()
                            .then((value) => {
                                  FirebaseAuth.instance.signOut().then((value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => LoginScreen()));
                                  })
                                });
                      },
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text('Waiting',
                          style: GoogleFonts.workSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    decoration: BoxDecoration(
                        color: HexColor('fa9033'),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    width: MediaQuery.of(context).size.width * .88,
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .06,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Your account is Suspended By Admin.',
                          style: GoogleFonts.workSans(
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Please check back later!',
                          style: GoogleFonts.workSans(
                              color: HexColor('293662'),
                              fontWeight: FontWeight.w600)),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
