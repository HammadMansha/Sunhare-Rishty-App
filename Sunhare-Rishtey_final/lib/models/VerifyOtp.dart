import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrimonial_app/Providers/UserProvider.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/Screens/HomeScreen.dart';
import 'package:matrimonial_app/Screens/PartnerPreferenceScreen.dart';
import 'package:matrimonial_app/auth/SignUp.dart';
import 'package:matrimonial_app/auth/otp.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpVerificationLoginScreen extends StatefulWidget {
  final String phoneno;
  final bool isOld;
  OtpVerificationLoginScreen({required this.phoneno, required this.isOld});

  @override
  _OtpVerificationLoginScreenState createState() =>
      _OtpVerificationLoginScreenState();
}

class _OtpVerificationLoginScreenState
    extends State<OtpVerificationLoginScreen> {
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
    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);
    _firebaseAuth.signInWithCredential(_authCredential).then((value) async {
      await setPartnerPrefData();
      onVerified(value, _authCredential);
    }).catchError((error) {
      print("aaaaaa$error");
      showToast(error.toString(), Colors.red);
    });
  }

  // UserInformation? currentUser;
  UserInformation currentUser = UserInformation();

  setPartnerPrefData() async {
    final currentUser1 = Provider.of<CurrUserInfo>(context, listen: false);
    currentUser = currentUser1.currentUser;
    if(currentUser == null || currentUser.isPhone == null) {
      // final ref = Provider.of<CurrUserInfo>(context, listen: false);
      await currentUser1.getData();
      currentUser = currentUser1.currentUser;
      // currentUser = Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    }
    setState(() {});
  }

  onVerified(value, phoneAuthCredential) async {
    if (value.user != null) {
      // setState(() {
      //   _isLoading = true;
      // });

      final accountExists =
          await Provider.of<UserProvider>(context, listen: false)
              .checkProfile(value.user.uid);
      print("account exist--->>>$accountExists");
      if (!accountExists) {
        final isMobile = await Provider.of<UserProvider>(context, listen: false)
            .checkNumber(value.user.uid, widget.phoneno);
        if (isMobile) {
          print("direct aaya");
          showToast("Found your old account.", Colors.green);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(isRedirectingFromLogin: false),
            ),
          );
        } else {
          FirebaseAuth.instance.currentUser!
              .unlink(phoneAuthCredential.providerId)
              .then((value) {
            FirebaseAuth.instance.signOut();
          });
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignUp(widget.phoneno)));
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
      setState(() {
        _isLoading = false;
      });
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(isRedirectingFromLogin: false),
      //   ),
      // );
      print("partnew info${currentUser!.partnerInfo!}");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PartnerPreferenceScreen(partnerInfo: currentUser!.partnerInfo!,fromOtpScreen: true)));
    } else {
      showToast("Error validating OTP, try again", Colors.red);
    }
  }

  void _onVerifyCode() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((value) async {
        onVerified(value, phoneAuthCredential);
      }).catchError((error) {
        showToast("Try again in sometime", Colors.red);
      });
    };

    final PhoneVerificationFailed verificationFailed = (authException) {
      showToast(authException.message, Colors.red);
      print(":::: ${authException.message}");
      print("qqqqqq${authException.message}");
      setState(() {
        isCodeSent = false;
      });
    };


    PhoneCodeSent codeSent = (String verificationId, [int? forceResendingToken]) async {
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
        phoneNumber: "${widget.phoneno}",
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
                  widget.phoneno ?? "",
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
                    if (isCodeSent) {
                      _onFormSubmitted();
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please wait for OTP to be sent");
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
