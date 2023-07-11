import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/models/VerifyOtpForDelete.dart';
import 'package:provider/provider.dart';
import '../customs/Utils.dart';
import '/Screens/contactHideScreen.dart';
import '/Screens/dateOfBirthHideScreen.dart';
import '/Screens/hideProfileScreen.dart';
import '../auth/GetStartedScreen.dart';
import '../main.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class AccountSettingsScreen extends StatefulWidget {
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  TextEditingController deleteReasonController = TextEditingController();

  List<String> reasons = [
    'I found my partner on SUNHARE Rishtey app.',
    'I found my partner somewhere else.',
    'I don’t find SUNHARE Rishtey useful.',
    'I want to delete my profile temporarily.',
    'I am not getting good matches.',
    'I have privacy concerns in using this app.',
    'Membership plan is costly.',
    'I am getting lots of calls.',
    'I am getting very few matches.'
  ];
  List<int> selectedReasons = [];
  String reason = '';
  void deleteDialog(BuildContext context, double height, double width) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog();
      },
    );
    /*   showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Form(
          key: _key,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            width: width,
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorGrey,
              ),
              color: theme.colorBackground,
              borderRadius: BorderRadius.circular(
                5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  itemCount: reasons.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        if (selectedReasons.contains(index)) {
                          selectedReasons.remove(index);
                        } else {
                          selectedReasons.add(index);
                        }
                      },
                      leading: Checkbox(
                        value: selectedReasons.contains(index),
                        onChanged: (value) {
                          if (value) {
                            selectedReasons.add(index);
                          } else {
                            selectedReasons.remove(index);
                          }
                        },
                      ),
                      title: Text(reasons[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              "Cancel",
              style: theme.text12bold,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          MaterialButton(
            child: Text(
              "Sure",
              style: theme.text12bold,
            ),
            onPressed: () async {
              if (!_key.currentState.validate()) {
                Fluttertoast.showToast(msg: 'Reason required');
                return;
              }

              selectedReasons.forEach((element) {
                reason += reasons[element] + ', ';
              });
              reason = reason.substring(0, reason.length - 2);

              final user = FirebaseAuth.instance.currentUser;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OtpVerificationDeleteScreen(
                      phoneno: user.phoneNumber, reason: reason),
                ),
              );
              return;

              /* final data = await FirebaseDatabase.instance
                  .reference()
                  .child("User Information")
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .once();
              final mapped = data.snapshot.value as Map;
              // log(data.snapshot.value.toString());
              mapped.putIfAbsent(
                  'DeletedTime', () => DateTime.now().toIso8601String());
              mapped.putIfAbsent('Reason', () => reason);
              await FirebaseDatabase.instance
                  .reference()
                  .child('trash')
                  .update({'${data.key}': mapped});
              FirebaseDatabase.instance
                  .reference()
                  .child("User Information")
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .remove()
                  .then((value) {
                user.unlink("phone").then((value) => {
                      user.delete().then((value) {
                        FirebaseAuth.instance.signOut();
                        _googleSignIn.signOut();
                      })
                    });
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
              }); */
            },
          )
        ],
      ),
    );
   */
  }

  void logoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(
          'Are you sure you want to Logout',
        ),
        actions: [
          MaterialButton(
            child: Text(
              "Cancel",
              style: theme.text12bold,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          MaterialButton(
            child: Text(
              "Sure",
              style: theme.text12bold,
            ),
            onPressed: () async{
              FirebaseAuth.instance.signOut();
              _googleSignIn.signOut();

              await ImageUtils.clearCache();
              await ImageUtils.clearStorage();

              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
          )
        ],
      ),
    );
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
            'Account Settings',
            style: GoogleFonts.lato(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContactHideScreen(),
                      ),
                    );
                  },
                  leading: Icon(
                    MdiIcons.phone,
                  ),
                  title: Text(
                    'Hide Mobile No.',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    MdiIcons.chevronRight,
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DateOfBirthHideScreen(),
                      ),
                    );
                  },
                  leading: Icon(
                    MdiIcons.calendar,
                  ),
                  title: Text(
                    'Hide Date of Birth',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    MdiIcons.chevronRight,
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),
                ListTile(
                  onTap: () {
                    deleteDialog(context, height, width);
                  },
                  leading: Icon(
                    MdiIcons.delete,
                  ),
                  title: Text(
                    'DELETE',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    MdiIcons.chevronRight,
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HideProfileScreen(),
                      ),
                    );
                  },
                  leading: Icon(
                    MdiIcons.accountCancel,
                  ),
                  title: Text(
                    'Hide Profile',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    MdiIcons.chevronRight,
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),
                ListTile(
                  onTap: () {
                    logoutDialog(context);
                  },
                  leading: Icon(
                    MdiIcons.logout,
                  ),
                  title: Text(
                    'Log out',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    MdiIcons.chevronRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  List<int> selectedReasons = [];
  bool canUpload = false;
  String reason = "";
  List<String> reasons = [
    'I found my partner on SUNHARE Rishtey app',
    'I found my partner somewhere else',
    'I don’t find SUNHARE Rishtey useful',
    'I want to delete my profile temporarily',
    'I am not getting good matches',
    'I have privacy concerns in using this app',
    'Membership plan is costly',
    'I am getting lots of calls',
    'I am getting very few matches'
  ];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmation'),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(shrinkWrap: true, children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: reasons.length,
            itemBuilder: (_, index) {
              return ListTile(
                contentPadding: EdgeInsets.all(0),
                horizontalTitleGap: 0,
                visualDensity: VisualDensity.compact,
                title: Text(reasons[index]),
                onTap: () {
                  setState(() {
                    if (selectedReasons.contains(index)) {
                      selectedReasons.remove(index);
                    } else {
                      selectedReasons.add(index);
                    }
                  });
                },
                leading: Checkbox(
                    value: selectedReasons.contains(index),
                    onChanged: (val) {
                      setState(() {
                        if (val!) {
                          selectedReasons.add(index);
                        } else {
                          selectedReasons.remove(index);
                        }
                        canUpload = selectedReasons.length != 0;
                      });
                    }),
              );
            },
          ),
        ]),
      ),
      actions: [
        MaterialButton(
          child: Text(
            "Cancel",
            style: theme.text12bold,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        MaterialButton(
          child: Text(
            "Sure",
            style: theme.text12bold,
          ),
          onPressed: () async {

            if (reasons.length == 0) {
              Fluttertoast.showToast(msg: 'Reason required');
              return;
            }

            selectedReasons.forEach((element) {
              reason += reasons[element] + ', ';
            });
            reason = reason.substring(0, reason.length - 2) + ".";

            final userInfo =
                Provider.of<CurrUserInfo>(context, listen: false).currentUser;

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OtpVerificationDeleteScreen(
                    currentUser: userInfo, reason: reason),
              ),
            );
          },
        )
      ],
    );
  }
}
