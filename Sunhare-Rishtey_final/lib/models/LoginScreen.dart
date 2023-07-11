import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimonial_app/Screens/TermsAndConditions.dart';
import '/auth/SignUp.dart';
import '/main.dart';
import 'VerifyOtp.dart';


class LoginOtpScreen extends StatefulWidget {
  @override
  _LoginOtpScreenState createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final editControllerName = TextEditingController();
  String phone = "";
  final _key = GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;

  bool termsNconditions = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.colorBackground,
      body: Stack(
        children: [
          // BannerAdView(),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            width: width,
            child: _body(),
          ),
        ],
      ),
    );
  }

  var countrycode = "+91";

  _pressLoginButton(bool isOld) async {
    final phoneNo = countrycode + phone;

    setState(() {
      isLoading = true;
    });
    if (isOld) {
      print("123 aaya");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OtpVerificationLoginScreen(
            phoneno: phoneNo,
            isOld: true,
          ),
        ),
      );
      return;
    }
    try {
      final hasDta = await FirebaseDatabase.instance
          .reference()
          .child('User Information')
          .orderByChild('mobileNo')
          .equalTo('$phoneNo')
          .once();


      if (hasDta.snapshot.value != null) {

        Map getUserMapData = hasDta.snapshot.value as Map;

        String keyIdGet = getUserMapData.keys.toList()[0];

        print("isInTrash check=====>>>${getUserMapData}");

        bool isInTrash = (getUserMapData[keyIdGet]['inTrash'] ?? false) as bool;

        print("isInTrash check=====>>>$isInTrash");

        if(isInTrash) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'Your account is deleted for restore contact to admin');
          return ;
        } else {
          setState(() {
            isLoading = false;
          });
          print("456 aaya");
          Navigator.of(context).push (
            MaterialPageRoute (
              builder: (context) => OtpVerificationLoginScreen (
                phoneno: phoneNo,
                isOld: false,
              ),
            ),
          );
          // if(FirebaseAuth.instance.currentUser?.uid != null) {
            String testData = getUserMapData[keyIdGet]['id'] ?? "";
            if(testData.isNotEmpty) {
              await FirebaseDatabase.instance
                  .reference()
                  .child('User Information')
                  .child(FirebaseAuth.instance.currentUser?.uid ?? testData)
                  .update({"isDeleteByAdmin": false});
            }

          // }
        }
      } else {
        Fluttertoast.showToast(msg: 'No user found, Please Sign up first');
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp(phoneNo)));
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      setState(() { });
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  _body() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        SizedBox(
          height: height * .01,
        ),
        Container(
          margin: EdgeInsets.only(
            left: 0,
            right: 20,
            top: 10,
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            "SUNHARE Rishtey", // "Let's start with LogIn!"
            style: GoogleFonts.lato(
              fontSize: 24,
              color: theme.colorPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: height * .01,
        ),
        Text(
          " Login with your Phone Number",
          style: GoogleFonts.lato(
            fontSize: 17,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: height * .2,
        ),
        Container(
          child: Text(
            'Mobile Number',
            style: GoogleFonts.openSans(
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(
          height: height * .015,
        ),
        Form(
          key: _key,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8),
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
            child: TextFormField(
              maxLength: 10,
              validator: (value) {
                if (value == null) {
                  return "Enter in field";
                }
                if (value.length != 10) {
                  return "*Enter correct Number";
                } else {
                  phone = value;
                  return null;
                }
              },
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 16,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              cursorColor: theme.colorCompanion,
              decoration: InputDecoration(
                counter: SizedBox.shrink(),
                prefixIcon: Container(
                  padding: EdgeInsets.only(top: 7),
                  child: CountryCodePicker(
                    barrierColor: Colors.black,
                    textStyle: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    initialSelection: 'IN',
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    onChanged: (value) => countrycode = value.dialCode ?? "",
                  ),
                ),
                contentPadding: const EdgeInsets.only(top: 21),
                hintText: "Enter your Number",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: height * .02,
        ),
        InkWell(
          onTap: () {
            setState(() {
              termsNconditions = !termsNconditions;
            });
          },
          child: Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                activeColor: theme.colorPrimary,
                value: termsNconditions,
                onChanged: (bool? value) {
                  setState(() {
                    termsNconditions = value ?? false;
                  });
                },
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsAndConditions(),
                      ),
                    );
                  },
                  child: Text(
                    'I agree terms and conditions',
                    style: GoogleFonts.openSans(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                if (!termsNconditions) {
                  Fluttertoast.showToast(
                      msg: "Please accept terms and conditions");
                  return;
                }
                if (_key.currentState!.validate()) {
                  _pressLoginButton(false);
                }
              },
              child: Container(
                height: height * .05,
                width: width * .5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      theme.colorPrimary,
                      theme.colorPrimary,
                    ],
                    tileMode: TileMode.repeated,
                  ),
                ),
                child: isLoading
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 15,
                      )
                    : Center(
                        child: Text(
                          "Continue",
                          style: GoogleFonts.ptSans(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
