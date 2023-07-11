import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import '../Screens/OtpScreenNewUser.dart';
import '/main.dart';

class Info4 extends StatefulWidget {
  @override
  _Info4State createState() => _Info4State();
}

class _Info4State extends State<Info4> {
  bool isLoading = false;
  bool allowMarketing = true;
  String motherTounge = "";
  String motherGoutra = "";
  String fatherGoutra = "";
  String fatherStatus = "";
  String motherStatus = "";
  String nativeCity = "";
  String familyType = "";
  String cityOfBirth = "";
  String manglik = "";
  String noOfBrothers = '0';
  String noOfSisters = '0';
  String marriedBrothers = '0';
  String marriedSisters = '0';
  final _key = GlobalKey<FormState>();

  bool termsNconditions = false;

  bool isRedirected = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          elevation: 8,
          backgroundColor: theme.colorCompanion,
          actions: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorPrimary,
                  radius: 10,
                  child: Text(
                    '1',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: width * .06,
                  child: Divider(
                    color: theme.colorPrimary,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: theme.colorPrimary,
                  radius: 10,
                  child: Text(
                    '2',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: width * .06,
                  child: Divider(
                    color: theme.colorPrimary,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: theme.colorPrimary,
                  radius: 10,
                  child: Text(
                    '3',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: width * .06,
                  child: Divider(
                    color: theme.colorPrimary,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: theme.colorPrimary,
                  radius: 10,
                  child: Text(
                    '4',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: width * .06,
                  child: Divider(
                    color: theme.colorPrimary,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: theme.colorPrimary,
                  radius: 15,
                  child: Text(
                    '5',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * .05,
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * .015,
                  ),
                  Container(
                    width: width,
                    child: Center(
                      child: Text(
                        "Every Detail Matters.!",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Container(
                    child: Text(
                      'Mother Tongue',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    // height: height * .06,
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
                    child: DropdownButtonFormField(
                      validator: (val) {
                        if (val == null) {
                          return 'Required';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      hint: Text('Select'),
                      items: Constants.motherTongueList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        motherTounge = value ?? "";
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Mother\'s Gothra / Gothram',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    // height: height * .06,
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
                      textCapitalization: TextCapitalization.sentences,
                      validator: (val) {
                        if (val!.trim().length < 3) {
                          return 'length is too short';
                        } else {
                          motherGoutra = val;
                          return null;
                        }
                      },
                      cursorColor: theme.colorCompanion,
                      decoration: InputDecoration(
                        hintText: "Enter Gothra / Gothram",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Father\'s Gothra / Gothram',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    // height: height * .06,
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
                      textCapitalization: TextCapitalization.sentences,
                      validator: (val) {
                        if (val!.trim().length < 3) {
                          return 'length is too short';
                        } else {
                          fatherGoutra = val;
                          return null;
                        }
                      },
                      cursorColor: theme.colorCompanion,
                      decoration: InputDecoration(
                        hintText: "Enter Gothra / Gothram",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Father\'s Status',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  //
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    // height: height * .06,
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
                    child: DropdownButtonFormField(
                      validator: (val) {
                        if (val == null) {
                          return 'Required';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      hint: Text('Select'),
                      items: Constants.fatherStatusList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        fatherStatus = value ?? "";
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Mother\'s Status',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
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
                    child: DropdownButtonFormField(
                      validator: (val) {
                        if (val == null) {
                          return 'Required';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      hint: Text('Select'),
                      items: Constants.motherStatusList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        //   FocusScope.of(context).requestFocus(new FocusNode());
                        motherStatus = value ?? "";
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Home Town',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
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
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      validator: (val) {
                        if (val!.trim().length < 3) {
                          return 'length is too short';
                        } else {
                          nativeCity = val;
                          return null;
                        }
                      },
                      cursorColor: theme.colorCompanion,
                      decoration: InputDecoration(
                        hintText: "Enter Place",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'No. of Siblings',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: width * .6,
                      height: height * .35,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .005,
                          ),
                          Center(
                            child: Text(
                              'No. of Brother (s)',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * .005,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    width: width * .15,
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
                                      initialValue: marriedBrothers != "0"
                                          ? marriedBrothers
                                          : "",
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        marriedBrothers = val ?? "";
                                        return null;
                                      },
                                      cursorColor: theme.colorCompanion,
                                      decoration: InputDecoration(
                                        hintText: "0",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Married',
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                MdiIcons.faceMan,
                                color: Colors.lightBlue,
                                size: 50,
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    width: width * .15,
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
                                      initialValue: noOfBrothers != "0"
                                          ? noOfBrothers
                                          : "",
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        noOfBrothers = val ?? "";
                                        return null;
                                      },
                                      cursorColor: theme.colorCompanion,
                                      decoration: InputDecoration(
                                        hintText: "0",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Unmarried',
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          Center(
                            child: Text(
                              'No. of Sister (s)',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    width: width * .15,
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
                                      initialValue: marriedSisters != "0"
                                          ? marriedSisters
                                          : "",
                                      validator: (val) {
                                        marriedSisters = val ?? "";
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      cursorColor: theme.colorCompanion,
                                      decoration: InputDecoration(
                                        hintText: "0",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Married',
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                MdiIcons.faceWoman,
                                color: Colors.pinkAccent,
                                size: 50,
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    width: width * .15,
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
                                      initialValue:
                                          noOfSisters != "0" ? noOfSisters : "",
                                      validator: (val) {
                                        noOfSisters = val ?? "";
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      cursorColor: theme.colorCompanion,
                                      decoration: InputDecoration(
                                        hintText: "0",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Unmarried',
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    child: Text(
                      'Family Type',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
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
                    child: DropdownButtonFormField(
                      validator: (val) {
                        if (val == null) {
                          return 'Required';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      hint: Text('Select'),
                      items: Constants.familyTypeList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        familyType = value ?? "";
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'City of Birth',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
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
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      validator: (val) {
                        if (val!.trim().length < 3) {
                          return 'length is too short';
                        } else {
                          cityOfBirth = val;
                          return null;
                        }
                      },
                      cursorColor: theme.colorCompanion,
                      decoration: InputDecoration(
                        hintText: "Enter City",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Manglik / Chevvai dosham',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    // height: height * .06,
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
                    child: DropdownButtonFormField(
                      validator: (val) {
                        if (val == null) {
                          return 'Required';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      hint: Text('Select'),
                      items: Constants.manglikList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        manglik = value ?? "";
                      },
                    ),
                  ),

                  SizedBox(
                    height: height * .005,
                  ),

                  InkWell(
                    onTap: () {
                      setState(() {
                        allowMarketing = !allowMarketing;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: theme.colorPrimary,
                          value: allowMarketing,
                          onChanged: (bool? value) {
                            setState(() {
                              allowMarketing = value ?? false;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            'Promote and share my profile outside application',
                            style: GoogleFonts.openSans(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),

/*                   InkWell(
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
                          value: termsNconditions ?? false,
                          onChanged: (bool value) {
                            setState(() {
                              termsNconditions = value;
                            });
                          },
                        ),
                        Flexible
                        (
                          
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
 */
                  SizedBox(
                    height: height * .005,
                  ),
                  InkWell(
                    onTap: () {
                      /* if (!termsNconditions) {
                        Fluttertoast.showToast(
                            msg: "Please accept terms and conditions");
                        return;
                      } */
                      if(isRedirected){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (ctx) => OtpScreen(isNewUser: true)),
                        );
                      }else{
                        _key.currentState!.save();
                        if (_key.currentState!.validate()) {
                          if (noOfBrothers == "" || noOfBrothers == null)
                            noOfBrothers = "0";
                          if (noOfSisters == "" || noOfSisters == null)
                            noOfSisters = "0";
                          if (marriedBrothers == "" || marriedBrothers == null)
                            marriedBrothers = "0";
                          if (marriedSisters == "" || marriedSisters == null)
                            marriedSisters = "0";
                          setState(() {
                            isLoading = true;
                          });
                          FirebaseDatabase.instance
                              .reference()
                              .child('Partner Prefrence')
                              .child(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'motherToungeForAll': true,
                          });
                          FirebaseDatabase.instance
                              .reference()
                              .child('User Information')
                              .child(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'FatherStatus': fatherStatus,
                            'brotherCount': noOfBrothers,
                            'cityOfBirth': cityOfBirth,
                            'familyType': familyType,
                            'motherGotra': motherGoutra,
                            'fatherGotra': fatherGoutra,
                            'maglik': manglik,
                            'nativePlace': nativeCity,
                            'sisterCount': noOfSisters,
                            'motherTongue': motherTounge,
                            'MotherStatus': motherStatus,
                            'marriedBrothers': marriedBrothers,
                            'marriedSisters': marriedSisters,
                            'allowMarketing': allowMarketing,
                            'DateTime': DateTime.now().toIso8601String()
                          }).then((value) {
                            setState(() {
                              isLoading = false;
                              isRedirected = true;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (ctx) => OtpScreen(isNewUser: true)),
                              );

                              print("selected marriedBrothers--->>>$marriedBrothers");
                              print("selected marriedSisters--->>>$marriedSisters");

                              if(marriedBrothers.isNotEmpty || marriedSisters.isNotEmpty) {
                                totalProfileCompleted = totalProfileCompleted + percentAdd;
                                print("totalProfileCompleted--->>>$totalProfileCompleted");
                              }

                              FirebaseDatabase.instance.reference()
                                  .child('profileCompleted')
                                  .child(FirebaseAuth.instance.currentUser!.uid).update({"profileCompletePercentage": totalProfileCompleted});

                            });
                          });
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          color: theme.colorCompanion,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: isLoading
                                ? SpinKitThreeBounce(
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Create Profile',
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
                  SizedBox(
                    height: height * .04,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
