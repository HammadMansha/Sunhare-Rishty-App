import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import '/Providers/allUser.dart';
import '/Screens/searchResultScreen.dart';
import '/models/UserModel.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import '/main.dart';

class SearchScreen extends StatefulWidget {
  final Map requestStatus;
  SearchScreen(this.requestStatus);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  var selectedDiet;
  var selectedcountry;

  var selectedprofile;
  var selectedreligion;



  String minAge = "18";
  String maxAge = "80";
  String minHeight = "4' 5\" - 134 cm";
  String maxHeight = "7' 0\" - 213 cm";
  String motherToung = "Hindi";
  String qualification = "Ph.D.";
  String designation = "Accounts / Finance Professional";
  String minIncome = "Not Working";
  String maxIncome = "> 30 lakhs";


  final _key = GlobalKey<FormState>();
  bool isLoading = false;
  List<UserInformation> tempList = [];
  String enteredId = "";

  List selectedreligionList = [];
  List selectedmotherToungueList = [];
  List selectedMaritalStatusList = [];
  List selectedLocationList = [];
  List selectedDesignation = [];
  List selectedDietList = [];
  List selectedQualificationList = [];
  List selectedManglikList = [];
  List selectedEmployedInList = [];

  bool isLocationForAll = true;
  bool isQualificationForAll = true;
  bool isDesignationForAll = true;
  bool isDietForAll = true;
  bool religionForAll = true;
  bool maritalStatusForAll = true;
  bool employedInForAll = true;
  bool motherTongueForAll = true;
  bool manglikForAll = true;

  double minAgeSlider = 18.0;
  double maxAgeSlider = 80.0;

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 2, vsync: this);
  }

  search() {
    allUsers.forEach((element) {
      if (!religionForAll &&
          selectedreligionList.length != 0 &&
          element.religion != null &&
          !selectedreligionList.contains(element.religion)) {
        tempList.remove(element);
      }
      if (!motherTongueForAll &&
          selectedmotherToungueList.length != 0 &&
          element.motherTongue != null &&
          !selectedmotherToungueList.contains(element.motherTongue)) {
        tempList.remove(element);
      }
      if (!maritalStatusForAll &&
          selectedMaritalStatusList.length != 0 &&
          element.maritalStatus != null &&
          !selectedMaritalStatusList.contains(element.maritalStatus)) {
        tempList.remove(element);
      }
      if (!isLocationForAll &&
          selectedLocationList.length != 0 &&
          element.state != null &&
          !selectedLocationList.contains(element.state)) {
        tempList.remove(element);
      }
      if (!isQualificationForAll &&
          selectedQualificationList.length != 0 &&
          element.highestQualification != null &&
          !selectedQualificationList.contains(element.highestQualification)) {
        tempList.remove(element);
      }
      if (!isDesignationForAll &&
          selectedDesignation.length != 0 &&
          element.workingAs != null &&
          !selectedDesignation.contains(element.workingAs)) {
        tempList.remove(element);
      }
      if (!isDietForAll &&
          selectedDietList.length != 0 &&
          element.diet != null &&
          !selectedDietList.contains(element.diet)) {
        tempList.remove(element);
      }
      if (!employedInForAll &&
          selectedEmployedInList.length != 0 &&
          element.employedIn != null &&
          !selectedEmployedInList.contains(element.employedIn)) {
        tempList.remove(element);
      }
      if (!manglikForAll &&
          selectedManglikList.length != 0 &&
          element.manglik != null &&
          !selectedManglikList.contains(element.manglik)) {
        tempList.remove(element);
      }
      if (element.dateOfBirth != null) {
        if (minAge != null &&
            int.parse(minAge) > calculateAge(element.dateOfBirth ?? "")) {
          tempList.remove(element);
        }
        if (maxAge != null &&
            int.parse(maxAge) < calculateAge(element.dateOfBirth ?? "")) {
          tempList.remove(element);
        }
      }
      if (element.height != null) {
        String str = element.height!.split(' - ')[1];
        int elementHeight = int.parse(str.substring(0, str.length - 2));
        if (maxHeight != null) {
          String str2 = maxHeight.split(' - ')[1];
          int maxIntHeight = int.parse(str2.substring(0, str2.length - 2));
          if (elementHeight > maxIntHeight) {
            tempList.remove(element);
          }
        }
        if (minHeight != null) {
          String str3 = minHeight.split(' - ')[1];
          int minIntHeight = int.parse(str3.substring(0, str3.length - 2));
          if (elementHeight < minIntHeight) {
            tempList.remove(element);
          }
        }
      }
      if (element.annualIncome != null) {
        String tempStr = "";
        if(element.annualIncome == ""){
          tempStr = "Not Working";
        }else{
          tempStr = element.annualIncome ?? "Not Working";
        }
        int income = countIncome(tempStr);
        if (minIncome != "" && countIncome(minIncome) > income) {
          tempList.remove(element);
        }
        if (maxIncome != "" && countIncome(maxIncome) < income) {
          tempList.remove(element);
        }
      }
    });
  }

  int countIncome(String annualIncome) {
    String str = annualIncome.replaceAll("-", "").replaceAll(" lakhs", "");
    if (str.contains("<")) {
      return 10;
    } else if (str.contains(">")) {
      return 10000;
    } else if (str == "Not Working") {
      return 0;
    } else {
      return int.parse(str);
    }
  }

  searchFromID(String id) {
    allUsers.forEach((element) {
      if (!(element.srId == id)) {
        tempList.remove(element);
      }
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchResultScreen(
              filteredUsers: tempList,
              requestStatus: widget.requestStatus,
            )));
  }

  List<UserInformation> allUsers = [];
  @override
  void didChangeDependencies() {
    final res = Provider.of<AllUser>(context);
    allUsers = [...res.allUsers];
    tempList = [...res.allUsers];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: InkWell(
          onTap: () {
            if (_controller!.index == 0) {
              if (_key.currentState!.validate()) {
                search();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchResultScreen(
                        filteredUsers: tempList,
                        requestStatus: widget.requestStatus),
                  ),
                );
              }
            } else {
              if (enteredId.length == 8)
                searchFromID(enteredId);
              else
                Fluttertoast.showToast(msg: 'Must be of 8 characters');
            }
          },
          child: Container(
            height: height * .071,
            alignment: Alignment.center,
            color: theme.colorPrimary,
            child: Text(
              'Search Now',
              style: GoogleFonts.openSans(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text('Search'),
          backgroundColor: theme.colorCompanion,
          bottom: TabBar(
            indicatorColor: theme.colorPrimary,
            controller: _controller,
            tabs: [
              Tab(
                child: Text(
                  'Search Options',
                  style: GoogleFonts.ptSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                text: 'Profile ID Search',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .015,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: width,
                      child: Text(
                        'Age : ',
                        style: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            minAgeSlider.toStringAsFixed(0) +
                                " to " +
                                maxAgeSlider.toStringAsFixed(0) + " Years",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),

                          RangeSlider(
                            divisions: 62,
                            values: RangeValues(minAgeSlider, maxAgeSlider),
                            labels: RangeLabels(minAgeSlider.toStringAsFixed(0).toString(), maxAgeSlider.toStringAsFixed(0).toString()),
                            activeColor: theme.colorPrimary,
                            inactiveColor: Colors.grey,
                            onChanged: (value) {
                              setState(() {
                                minAgeSlider = value.start;
                                maxAgeSlider = value.end;
                                minAge = minAgeSlider.toStringAsFixed(0);
                                maxAge = maxAgeSlider.toStringAsFixed(0);
                              });
                            },
                            min: 18.0,
                            max: 80.0,
                          ),
                        ],
                      ),
                    ),

                    /*Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text(
                            'Min',
                            style: GoogleFonts.ptSans(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: width * .05,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            height: height * .06,
                            width: width * .25,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField(
                              value: minAge,
                              validator: (val) {
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              hint: Text('Select'),
                              items: Constants.ageList.map((e) {
                                return DropdownMenuItem(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (value) {
                                minAge = value ?? "";
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            ),
                          ),
                          SizedBox(
                            width: width * .15,
                          ),
                          Text(
                            'Max',
                            style: GoogleFonts.ptSans(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: width * .05,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            height: height * .06,
                            width: width * .25,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField(
                              value: maxAge,
                              validator: (val) {
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              hint: Text('Select'),
                              items: Constants.ageList.map((e) {
                                return DropdownMenuItem(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (value) {
                                maxAge = value ?? "";
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),*/
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: width,
                      child: Text(
                        'Height :',
                        style: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text(
                            'Min',
                            style: GoogleFonts.ptSans(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: width * .054,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            width: width * .44,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField(
                              value: minHeight,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              hint: Text('Select'),
                              items: Constants.heightList.map((e) {
                                return DropdownMenuItem(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (value) {
                                minHeight = value ?? "";
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            'Max',
                            style: GoogleFonts.ptSans(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: width * .05,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            width: width * .44,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField(
                              value: maxHeight,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              hint: Text('Select'),
                              items: Constants.heightList.map((e) {
                                return DropdownMenuItem(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (value) {
                                maxHeight = value ?? "";
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .03,
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Text(
                        'Marital Status',
                        style: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Marital Status',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Open for all',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              CupertinoSwitch(
                                value: maritalStatusForAll,
                                onChanged: (val) {
                                  setState(() {
                                    maritalStatusForAll = val;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    !maritalStatusForAll
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
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
                            child: MultiSelectDialogField(
                              initialValue: selectedMaritalStatusList,
                              selectedItemsTextStyle:
                                  GoogleFonts.workSans(color: Colors.white),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              items: Constants.maritalStatusList
                                  .map((e) => MultiSelectItem(e, e))
                                  .toList(),
                              title: Text("Select Marital Status"),
                              selectedColor: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                border: Border.all(
                                  color: theme.colorGrey,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.map,
                                color: theme.colorCompanion,
                              ),
                              buttonText: Text(
                                "Select Marital Status",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (results) {
                                selectedMaritalStatusList = results;
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: width,
                      child: Text(
                        'Religion',
                        style: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Religion',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Open for all',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              CupertinoSwitch(
                                value: religionForAll,
                                onChanged: (val) {
                                  setState(() {
                                    religionForAll = val;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    !religionForAll
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
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
                            child: MultiSelectDialogField(
                              initialValue: selectedreligionList,
                              selectedItemsTextStyle:
                                  GoogleFonts.workSans(color: Colors.white),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              items: Constants.religionList
                                  .map((e) => MultiSelectItem(e, e))
                                  .toList(),
                              title: Text("Select Religion"),
                              selectedColor: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                border: Border.all(
                                  color: theme.colorGrey,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.map,
                                color: theme.colorCompanion,
                              ),
                              buttonText: Text(
                                "Select Religion",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (results) {
                                selectedreligionList = results;
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: width,
                      child: Text(
                        'Manglik',
                        style: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Manglik',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Open for all',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              CupertinoSwitch(
                                value: manglikForAll,
                                onChanged: (val) {
                                  setState(() {
                                    manglikForAll = val;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    !manglikForAll
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
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
                            child: MultiSelectDialogField(
                              initialValue: selectedManglikList,
                              selectedItemsTextStyle:
                                  GoogleFonts.workSans(color: Colors.white),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              items: Constants.manglikList
                                  .map((e) => MultiSelectItem(e, e))
                                  .toList(),
                              title: Text("Select Manglik"),
                              selectedColor: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                border: Border.all(
                                  color: theme.colorGrey,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.map,
                                color: theme.colorCompanion,
                              ),
                              buttonText: Text(
                                "Select Manglik",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (results) {
                                selectedManglikList = results;
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: width,
                      child: Text(
                        'Mother Tongue',
                        style: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mother Tongue',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Open for all',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              CupertinoSwitch(
                                value: motherTongueForAll,
                                onChanged: (val) {
                                  setState(() {
                                    motherTongueForAll = val;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    !motherTongueForAll
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
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
                            child: MultiSelectDialogField(
                              initialValue: selectedmotherToungueList,
                              selectedItemsTextStyle:
                                  GoogleFonts.workSans(color: Colors.white),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              items: Constants.motherTongueList
                                  .map((e) => MultiSelectItem(e, e))
                                  .toList(),
                              title: Text("Select Mother Tongue"),
                              selectedColor: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                border: Border.all(
                                  color: theme.colorGrey,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.map,
                                color: theme.colorCompanion,
                              ),
                              buttonText: Text(
                                "Select Mother Tongue",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (results) {
                                selectedmotherToungueList = results;
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: height * .02,
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Text(
                        'Location Details',
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                          color: theme.colorPrimary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Open for all',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              CupertinoSwitch(
                                  value: isLocationForAll,
                                  onChanged: (val) {
                                    setState(() {
                                      isLocationForAll = val;
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    !isLocationForAll
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
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
                            child: MultiSelectDialogField(
                              initialValue: selectedLocationList,
                              selectedItemsTextStyle:
                                  GoogleFonts.workSans(color: Colors.white),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              items: Constants.statesList
                                  .map((e) => MultiSelectItem(e, e))
                                  .toList(),
                              title: Text("Select States"),
                              selectedColor: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                border: Border.all(
                                  color: theme.colorGrey,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.school,
                                color: theme.colorCompanion,
                              ),
                              buttonText: Text(
                                "Choose States",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (results) {
                                selectedLocationList = results;
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: height * .02,
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Text(
                        'Education & Career',
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                          color: theme.colorPrimary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Qualification',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Open for all',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              CupertinoSwitch(
                                  value: isQualificationForAll,
                                  onChanged: (val) {
                                    setState(() {
                                      isQualificationForAll = val;
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    !isQualificationForAll
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
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
                            child: MultiSelectDialogField(
                              initialValue: selectedQualificationList,
                              selectedItemsTextStyle:
                                  GoogleFonts.workSans(color: Colors.white),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              items: Constants.qualificationList
                                  .map((e) => MultiSelectItem(e, e))
                                  .toList(),
                              title: Text("Select qualification"),
                              selectedColor: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                border: Border.all(
                                  color: theme.colorGrey,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.school,
                                color: theme.colorCompanion,
                              ),
                              buttonText: Text(
                                "Qualification",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (results) {
                                selectedQualificationList = results;
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: width,
                      child: Text(
                        'Working with',
                        style: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Designation',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Open for all',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              CupertinoSwitch(
                                  value: isDesignationForAll,
                                  onChanged: (val) {
                                    setState(() {
                                      isDesignationForAll = val;
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    !isDesignationForAll
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
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
                            child: MultiSelectDialogField(
                              initialValue: selectedDesignation,
                              selectedItemsTextStyle:
                                  GoogleFonts.workSans(color: Colors.white),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              items: Constants.designationList
                                  .map((e) => MultiSelectItem(e, e))
                                  .toList(),
                              title: Text("Select designation"),
                              selectedColor: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                border: Border.all(
                                  color: theme.colorGrey,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.work,
                                color: theme.colorCompanion,
                              ),
                              buttonText: Text(
                                "Designation",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (results) {
                                selectedDesignation = results;
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Employed In',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Open for all',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              CupertinoSwitch(
                                value: employedInForAll,
                                onChanged: (val) {
                                  setState(() {
                                    employedInForAll = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    !employedInForAll
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
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
                            child: MultiSelectDialogField(
                              initialValue: selectedEmployedInList,
                              selectedItemsTextStyle:
                                  GoogleFonts.workSans(color: Colors.white),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              items: Constants.employedInList
                                  .map((e) => MultiSelectItem(e, e))
                                  .toList(),
                              title: Text("Select Employed In"),
                              selectedColor: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                border: Border.all(
                                  color: theme.colorGrey,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.work,
                                color: theme.colorCompanion,
                              ),
                              buttonText: Text(
                                "Employed In",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (results) {
                                selectedEmployedInList = results;
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: height * .01,
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: width,
                      child: Text(
                        'Annual Income',
                        style: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text(
                            'Min',
                            style: GoogleFonts.ptSans(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: width * .02,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            height: height * .06,
                            width: width * .33,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField(
                              value: minIncome,
                              validator: (val) {
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
                                minIncome = value ?? "";
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            ),
                          ),
                          SizedBox(
                            width: width * .04,
                          ),
                          Text(
                            'Max',
                            style: GoogleFonts.ptSans(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: width * .02,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            height: height * .06,
                            width: width * .33,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField(
                              value: maxIncome,
                              validator: (val) {
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
                                maxIncome = value ?? "";
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .03,
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Text(
                        'Other Details',
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                          color: theme.colorPrimary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: width,
                      child: Text(
                        'Diet',
                        style: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Diet',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Open for all',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              CupertinoSwitch(
                                  value: isDietForAll,
                                  onChanged: (val) {
                                    setState(() {
                                      isDietForAll = val;
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    !isDietForAll
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
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
                            child: MultiSelectDialogField(
                              initialValue: selectedDietList,
                              selectedItemsTextStyle:
                                  GoogleFonts.workSans(color: Colors.white),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              items: Constants.dietList
                                  .map((e) => MultiSelectItem(e, e))
                                  .toList(),
                              title: Text("Select Diet"),
                              selectedColor: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                border: Border.all(
                                  color: theme.colorGrey,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.food_bank_rounded,
                                color: theme.colorCompanion,
                              ),
                              buttonText: Text(
                                "Diet",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (results) {
                                selectedDietList = results;
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(height: height * .01),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: height * .1,
                ),
                Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text('Profile ID'),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: TextFormField(
                    maxLength: 8,
                    onChanged: (val) {
                      enteredId = val.toUpperCase();
                    },
                    decoration: InputDecoration(
                      hintText: 'XXXXXXX',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorCompanion,
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
          ],
        ),
      ),
    );
  }
}
