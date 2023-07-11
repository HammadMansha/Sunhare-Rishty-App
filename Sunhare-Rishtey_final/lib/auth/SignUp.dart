import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import '/Providers/mobilenoProvider.dart';
import '/auth/Info1.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  final String phoneno;
  SignUp(this.phoneno);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  User? user;
  bool isGoogleSigned = false;
  TextEditingController phone = new TextEditingController();
  var selectedGender;
  var selectedprofile;
  var selectedreligion;

  var selectedCommunity;
  String selectedSubCommunity = "";

  var selectedcountry;
  String selectedHour = "01", selectedMinute = "01", selectedAmPm = "AM";

  List<int> femaleYearList = [];
  List<int> maleYearList = [];
  String first_name = "First Name";
  String last_name = "Last Name";
  String first_name_hint = "Enter your First Name";
  String last_name_hint = "Enter your Last Name";

  getYearList() {
    femaleYearList.clear();
    DateTime endYear = DateTime.now().subtract(Duration(days: 6209));
    DateTime startYear = DateTime.now().subtract(Duration(days: 24824));
    for (int x = startYear.year; x < endYear.year; x++) {
      femaleYearList.add(x);
    }
    femaleYearList.sort((a, b) => b.compareTo(a));
  }

  getMaleList() {
    maleYearList.clear();
    DateTime endYear = DateTime.now().subtract(Duration(days: 7300));
    DateTime startYear = DateTime.now().subtract(Duration(days: 24824));
    for (int x = startYear.year; x < endYear.year; x++) {
      maleYearList.add(x);
    }
    maleYearList.sort((a, b) => b.compareTo(a));
  }

  String selectedDay = "";
  String selectedMonth = "";
  int selectedYear = 0;
  String fname = "";
  String lastName = "";
  String email = "";
  String password = "";
  String gender = "";
  String mobileno = "";
  String profileFor = "";
  String commodity = "";
  String livingIn = "";
  bool isLoading = false;
  String tempEmail = "";

  getTempEmail() {
    String key = Uuid().v4().substring(0, 6);
    tempEmail = key;
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }

  String uid = "";

  bool isRedirected = false;
  @override
  void initState() {
    getYearList();
    getMaleList();
    getTempEmail();
    mobileno = widget.phoneno;
    log(mobileno);

    // selectedHour = DateFormat("h").format(DateTime.now()).toString();
    // if(selectedHour.length == 1){
    //   selectedHour = "0"+selectedHour;
    // }
    // selectedMinute = DateFormat("mm").format(DateTime.now()).toString();
    // if(selectedMinute.length == 1){
    //   selectedMinute = "0"+selectedMinute;
    // }
    // selectedAmPm = DateFormat("a").format(DateTime.now()).toString();

    super.initState();
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay timeOfBirth = TimeOfDay.now();
  bool showHoroscope = true;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedS = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (pickedS != null && pickedS != selectedTime)
      setState(() {
        selectedTime = pickedS;
        timeOfBirth = pickedS;
      });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 8,
          backgroundColor: theme.colorCompanion,
          actions: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorPrimary,
                  radius: 15,
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
                    color: Colors.black54,
                    thickness: 1.5,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black54,
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
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * .010,
                  ),
                  Text(
                    'Create Your Account',
                    style: GoogleFonts.inter(
                      fontSize: 27,
                      color: theme.colorDefaultText,
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),

                  Container(
                    child: Text(
                      'Profile for',
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
                          return 'Required*';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      hint: Text('Select'),
                      items: Constants.profileList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        selectedprofile = value;

                        if(selectedprofile == "Self"){
                          first_name = "Your First Name";
                          last_name = "Your Last Name";
                          first_name_hint = "Enter Your First Name";
                          last_name_hint = "Enter Your Last Name";
                        }else if(selectedprofile == "Son"){
                          first_name = "Sons First Name";
                          last_name = "Sons Last Name";
                          first_name_hint = "Enter Sons First Name";
                          last_name_hint = "Enter Sons Last Name";
                        }else if(selectedprofile == "Daughter"){
                          first_name = "Daughter First Name";
                          last_name = "Daughter Last Name";
                          first_name_hint = "Enter Daughter First Name";
                          last_name_hint = "Enter Daughter Last Name";
                        }else if(selectedprofile == "Brother"){
                          first_name = "Brother First Name";
                          last_name = "Brother Last Name";
                          first_name_hint = "Enter Brother First Name";
                          last_name_hint = "Enter Brother Last Name";
                        }else if(selectedprofile == "Sister"){
                          first_name = "Sister First Name";
                          last_name = "Sister Last Name";
                          first_name_hint = "Enter Sister First Name";
                          last_name_hint = "Enter Sister Last Name";
                        }else if(selectedprofile == "Friend"){
                          first_name = "Friend First Name";
                          last_name = "Friend Last Name";
                          first_name_hint = "Enter Friend First Name";
                          last_name_hint = "Enter Friend Last Name";
                        }else if(selectedprofile == "Relative"){
                          first_name = "Relative First Name";
                          last_name = "Relative Last Name";
                          first_name_hint = "Enter Relative First Name";
                          last_name_hint = "Enter Relative Last Name";
                        }

                      },
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),


                  Container(
                    child: Text(
                      first_name,
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
                        if (val!.trim().isEmpty) {
                          return 'Required*';
                        } else {
                          fname = val.trim();
                          return null;
                        }
                      },
                      cursorColor: theme.colorCompanion,
                      decoration: InputDecoration(
                        hintText: first_name_hint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      last_name,
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
                        if (val!.trim().isEmpty) {
                          return 'Required*';
                        } else {
                          lastName = val;
                          return null;
                        }
                      },
                      cursorColor: theme.colorCompanion,
                      decoration: InputDecoration(
                        hintText: last_name_hint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Email Address',
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = RegExp(pattern);
                        if (val!.isEmpty) {
                          return 'Required*';
                        } else {
                          // if (val.contains("@") && val.length > 4) {
                          if ((regex.hasMatch(val))) {
                            email = val.trim();
                            return null;
                          } else {
                            return 'Invalid value';
                          }
                        }
                      },
                      cursorColor: theme.colorCompanion,
                      decoration: InputDecoration(
                        hintText: "email@example.com",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Gender',
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
                        if (val != null) {
                          return null;
                        } else
                          return 'Required*';
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      hint: Text('Select'),
                      items: Constants.genderList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          selectedGender = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),

                  Container(
                    child: Text(
                      'Religion',
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
                          return 'Required*';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      hint: Text('Select'),
                      items: Constants.religionList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        selectedreligion = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Community (Optional)',
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
                      onChanged: (val) {
                        selectedCommunity = val;
                      },
                      cursorColor: theme.colorCompanion,
                      decoration: InputDecoration(
                        hintText: "Enter your Community",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Birth Date',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: width * .27,
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
                              return 'Required*';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Day'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          items: Constants.dayList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            selectedDay = value ?? "";
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * .03,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: width * .27,
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
                          isExpanded: true,
                          validator: (val) {
                            if (val == null) {
                              return 'Required*';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Month'),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          items: Constants.monthList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            selectedMonth = value ?? "";
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * .03,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: width * .27,
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
                              return 'Required*';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Year'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          items: selectedGender == 'Male'
                              ? maleYearList.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toString(),
                                    ),
                                  );
                                }).toList()
                              : femaleYearList.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toString(),
                                    ),
                                  );
                                }).toList(),
                          onChanged: (value) {
                            selectedYear = value ?? 0;
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    child: Text(
                      'Time of Birth',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),


                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10),
                        width: width * .27,
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
                          // value: selectedHour,
                          // validator: (val) {
                          //   if (val == null) {
                          //     return 'Required*';
                          //   } else
                          //     return null;
                          // },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Hour'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          items: Constants.hourList.map((e) {
                            return DropdownMenuItem(
                                value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            selectedHour = value ?? "";
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * .03,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10),
                        width: width * .27,
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
                          // value: selectedMinute,
                          isExpanded: true,
                          // validator: (val) {
                          //   if (val == null) {
                          //     return 'Required*';
                          //   } else
                          //     return null;
                          // },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Minute'),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          items: Constants.minuteList.map((e) {
                            return DropdownMenuItem(
                                value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            selectedMinute = value ?? "";
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * .03,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10),
                        width: width * .27,
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
                          // value: selectedAmPm,
                          // validator: (val) {
                          //   if (val == null) {
                          //     return 'Required*';
                          //   } else
                          //     return null;
                          // },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('AM/PM'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          items: Constants.AmPmList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.toString(),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedAmPm = value ?? "";
                            FocusScope.of(context)
                                .requestFocus(
                                new FocusNode());
                          },
                        ),
                      ),
                    ],
                  ),


                  /*Container(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      height: height * .06,
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
                      child: InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Card(
                            elevation: 0,
                            child: timeOfBirth != null
                                ? Center(
                                    child: Text(
                                        '${timeOfBirth.hour}:${timeOfBirth.minute} ${timeOfBirth.period.toString().split('.').last}'))
                                : Center(child: Text('Not Provided'))),
                      )),*/
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
                      child: CheckboxListTile(
                        title: Text(
                          'Horoscope privacy settings(show Time of birth and City of Birth)',
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                          ),
                        ),
                        value: showHoroscope,
                        onChanged: (val) {
                          setState(() {});
                          showHoroscope = val ?? false;
                        },
                      )),
                  SizedBox(
                    height: height * .03,
                  ),
                  InkWell(
                    onTap: () async {
                      if(isRedirected) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                Info1(isRedirected),
                          ),
                        );
                      }
                      else {
                        String birthDimedateTime;

                        if (selectedAmPm == "") {
                          birthDimedateTime = "";
                        }
                        else if (selectedAmPm == "PM") {
                          birthDimedateTime = "TimeOfDay(${(int.parse(
                              selectedHour) + 12)
                              .toString()}:${selectedMinute})";
                        } else {
                          birthDimedateTime = "TimeOfDay(${int.parse(
                              selectedHour).toString()}:${selectedMinute})";
                        }

                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          Provider.of<Mobileno>(context, listen: false)
                              .setPhoneNo(mobileno.trim());
                          if (isGoogleSigned) {
                            print("google signup");
                            setState(() {
                              isLoading = true;
                            });
                            FirebaseDatabase.instance
                                .reference()
                                .child('User Information')
                                .child(uid)
                                .update({
                              'userName': fname + " " + lastName,
                              'email': email.toLowerCase(),
                              'gender': selectedGender,
                              'Religion': selectedreligion,
                              'Community': selectedCommunity,
                              'isVerified': false,
                              'living': selectedcountry,
                              'ProfileFor': selectedprofile,
                              'DateOfBirth': selectedDay +
                                  '/' +
                                  selectedMonth +
                                  '/' +
                                  selectedYear.toString(),
                              'timeOfBirth': birthDimedateTime,
                              //'timeOfBirth': timeOfBirth.toString(),
                              'showHoroscope': showHoroscope
                            }).then((value) {
                              setState(() {
                                // Navigator.of(context).popUntil((route) => route.isFirst);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Info1(true)));
                                isLoading = false;
                              });
                            });
                          } else {
                            print("without google signup");
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              String x = mobileno.substring(2);
                              password = Uuid().v1().substring(1, 9);
                              tempEmail = "SR$x$tempEmail@sr.com";
                              log(tempEmail);
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                  email: tempEmail, password: password)
                                  .then(
                                    (value) {
                                  print("user register id--------${value.user
                                      ?.uid}");
                                  FirebaseDatabase.instance
                                      .reference()
                                      .child('User Information')
                                      .child(value.user?.uid ?? "")
                                      .update({
                                    'userName': fname + " " + lastName,
                                    'email': email.toLowerCase(),
                                    // 'createdOn': DateTime.now().toIso8601String(),
                                    'status': 'Active',
                                    'gender': selectedGender,
                                    //'mobileNo': mobileno,
                                    'isVerified': false,
                                    'ProfileFor': selectedprofile,
                                    'Religion': selectedreligion,
                                    'Community': selectedCommunity,
                                    'living': selectedcountry,
                                    'DateOfBirth': selectedDay +
                                        '/' +
                                        selectedMonth +
                                        '/' +
                                        selectedYear.toString(),
                                    'timeOfBirth': birthDimedateTime,
                                    //'timeOfBirth': timeOfBirth.toString(),
                                    'showHoroscope': showHoroscope
                                  }).then(
                                        (value) {
                                      setState(() {
                                        isLoading = false;
                                        isRedirected = true;
                                        print("isRedirected===>>$isRedirected");
                                      });
                                      // Navigator.of(context).popUntil((route) => route.isFirst);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Info1(isRedirected),
                                        ),
                                      );

                                      print("selected comunity--->>>$selectedCommunity");
                                      print("birthDimedateTime--->>>$birthDimedateTime");

                                      if(selectedCommunity != null){
                                        totalProfileCompleted = totalProfileCompleted + percentAdd;
                                        print("totalProfileCompleted--->>>$totalProfileCompleted");
                                      }
                                      if(birthDimedateTime.isNotEmpty){
                                        totalProfileCompleted = totalProfileCompleted + percentAdd;
                                        print("totalProfileCompleted--->>>$totalProfileCompleted");
                                      }

                                    },
                                  );
                                },
                              );
                            } on PlatformException catch (e) {
                              print(e);
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: e.toString() ?? "Error occured",
                                  backgroundColor: HexColor('fa9033'));
                              setState(() {
                                isLoading = false;
                              });
                            }
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
                                : Center(
                                    child: SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .015,
                  ),
                  Center(
                    child: Container(
                      width: width * .6,
                      child: Text(
                        'By submitting you agree to our terms and services',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .07,
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
