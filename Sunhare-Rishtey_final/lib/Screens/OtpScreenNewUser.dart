import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:matrimonial_app/Providers/mobilenoProvider.dart';

import 'package:matrimonial_app/auth/otp.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/FCMNotifications.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'HomeScreen.dart';

class OtpScreen extends StatefulWidget {
  bool isNewUser = false;
  OtpScreen({required this.isNewUser});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Timer? _timer;
  int _start = 60;
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
  bool _isLoading = false;
  String phoneNo = "";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId = "";
  PinDecoration _pinDecoration = UnderlineDecoration(
    enteredColor: Colors.black,
    color: theme.colorCompanion,
  );
  TextEditingController _pinEditingController = TextEditingController();
  String id = "";
  int userCount = 1;
  getId() async {
    final idData =
        await FirebaseDatabase.instance.reference().child('UserIds').once();
    Map tempData = idData.snapshot.value as Map;
    if (idData.snapshot.value != null) {
      userCount = tempData['userCount'] + 1;
      FirebaseDatabase.instance
          .reference()
          .child('UserIds')
          .update({'userCount': userCount});
      int len = userCount.toString().length;
      if (len == 1) {
        id = "00000" + userCount.toString();
      } else if (len == 2) {
        id = '0000' + userCount.toString();
      } else if (len == 3) {
        id = '000' + userCount.toString();
      } else if (len == 4) {
        id = '00' + userCount.toString();
      } else if (len == 5) {
        id = '0' + userCount.toString();
      } else {
        id = userCount.toString();
      }
    } else {
      FirebaseDatabase.instance
          .reference()
          .child('UserIds')
          .update({'userCount': 1});
      userCount = 1;
      id = "00000" + userCount.toString();
      log(id);
    }
  }

  Future _onformsubmitted() async {
    print("_verificationId==>>>$_verificationId");
    print("smsCode==>>>${_pinEditingController.text}");
    AuthCredential _authCredential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: _pinEditingController.text);
    //  log(_authCredential.token.toString());
    //

    try {
      _firebaseAuth.currentUser!.linkWithCredential(_authCredential)
          .catchError((e) {
            print("e1====>>>>>${e}");
        Fluttertoast.showToast(
            msg: e.message ?? "Error occured",
            backgroundColor: HexColor('fa9033'));
        setState(() {
          _isLoading = false;
        });
      })
      .then((value) async {
        if (value.user!.phoneNumber != null) {
          setState(() {
            _isLoading = true;
          });
          await FirebaseDatabase.instance
              .reference()
              .child('premiumUsers')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({FirebaseAuth.instance.currentUser!.uid: true});
          await FirebaseDatabase.instance
              .reference()
              .child("User Information")
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "isPhoneVarified": true,
            'hasData': {"data": true},
            'mobileNo': phoneNo,
            'id': 'SR' + id.toString(),
          }).then((value) {});
          sendPushNotificationToAdmin("New User", "A new user joined the app.",
              target: Constants.ADMIN_NEW_USER_REQUEST,
              userId: FirebaseAuth.instance.currentUser!.uid);
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                isRedirectingFromLogin: true,
              ),
            ),
          );
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      });
    } on PlatformException catch (e) {
      print("e2====>>>>>${e}");
      print(e);
    } catch (e) {
      print("e3====>>>>>${e}");
      Fluttertoast.showToast (
          msg: e.toString() ?? "Error occured",
          backgroundColor: HexColor('fa9033')
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onVerifyCode() async {
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {
      // log(phoneAuthCredential.token.toString());
      try {
        _firebaseAuth.currentUser!.linkWithCredential(phoneAuthCredential)
            .catchError((e) {
          Fluttertoast.showToast(
              msg: e.message ?? "Error occured",
              backgroundColor: HexColor('fa9033'));
          setState(() {
            _isLoading = false;
          });
        }).then((value) async {
          if (value.user!.phoneNumber != null) {
            setState(() {
              _isLoading = true;
            });
            await FirebaseDatabase.instance
                .reference()
                .child('premiumUsers')
                .child(FirebaseAuth.instance.currentUser!.uid)
                .update({FirebaseAuth.instance.currentUser!.uid: true});
            await FirebaseDatabase.instance
                .reference()
                .child("User Information")
                .child(FirebaseAuth.instance.currentUser!.uid)
                .update({
              "isPhoneVarified": true,
              'id': 'SR' + id.toString(),
              'mobileNo': phoneNo,
              'hasData': {"data": true},
            }).then((value) {
              setState(() {
                _isLoading = false;
              });
            });
            sendPushNotificationToAdmin(
                "New User", "A new user joined the app.",
                target: Constants.ADMIN_NEW_USER_REQUEST,
                userId: FirebaseAuth.instance.currentUser!.uid);
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  isRedirectingFromLogin: true,
                ),
              ),
            );
          } else {
            showToast("Error validating OTP, try again", Colors.red);
          }
        });
      } on PlatformException catch (e) {
        print(e);
      }
      catch (e) {
        Fluttertoast.showToast(
            msg: e.toString() ?? "Error occured",
            backgroundColor: HexColor('fa9033'));
        setState(() {
          _isLoading = false;
        });
      }
    };
    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent = (String verificationId, [int? forceResendingToken]) async {
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
        phoneNumber: '$phoneNo',
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  bool isFiltered = false;
  @override
  void initState() {
    //phoneNo = "+91 1111111111";
    phoneNo = Provider.of<Mobileno>(context, listen: false).phoneno!;
    getId();
    startTimer();
    _onVerifyCode();
    super.initState();
  }

  dispose() {
    _timer!.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * .4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/shadiLogo.png',
                        scale: 1.8,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Verify Your Mobile No.',
                  style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We’ve send OTP to your mobile number to authenticate your account, Please check",
                  style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 12)),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Mobile number : $phoneNo",
                  style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 12)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                  PinCodeTextField(
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
                  )
                  /*PinInputTextField(
                    pinLength: 6,
                    decoration: _pinDecoration,
                    controller: _pinEditingController,
                    autoFocus: true,
                    textInputAction: TextInputAction.done,
                    onSubmit: (pin) {
                      if (pin.length == 6) {
                        _onformsubmitted();
                      } else {
                        Fluttertoast.showToast(msg: 'Invalid OTP');
                      }
                    },
                  )*/,
                ),
                SizedBox(
                  height: 10,
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
                GestureDetector(
                  onTap: () {
                    if (!isCodeSent) {
                      Fluttertoast.showToast(
                          msg: "Please wait for OTP to be sent");
                      return;
                    }
                    if (_pinEditingController.text.length != 6) {
                      Fluttertoast.showToast(msg: 'Invalid length');
                      return;
                    }
                    _onformsubmitted();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .06,
                    width: MediaQuery.of(context).size.width * .5,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
