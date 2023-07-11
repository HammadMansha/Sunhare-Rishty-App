import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimonial_app/Screens/HomeScreen.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import '/Providers/getUserInfo.dart';
import '/models/parternerInfoModel.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import '/main.dart';

class PartnerPreferenceScreen extends StatefulWidget {
  final PartnerInfo partnerInfo;
  bool? fromOtpScreen;
  PartnerPreferenceScreen({required this.partnerInfo,this.fromOtpScreen});
  @override
  _PartnerPreferenceScreenState createState() =>
      _PartnerPreferenceScreenState();
}

class _PartnerPreferenceScreenState extends State<PartnerPreferenceScreen> {
  bool ispublished = false;

  String maritalStatus = "";
  var selectedDiet;
  var selectedcountry;
  var selectedprofile;
  var selectedreligion;
  var selectedCommunity;

  bool isQualificationForAll = true;
  bool isDesignationForAll = true;
  bool isDietForAll = true;
  List selectedDesignation = [];
  List selectedDietList = [];
  List selectedQualificationList = [];
  bool isLocationForAll = true;
  List selectedLocationList = [];
  bool maritalStatusForAll = false;
  List selectedMaritalStatusList = [];
  List selectedreligionList = [];
  List selectedmotherToungueList = [];
  List selectedManglikList = [];
  List selectedEmployedInList = [];

  bool religionForAll = true;
  bool manglikForAll = true;
  bool motherTongueForAll = true;
  bool employedInForAll = true;

  String cityValue = "";
  String countryValue = "";
  String stateValue = "";
  String minAge = "18";
  String maxAge = "80";
  String minHeight = "4' 5\" - 134 cm";
  String maxHeight = "7' 0\" - 213 cm";
  String motherToung = "Hindi";
  String qualification = "Ph.D.";
  String workingWith = "";
  String designation = "Accounts / Finance Professional";
  String minIncome = "Not Working";
  String maxIncome = "> 30 lakhs";

  final _key = GlobalKey<FormState>();
  final minAgeKey = GlobalKey<FormFieldState>();
  final maxAgeKey = GlobalKey<FormFieldState>();
  final minHeightKey = GlobalKey<FormFieldState>();
  final maxHeightKey = GlobalKey<FormFieldState>();
  final minAnnualKey = GlobalKey<FormFieldState>();
  final maxAnnualKey = GlobalKey<FormFieldState>();

  bool isLoading = false;
  UserInformation curreUser = UserInformation();

  double minAgeSlider = 18.0;
  double maxAgeSlider = 80.0;


  double minHeightSlider = 4.5;
  double maxHeightSlider = 7.0;
  String tempMinHeightSlider = "4'5\"";
  String tempMaxHeightSlider = "7'0\"";

  @override
  void initState() {
    curreUser = Provider.of<CurrUserInfo>(context, listen: false).currentUser;

    cityValue = widget.partnerInfo.city ?? "";
    countryValue = widget.partnerInfo.country ?? "";
    stateValue = widget.partnerInfo.state ?? "";
    minAge = widget.partnerInfo.minAge ?? "18";
    maxAge = widget.partnerInfo.maxAge ?? "80";

    minAgeSlider = double.parse(minAge);
    maxAgeSlider = double.parse(maxAge);

    minHeight = widget.partnerInfo.minHeight ?? "4' 5\" - 134 cm";
    maxHeight = widget.partnerInfo.maxHeight ?? "7' 0\" - 213 cm";


    motherToung = widget.partnerInfo.motherTong ?? "";
    qualification = widget.partnerInfo.qualification ?? "";
    designation = widget.partnerInfo.workingAs ?? "";
    minIncome = widget.partnerInfo.minIncome ?? "Not Working";
    maxIncome = widget.partnerInfo.maxIncome ?? "> 30 lakhs";
    selectedreligion = widget.partnerInfo.religion;
    selectedManglikList = widget.partnerInfo.selectedManglikList ?? [];
    selectedDiet = widget.partnerInfo.diet;
    // maritalStatus = widget.partnerInfo.maritalStatus ?? curreUser.maritalStatus ?? "";
    maritalStatus = curreUser.maritalStatus ?? "";
    print("maritalStatus is====>>>$maritalStatus");
    print("maritalStatus is====>>>${widget.partnerInfo.maritalStatus}");
    print("maritalStatus is====>>>${curreUser.maritalStatus}");
    selectedCommunity = widget.partnerInfo.community;
    selectedDesignation = widget.partnerInfo.selectedDesignation ?? [];
    selectedDietList = widget.partnerInfo.selectedDietList ?? [];
    selectedQualificationList = widget.partnerInfo.selectedQualificationList ?? [];
    isQualificationForAll = widget.partnerInfo.qualificationOpenForAll ?? true;
    isDietForAll = widget.partnerInfo.dietForAll ?? true;
    isDesignationForAll = widget.partnerInfo.designationOpenForAll ?? true;
    isLocationForAll = widget.partnerInfo.locationForAll ?? true;
    selectedLocationList = widget.partnerInfo.selectedLocationList ?? [];
    workingWith = widget.partnerInfo.workingWith ?? "";
    maritalStatusForAll = widget.partnerInfo.maritalStatusForAll ?? false;
    employedInForAll = widget.partnerInfo.employedInForAll ?? true;
    religionForAll = widget.partnerInfo.religionForAll ?? true;
    motherTongueForAll = widget.partnerInfo.motherToungueForAll ?? true;
    manglikForAll = widget.partnerInfo.manglikForAll ?? true;
    selectedEmployedInList = widget.partnerInfo.selectedEmployedInList ?? [];
    if(maritalStatus == "Never Married"){
      selectedMaritalStatusList = ["Never Married"];
    }else{
      selectedMaritalStatusList = ['Divorced','Widowed','Awaiting Divorce','Annulled','Open to all'];
    }
    // selectedMaritalStatusList = widget.partnerInfo.selectedMaritalStatusList ?? [];
    print("selectedMaritalStatusList===>>>$selectedMaritalStatusList");
    selectedmotherToungueList = widget.partnerInfo.selectedMotherToungueList ?? [];
    selectedreligionList = widget.partnerInfo.selectedReligionList ?? [];
    setState(() {});
    super.initState();
  }

  void onTapClearAll() {
    setState(() {
      isQualificationForAll = true;
      isDesignationForAll = true;
      isDietForAll = true;
      selectedDesignation = [];
      selectedDietList = [];
      selectedQualificationList = [];
      isLocationForAll = true;
      selectedLocationList = [];
      selectedreligionList = [];
      selectedmotherToungueList = [];
      selectedManglikList = [];
      selectedEmployedInList = [];
      religionForAll = true;
      manglikForAll = true;
      selectedMaritalStatusList = [];
      maritalStatusForAll = curreUser.maritalStatus != "Never Married";
      if (!maritalStatusForAll) {
        selectedMaritalStatusList = ["Never Married"];
      }
      motherTongueForAll = true;
      employedInForAll = true;
      minAgeKey.currentState!.reset();
      maxAgeKey.currentState!.reset();
      minHeightKey.currentState!.reset();
      maxHeightKey.currentState!.reset();
      minAnnualKey.currentState!.reset();
      maxAnnualKey.currentState!.reset();
      minAge = "";
      maxAge = "";
      minHeight = "";
      maxHeight = "";
      minIncome = "";
      maxIncome = "";

      minAge = "18";
      maxAge = "80";
      minHeight = "4' 5\" - 134 cm";
      maxHeight = "7' 0\" - 213 cm";
      motherToung = "Hindi";
      qualification = "Ph.D.";
      workingWith = "";
      designation = "Accounts / Finance Professional";
      minIncome = "Not Working";
      maxIncome = "> 30 lakhs";

    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  print(minAge);
                  String id = FirebaseAuth.instance.currentUser!.uid;
                  FirebaseDatabase.instance
                      .reference()
                      .child('Partner Prefrence')
                      .child(id)
                      .update({
                    'minAge': minAge,
                    'maxAge': maxAge,
                    'minHeight': minHeight,
                    'maxHeight': maxHeight,
                    'maritalStatus': maritalStatus,
                    'religion': selectedreligion,
                    'community': selectedCommunity,
                    'motherTounge': motherToung,
                    'city': cityValue,
                    'country': countryValue,
                    'state': stateValue,
                    'qualification': qualification,
                    'workingWith': workingWith,
                    'designation': designation,
                    'minIncome': minIncome,
                    'maxIncome': maxIncome,
                    'diet': selectedDiet,
                    'designationList': selectedDesignation,
                    'dietList': selectedDietList,
                    'qualificationList': selectedQualificationList,
                    'selectedManglikList': selectedManglikList,
                    'desigForAll': isDesignationForAll,
                    'dietForAll': isDietForAll,
                    'qualificationForAll': isQualificationForAll,
                    'employedInForAll': employedInForAll,
                    'emplyedInList': selectedEmployedInList,
                    'locationForAll': isLocationForAll,
                    'locationList': selectedLocationList,
                    'religionForAll': religionForAll,
                    'manglikForAll': manglikForAll,
                    'motherToungeForAll': motherTongueForAll,
                    'maritalStatusForAll': maritalStatusForAll,
                    'maritalStatusList': selectedMaritalStatusList,
                    'religionList': selectedreligionList,
                    'motherToungueList': selectedmotherToungueList
                  }).then((value) {
                    setState(() {
                      Provider.of<CurrUserInfo>(context, listen: false)
                          .updatePartnerInfo(PartnerInfo(
                              designationOpenForAll: isDesignationForAll,
                              dietForAll: isDietForAll,
                              qualificationOpenForAll: isQualificationForAll,
                              minAge: minAge,
                              city: cityValue,
                              maxAge: maxAge,
                              minHeight: minHeight,
                              maritalStatus: maritalStatus,
                              maxHeight: maxHeight,
                              religion: selectedreligion,
                              community: selectedCommunity,
                              motherTong: motherToung,
                              country: countryValue,
                              state: stateValue,
                              diet: selectedDiet,
                              maxIncome: maxIncome,
                              minIncome: minIncome,
                              employedInForAll: employedInForAll,
                              selectedEmployedInList: selectedEmployedInList,
                              qualification: qualification,
                              workingWith: workingWith,
                              selectedDesignation: selectedDesignation,
                              selectedDietList: selectedDietList,
                              selectedQualificationList:
                                  selectedQualificationList,
                              locationForAll: isLocationForAll,
                              selectedLocationList: selectedLocationList,
                              selectedManglikList: selectedManglikList,
                              maritalStatusForAll: maritalStatusForAll,
                              manglikForAll: manglikForAll,
                              motherToungueForAll: motherTongueForAll,
                              religionForAll: religionForAll,
                              selectedMaritalStatusList:
                                  selectedMaritalStatusList,
                              selectedMotherToungueList:
                                  selectedmotherToungueList,
                              selectedReligionList: selectedreligionList,
                              workingAs: designation));
                      if(widget.fromOtpScreen == true){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(isRedirectingFromLogin: false),
                          ),
                        );
                      }else{
                        Navigator.of(context).pop(true);
                      }
                      isLoading = false;
                    });
                  });
                },
                child: Container(
                  height: height * .071,
                  alignment: Alignment.center,
                  color: theme.colorCompanion,
                  child: isLoading
                      ? SpinKitThreeBounce(
                          size: 20,
                          color: Colors.white,
                        )
                      : Text(
                          'SAVE & CONTINUE',
                          style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: InkWell(
            //     onTap: () => {onTapClearAll()},
            //     child: Container(
            //       height: height * .071,
            //       alignment: Alignment.center,
            //       color: Colors.grey[400],
            //       child: Text(
            //         'CLEAR ALL',
            //         style: GoogleFonts.openSans(
            //           fontSize: 18,
            //           color: Colors.black,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          backgroundColor: theme.colorCompanion,
          title: Text(
            'Partner Preferences',
            style: GoogleFonts.lato(),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height * .075,
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: Text(
                    'Tell us what you are looking for in a life partner',
                    style: GoogleFonts.openSans(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: height * .025,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  width: width,
                  child: Text(
                    'Age :',
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


                /*Container(
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
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tempMinHeightSlider+
                            " to " +
                            tempMaxHeightSlider,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),

                      RangeSlider(
                        divisions: 100,
                        values: RangeValues(minHeightSlider, maxHeightSlider),
                        labels: RangeLabels(tempMinHeightSlider, tempMaxHeightSlider),
                        activeColor: theme.colorPrimary,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          setState(() {

                            String tempA = value.start.toString().split(".")[0];
                            String tempB = value.start.toString().split(".")[1];
                            double tempC = ((12*int.parse(tempB[0]))/10);
                            String tempD = tempA +"'"+ tempC.ceil().toString() + '"';
                            debugPrint("minHeightSliderValue ==>    ${value.start.toStringAsFixed(2).toString()}   ${tempD}");
                            tempMinHeightSlider = tempD;
                            minHeightSlider = value.start;


                            String tempP = value.end.toString().split(".")[0];
                            String tempQ = value.end.toString().split(".")[1];
                            double tempR = ((12*int.parse(tempQ[0]))/10);
                            String tempS = tempP +"'"+ tempR.ceil().toString() + '"';
                            debugPrint("maxHeightSliderValue ==>    ${value.end.toStringAsFixed(2).toString()}   ${tempS}");
                            tempMaxHeightSlider = tempS;
                            maxHeightSlider = value.end;

                            //minHeightSlider = value.start;
                            //maxHeightSlider = value.end;
                          });
                        },
                        min: 4.5,
                        max: 7.0,
                      ),
                    ],
                  ),
                ),*/



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
                        width: width * .25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField(
                          key: minAgeKey,
                          value: minAge,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Select'),
                          items: Constants.ageList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            minAge = value ?? "";
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * .1,
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
                        width: width * .25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField(
                          key: maxAgeKey,
                          value: maxAge,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Select'),
                          items: Constants.ageList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            maxAge = value ?? "";
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
                        // height: height * .06,
                        width: width * .44,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField(
                          key: minHeightKey,
                          value: minHeight,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Select'),
                          items: Constants.heightList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            minHeight = value ?? "";
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
                          key: maxHeightKey,
                          value: maxHeight,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Select'),
                          items: Constants.heightList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
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
                  height: height * .02,
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
                  height: height * .02,
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
                  height: height * .01,
                ),
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    'Location Details',
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
                            Icons.map,
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
                  height: height * .01,
                ),
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    'Education & Career',
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
                            "Choose Qualification",
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
                        width: width * .35,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField(
                          value: minIncome,
                          key: minAnnualKey,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Select'),
                          items: Constants.incomeList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            minIncome = value ?? "";
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * .02,
                      ),
                      Text(
                        'Max',
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: width * .01),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        width: width * .35,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField(
                          value: maxIncome,
                          key: maxAnnualKey,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text('Select'),
                          items: Constants.incomeList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
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
                  height: height * .01,
                ),
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    'Other Details',
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
                            log(selectedDietList.toString());
                          },
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: height * .04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
