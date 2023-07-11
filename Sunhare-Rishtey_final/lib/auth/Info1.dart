import 'package:firebase_auth/firebase_auth.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import '/Providers/mobilenoProvider.dart';
import 'package:provider/provider.dart';
import '/main.dart';
import 'Info2.dart';

class Info1 extends StatefulWidget {
  final bool isRedirected;
  Info1(this.isRedirected);
  @override
  _Info1State createState() => _Info1State();
}

class _Info1State extends State<Info1> {
  String cityValue = "";
  String countryValue = "";
  String stateValue = "";
  String maritalCurrentStatus = "Never Married";
  String livingTogetherStatus = "Yes. Living together";
  String childrenStatus = "1";
  String dietType = "Veg";
  String perHeight = "4' 5\" - 134 cm";
  String subCommunity = "";
  String referCode = "";
  final _key = GlobalKey<FormState>();
  getPhoneNumber() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(id)
        .once();
    print(data.snapshot.value);
    Map tempMap = data.snapshot.value as Map;
    if (tempMap['mobileNo'] != null) {
      Provider.of<Mobileno>(context, listen: false)
          .setPhoneNo(tempMap['mobileNo']);
    }
  }

  String id = "";
  @override
  void initState() {
    id = FirebaseAuth.instance.currentUser!.uid ?? "";
    if (!widget.isRedirected) getPhoneNumber();

    super.initState();
  }

  bool isLoading = false;
  bool isRedirected = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
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
                  radius: 15,
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
                    color: Colors.black54,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black54,
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
          elevation: 8,
          backgroundColor: theme.colorCompanion,
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
                        "Thanks for Registering. Now let's build your profile",
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
                      'You live in',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .015,
                  ),
                  //
                  Container(
                    width: width,
                    child: CSCPicker(
                      defaultCountry: CscCountry.India,
                      dropdownDecoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorGrey,
                        ),
                        color: theme.colorBackground,
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorGrey,
                        ),
                        color: theme.colorBackground,
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                      ),
                      layout: Layout.vertical,
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value ?? "";
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value ?? "";
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    child: Text(
                      'Your marital status',
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
                      items: Constants.maritalStatusListNew.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        maritalCurrentStatus = value ?? "";
                      },
                    ),
                  ),

                  maritalCurrentStatus != "Never Married"
                  ?Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .02,
                      ),
                      Container(
                        child: Text(
                          'Children',
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
                          // value: livingTogetherStatus,
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
                          items: Constants.livingTogetherList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            livingTogetherStatus = value ?? "";
                          },
                        ),
                      ),
                      livingTogetherStatus != "No" ? SizedBox(
                        height: height * .02,
                      ) : SizedBox(),
                      livingTogetherStatus != "No" ? Container(
                        child: Text(
                          'No. of Children',
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                          ),
                        ),
                      ) : SizedBox(),
                      livingTogetherStatus != "No" ? SizedBox(
                        height: height * .015,
                      ) : SizedBox(),
                      livingTogetherStatus != "No" ? Container(
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
                          // value: childrenStatus,
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
                          items: Constants.childrenList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            childrenStatus = value ?? "";
                          },
                        ),
                      ) : SizedBox(),
                    ],
                  ):SizedBox(),




                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    child: Text(
                      'Your diet',
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
                      items: Constants.dietList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        dietType = value ?? "";
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    child: Text(
                      'Your height',
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
                      items: Constants.heightList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        perHeight = value ?? "";
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    child: Text(
                      'Refer Code (Optional)',
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
                      onChanged: (val) {
                        referCode = val;
                      },
                      cursorColor: theme.colorCompanion,
                      decoration: InputDecoration(
                        hintText: "Refer code",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .04,
                  ),
                  InkWell(
                    onTap: () {
                      if(isRedirected){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Info2(),
                          ),
                        );
                      }else{
                        _key.currentState!.save();
                        if (_key.currentState!.validate()) {
                          if (cityValue != null &&
                              stateValue != null &&
                              countryValue != null) {
                            setState(() {
                              isLoading = true;
                            });

                            String tempChildren = maritalCurrentStatus == "Never Married" ? "" :  childrenStatus;
                            String tempLivingTog = maritalCurrentStatus == "Never Married" ? "" :  livingTogetherStatus;

                            FirebaseDatabase.instance
                                .reference()
                                .child('User Information')
                                .child(id)
                                .update({
                              'state': stateValue,
                              'city': cityValue,
                              'living': countryValue,
                              'maritalStatus': maritalCurrentStatus,
                              'diet': dietType,
                              'personHeight': perHeight,
                              'referCode': referCode,
                              'noOfChildren':tempChildren,
                              'childrenLivingTogether':tempLivingTog,
                            }).then((value) {
                              setState(() {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Info2(),
                                  ),
                                );
                                isLoading = false;
                                isRedirected = true;

                                print("selected state--->>>$stateValue");
                                print("selected city--->>>$cityValue");
                                print("selected country--->>>$countryValue");

                                if(stateValue.isNotEmpty && stateValue != "State"){
                                  totalProfileCompleted = totalProfileCompleted + percentAdd;
                                  print("totalProfileCompleted--->>>$totalProfileCompleted");
                                }
                                if(cityValue.isNotEmpty && cityValue != "City"){
                                  totalProfileCompleted = totalProfileCompleted + percentAdd;
                                  print("totalProfileCompleted--->>>$totalProfileCompleted");
                                }

                              });
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Country , State, city required');
                          }
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
                                    color: Colors.white,
                                    size: 15,
                                  )
                                : Text(
                                    'Submit',
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
                    height: height * .02,
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
