import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Screens/ViewProfileScreen.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/main.dart';
import 'package:matrimonial_app/models/UserModel.dart';

class ReportScreen extends StatefulWidget {
  final UserInformation reportUser;
  final UserInformation currentUserInfo;
  ReportScreen(this.reportUser, this.currentUserInfo) : super();

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String reason = "";
  bool reasonRequired = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reason for Reporting'),
          backgroundColor: theme.colorCompanion,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.grey[300],
              child: Row(
                children: [
                  Icon(
                    MdiIcons.flagTriangle,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: width - 64,
                    child: RichText(
                        text:
                            TextSpan(style: TextStyle(fontSize: 16), children: [
                      TextSpan(
                          text: "You are raising a complaint against ",
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                          )),
                      TextSpan(
                        text: widget.reportUser.name ?? "",
                        style: GoogleFonts.openSans(
                          color: Colors.blueAccent,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewProfileScreen(
                                  [widget.reportUser],
                                  0,
                                  widget.currentUserInfo.isPremium  ?? false),
                            ));
                          },
                      ),
                      TextSpan(
                          text: " with Sunhare Rishtey team",
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                          )),
                    ])),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Constants.reportReasons.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(0),
                    horizontalTitleGap: 0,
                    visualDensity: VisualDensity.compact,
                    title: Text(Constants.reportReasons[index]),
                    onTap: () {
                      setState(() {
                        reason = Constants.reportReasons[index];
                        reasonRequired = false;
                      });
                    },
                    leading: Radio(
                        groupValue: reason,
                        value: Constants.reportReasons[index],
                        activeColor: Colors.red,
                        onChanged: (val) {
                          setState(() {
                            reason = val ?? "";
                            reasonRequired = false;
                          });
                        }),
                  );
                },
              ),
            ),
            reasonRequired
                ? Text(
                    "*Please select a reason",
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
            SizedBox(height: height * .01),
            InkWell(
              onTap: () {
                if (reason == null) {
                  setState(() {
                    reasonRequired = true;
                  });
                  return;
                }
                FirebaseDatabase.instance
                    .reference()
                    .child('Reported Id')
                    .child(widget.reportUser.id ?? "")
                    .update({
                  'userId': widget.reportUser.id,
                  'reason': reason,
                  'nameOfReporter': widget.currentUserInfo.name,
                  'srIdOfReporter': widget.currentUserInfo.srId,
                  'gender': widget.reportUser.gender,
                  'reportedMobile': widget.reportUser.phone,
                  'name': widget.reportUser.name,
                  'srId': widget.reportUser.srId,
                  'imageUrl': widget.reportUser.imageUrl,
                  'reportedOn': DateTime.now().toIso8601String()
                }).then((value) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  sendPushNotificationToAdmin("Account Reported",
                      "${widget.currentUserInfo.name} reported ${widget.reportUser.name}",
                      target: Constants.ADMIN_ACCOUNT_REPORTED,
                      userId: widget.reportUser.id ?? "");
                  Fluttertoast.showToast(msg: 'Reported Successfully');
                });
              },
              child: Container(
                height: height * .071,
                alignment: Alignment.center,
                color: theme.colorPrimary,
                child: Text(
                  'Submit',
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
