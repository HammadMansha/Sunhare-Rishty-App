import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/auth/GetStartedScreen.dart';
import 'package:matrimonial_app/auth/otp.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:matrimonial_app/main.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationDeleteScreen extends StatefulWidget {
  final UserInformation currentUser;
  final String reason;
  OtpVerificationDeleteScreen({required this.currentUser, required this.reason});

  @override
  _OtpVerificationDeleteScreenState createState() =>
      _OtpVerificationDeleteScreenState();
}

class _OtpVerificationDeleteScreenState
    extends State<OtpVerificationDeleteScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Timer? _timer;
  int _start = 60;

  bool isVerified = false;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 0) {
                timer.cancel();
              } else {
                _start = _start - 1;
              }
            }));
  }

  bool isCodeSent = false;
  var isValidating = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId = "";
  bool _isLoading = false;
  PinDecoration _pinDecoration = UnderlineDecoration(
    enteredColor: Colors.black,
  );
  TextEditingController _pinEditingController = TextEditingController();

  void _onFormSubmitted() async {
    // ignore: deprecated_member_use
    _isLoading = true;
    setState(() {});
    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);
    _firebaseAuth.signInWithCredential(_authCredential).then((value) async {
      if (value.user != null) {
        isVerified = true;
        deleteDialog(context);
      }
    }).catchError((error) {
      showToast(error.toString(), Colors.red);
    });
  }

  void _onVerifyCode() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((value) async {
        if (value.user != null) {
          isVerified = true;
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.red);
      });
    };
    final PhoneVerificationFailed verificationFailed = (authException) {
      showToast(authException.message, Colors.red);
      print(":::: ${authException.message}");
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        isCodeSent = true;
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    //Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "${widget.currentUser.phone}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  void initState() {
    startTimer();
    _onVerifyCode();
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  void deleteDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(
          'Are you sure you want to Delete?\n\nWithin 15 Days you can login your account again, after that your account will be delete.',
        ),
        actions: [
          MaterialButton(
            child: Text(
              "Cancel",
              style: theme.text12bold,
            ),
            onPressed: () async {

             //  final dateTime = DateTime.now();
             //  final stringDateTime = dateTime.toIso8601String();
             //  final parsedDateTime = DateTime.parse(stringDateTime);
             //
             // await FirebaseDatabase.instance
             //     .reference()
             //     .child('User Information')
             //     .onValue
             //     .listen((event) {
             //   final data = event.snapshot.value as Map;
             //   print("data is===>>>>${data}");
             //   if (data.isNotEmpty) {
             //     data.forEach((key, value) {
             //       print("key---->>>$key");
             //       if (value.containsKey("AccountDeleteDate")){
             //         print("value----->>>${value}");
             //         print("aaaaa==>>${value['AccountDeleteDate']}");
             //
             //           if(parsedDateTime.isBefore(DateTime.parse(value['AccountDeleteDate']))){
             //             print("bbbb==>>not delte");
             //           }else{
             //             print("cccc==>>delte");
             //           }
             //       }
             //
             //         // govList.add(GovIdModel(
             //         //     imageUrl: value['imageUrl'],
             //         //     isVerified: value['isVerified'],
             //         //     name: value['name'],
             //         //     srId: value['srId'],
             //         //     document: value['varificationBy'],
             //         //     userId: value['userId'],
             //         //     varifiedBy: value['verifiedBy']));
             //     });
             //     setState(() {});
             //   }
             // });

              Navigator.of(ctx).pop();
            },
          ),
          MaterialButton(
            child: Text(
              "Sure",
              style: theme.text12bold,
            ),
            onPressed: () async {
              print("::: User Approved");

              final now = DateTime.now();
              final after15days = now.add(Duration(days: 15));
              print("after15days=======>>>>>${after15days.toIso8601String()}");


              print("user Id=======>>>>>${FirebaseAuth.instance.currentUser!.uid}");
              print("user DeletedReason =======>>>>>${widget.reason}");

              await FirebaseDatabase.instance
                  .reference()
                  .child('User Information')
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .update({'AccountDeleteDate': after15days.toIso8601String(),
                'Reason': widget.reason,'DeletedBy': "User", "isDeleteByAdmin": true});

              DateTime endDate = DateTime.now().add(const Duration(days: 15));
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
                'unHideDate': finalEndDate,
              });

              FirebaseAuth.instance.signOut();
              _googleSignIn.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));

              // sendPushNotificationToAdmin("Account Deleted",
              //     "${widget.currentUser.name} deleted account",
              //     target: Constants.ADMIN_ID_VERIFICATION,
              //     userId: FirebaseAuth.instance.currentUser?.uid ?? "");
              // final user = FirebaseAuth.instance.currentUser;
              // final data = await FirebaseDatabase.instance
              //     .reference()
              //     .child("User Information")
              //     .child(FirebaseAuth.instance.currentUser?.uid ?? "")
              //     .once();
              // final mapped = data.snapshot.value as Map;
              // mapped['DeletedTime'] = DateTime.now().toIso8601String();
              // mapped['Reason'] = widget.reason;
              // await FirebaseDatabase.instance
              //     .reference()
              //     .child('trash')
              //     .update({'${data.key}': mapped});
              // FirebaseDatabase.instance
              //     .reference()
              //     .child("User Information")
              //     .child(FirebaseAuth.instance.currentUser?.uid ?? "")
              //     .remove()
              //     .then((value) {
              //   user?.unlink("phone").then((value) => {
              //         user.delete().then((value) {
              //           FirebaseAuth.instance.signOut();
              //           _googleSignIn.signOut();
              //         })
              //       });
              //   Navigator.of(context).popUntil((route) => route.isFirst);
              //   Navigator.of(context).pushReplacement(MaterialPageRoute(
              //     builder: (context) => LoginScreen(),
              //   ));
              // });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 50, right: 30, left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/pie.png',
                    scale: 1.2,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'OTP Verification',
                  style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please enter verification code sent to your mobile',
                  style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 12)),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.currentUser.phone ?? "",
                  style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 12)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 5),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 45,
                      fieldWidth: 45,
                      borderWidth: 1,
                      activeColor: Colors.red,
                      selectedColor:Colors.red,
                      inactiveColor: Colors.red,
                    ),
                    cursorColor: Colors.black,
                    controller: _pinEditingController,
                    keyboardType: TextInputType.number,

                    onCompleted: (v) {
                      debugPrint("Completed");
                    },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        //currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      return true;
                    },
                  )/*PinInputTextField(
                    pinLength: 6,
                    decoration: _pinDecoration,
                    controller: _pinEditingController,
                    autoFocus: true,
                    textInputAction: TextInputAction.done,
                    onSubmit: (pin) {
                      if (pin.length == 6) {
                        _onFormSubmitted();
                      } else {
                        showToast("Invalid OTP", Colors.red);
                      }
                    },
                  )*/,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .05,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _start > 0
                            ? Container(
                                child: Text(
                                  "Resend in " + _start.toString() + ' sec',
                                  style: GoogleFonts.workSans(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : MaterialButton(
                                onPressed: () {
                                  if (_start <= 0) {
                                    startTimer();
                                    _start = 60;
                                    _onVerifyCode();
                                  }
                                },
                                child: Text(
                                  'Resend',
                                  style: GoogleFonts.workSans(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                isValidating
                    ? Container(
                        child: Column(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            Text('Please wait we are auto validating')
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (_pinEditingController.text.length == 6) {
                      if (isVerified) {
                        deleteDialog(context);
                      } else {
                        _onFormSubmitted();
                      }
                    } else {
                      showToast("Invalid OTP", Colors.red);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        color: HexColor('FA163F'),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: _isLoading
                              ? SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: 20,
                                )
                              : Text(
                                  isCodeSent ? 'Continue' : 'Sending OTP...',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
