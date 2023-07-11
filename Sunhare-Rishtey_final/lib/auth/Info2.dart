import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimonial_app/Config/theme.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import '/main.dart';
import 'Info3.dart';

class Info2 extends StatefulWidget {
  @override
  _Info2State createState() => _Info2State();
}

class _Info2State extends State<Info2> {
  var selectedGender;
  String qualification = "Ph.D.";
  String clg = "";
  String cName = "";
  String designation = "Accounts / Finance Professional";
  String annualIncome = "Not Working";
  String employedIn = "Private sector";
  bool isWorking = false;
  final _key = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

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
                  radius: 15,
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
                    color: Colors.black54,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black54,
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
                    color: Colors.black54,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 10,
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
                    height: height * .03,
                  ),
                  Container(
                    width: width,
                    child: Center(
                      child: Text(
                        "Just a few more steps! \n Please add your education & career details",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Container(
                    child: Text(
                      'Your highest qualification',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .015,
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
                    child: DropdownSearch(
                      mode: Mode.DIALOG,
                      showSelectedItems: true,
                      items: Constants.qualificationList,
                        dropdownSearchDecoration: InputDecoration(border: InputBorder.none,hintText: "Select",hintStyle: TextStyle(color: black)),
                        showSearchBox: true,
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        qualification = value as String;
                        print("$qualification");
                      },
                      // selectedItem: "Tunisia",
                      validator: (val) {
                        if (val == null) {
                          return 'Required';
                        } else
                          return null;
                      }
                    ),
                    //   DropdownButtonFormField(
                    //   // value: qualification,
                    //   validator: (val) {
                    //     if (val == null) {
                    //       return 'Required';
                    //     } else
                    //       return null;
                    //   },
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //   ),
                    //   hint: Text('Select'),
                    //   items: Constants.qualificationList.map((e) {
                    //     return DropdownMenuItem(value: e, child: Text(e));
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     FocusScope.of(context).requestFocus(new FocusNode());
                    //     qualification = value ?? "";
                    //   },
                    // ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    child: Text(
                      'College you attended',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .015,
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
                        if (val!.trim().isEmpty) {
                          return 'Required';
                        } else {
                          clg = val;
                          return null;
                        }
                      },
                      cursorColor: theme.colorCompanion,
                      decoration: InputDecoration(
                        hintText: "Specify highest degree college",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    child: Text(
                      'Employed In',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .015,
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
                      // value: employedIn,
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
                      items: Constants.employedInList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        isWorking = value != "Not Working";
                        FocusScope.of(context).requestFocus(new FocusNode());
                        employedIn = value ?? "";
                        setState(() {});
                      },
                    ),
                  ),
                  isWorking
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * .02,
                            ),
                            Container(
                              child: Text(
                                'You work with',
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * .015,
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (val) {
                                  if (val!.trim().isEmpty) {
                                    return 'Required';
                                  } else {
                                    cName = val;
                                    return null;
                                  }
                                },
                                cursorColor: theme.colorCompanion,
                                decoration: InputDecoration(
                                  hintText: "Enter Company Name",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            Container(
                              child: Text(
                                'As',
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * .015,
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
                              child: DropdownSearch(
                                  mode: Mode.DIALOG,
                                  showSelectedItems: true,
                                  items: Constants.designationList,
                                  dropdownSearchDecoration: InputDecoration(border: InputBorder.none,hintText: "Select",hintStyle: TextStyle(color: black)),
                                  showSearchBox: true,
                                  onChanged: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    designation = value ?? "";
                                  },
                                  // selectedItem: "Tunisia",
                                  validator:  (val) {
                                    if (val == null) {
                                      return 'Required';
                                    } else
                                      return null;
                                  },
                              ),

                              // DropdownButtonFormField(
                              //   // value: designation,
                              //   validator: (val) {
                              //     if (val == null) {
                              //       return 'Required';
                              //     } else
                              //       return null;
                              //   },
                              //   decoration: InputDecoration(
                              //     border: InputBorder.none,
                              //   ),
                              //   hint: Text('Select'),
                              //   items: Constants.designationList.map((e) {
                              //     return DropdownMenuItem(
                              //         value: e, child: Text(e));
                              //   }).toList(),
                              //   onChanged: (value) {
                              //     FocusScope.of(context)
                              //         .requestFocus(new FocusNode());
                              //     designation = value ?? "";
                              //   },
                              // ),
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            Container(
                              child: Text(
                                'Your annual income',
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * .015,
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
                                // value: annualIncome,
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
                                items: Constants.incomeList.map((e) {
                                  return DropdownMenuItem(
                                      value: e, child: Text(e));
                                }).toList(),
                                onChanged: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  annualIncome = value ?? "";
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: height * .04,
                  ),
                  InkWell(
                    onTap: () {
                      String id = FirebaseAuth.instance.currentUser!.uid;
                      _key.currentState!.save();
                      if (_key.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        if(designation == null || designation == ""){
                          designation = "Not Working";
                        }
                        if(annualIncome == null || annualIncome == ""){
                          annualIncome = "Not Working";
                        }
                        FirebaseDatabase.instance
                            .reference()
                            .child('User Information')
                            .child(id)
                            .update({
                          'qualification': qualification,
                          'clg': clg,
                          'workAt': cName,
                          'employedIn': employedIn,
                          'designation': designation,
                          'annualIncome': annualIncome
                        }).then((value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Info3(qualification),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        });
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
                            child: !isLoading
                                ? Text(
                                    'Submit',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  SizedBox(
                    height: height * .03,
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
