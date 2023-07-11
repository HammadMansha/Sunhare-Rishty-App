import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrimonial_app/customs/Constants.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '/Providers/getUserInfo.dart';
import '/models/UserModel.dart';
import 'package:provider/provider.dart';
import '/main.dart';

class EditSection extends StatefulWidget {
  final UserInformation userInfo;
  EditSection({required this.userInfo});
  @override
  _EditSectionState createState() => _EditSectionState();
}

class _EditSectionState extends State<EditSection> {
  String intro = '';
  String intro2 = '';
  int introEditedStatus = 0;

  bool _basicInfo = true;
  bool _bio = true;
  bool _religious = true;
  bool _family = true;
  bool _astro = true;
  bool _location = true;
  bool _lifestyle = true;
  bool _hobies = true;
  bool isLoading = false;

  var selectedDiet;
  var selectedcountry;
  var selectedprofile;
  var selectedreligion;
  var selectedCommunity;

  String maritalStatus = "";
  String heightPerson = "";
  String disability = "";
  String subCommodity = "";
  String motherTongue = "";
  String goutra = "";
  String fatherName = "";
  String fatherStatus = "";
  String motherName = "";
  String motherStatus = "";
  String familyCity = "";
  String noOfBrothers = "";
  String noOfSisters = "";
  String marriedBrothers = "";
  String marriedSisters = "";

  String familyType = "";
  String nativeCity = "";
  String cityOfBirth = "";
  String manglik = "";
  String state = "";
  String city = "";
  String zipCode = "";
  String highestQualification = "Ph.D.";
  String clgAttended = "";
  String workWith = "";
  String employedIn = "";
  String designation = "";
  String annualIncome = "";
  bool allowMarketing = false;

  String motherGotra = "";
  String fathergotra = "";
  String healthInfo = "";
  String bloodGroup = "";
  String selectedFamilyValue = "";
  String selectedAfflenceValue = "";
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay? timeOfBirth;
  bool showHoroscope = false;

  List selectedHobbies = [];
  List selectedIntrested = [];
  List selectedMustic = [];
  List selectedSports = [];
  List selectedFavCousine = [];
  List selectedDressStyle = [];

  String selectedHour = "01", selectedMinute = "01", selectedAmPm = "AM";

  String selectedDay = "", selectedMonth = "", selectedYear = "";

  List<String> maleYearList = [];

  String livingTogetherStatus = "Yes. Living together";
  String childrenStatus = "1";

  getMaleList() {
    maleYearList.clear();
    DateTime endYear = DateTime.now().subtract(Duration(days: 7300));
    DateTime startYear = DateTime.now().subtract(Duration(days: 24824));
    for (int x = startYear.year; x < endYear.year; x++) {
      maleYearList.add(x.toString());
    }
  }

  getHobbies() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('Hobbies')
        .onValue
        .listen((event) {
      final snapShot = event.snapshot.value as List;
      if (snapShot != null) selectedHobbies = snapShot;
      setState(() {});
    });
  }

  getIntrests() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('Intrests')
        .onValue
        .listen((event) {
      final snapShot = event.snapshot.value as List;
      if (snapShot != null) selectedIntrested = snapShot;
      setState(() {});
    });
  }

  getFavMusic() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('music')
        .onValue
        .listen((event) {
      final snapShot = event.snapshot.value as List;
      if (snapShot != null) selectedMustic = snapShot;
      setState(() {});
    });
  }

  getSportsFitness() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('Fitness')
        .onValue
        .listen((event) {
      final snapShot = event.snapshot.value as List;
      if (snapShot != null) selectedSports = snapShot;
      setState(() {});
    });
  }

  getFavCousine() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('Cousine')
        .onValue
        .listen((event) {
      final snapShot = event.snapshot.value as List;
      if (snapShot != null) selectedFavCousine = snapShot;
      setState(() {});
    });
  }

  getDressStyle() {
    FirebaseDatabase.instance
        .reference()
        .child('HobiesAndMore')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('dressStyle')
        .onValue
        .listen((event) {
      final snapShot = event.snapshot.value as List;
      if (snapShot != null) selectedDressStyle = snapShot;
      setState(() {});
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedS = await showTimePicker(
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

  @override
  void initState() {
    getMaleList();
    maritalStatus = widget.userInfo.maritalStatus ?? "";

    childrenStatus = widget.userInfo.noOfChildren ?? "1";
    livingTogetherStatus = widget.userInfo.childrenLivingTogether ?? "Yes. Living together";

    if(childrenStatus == ""){
      childrenStatus = "1";
    }
    if(livingTogetherStatus == ""){
      livingTogetherStatus = "Yes. Living together";
    }

    heightPerson = widget.userInfo.height ?? "";
    disability = widget.userInfo.anyDisAbility ?? "";
    intro = widget.userInfo.intro ?? "";
    introEditedStatus = widget.userInfo.introEdited ?? 0;
    if(introEditedStatus == 1 || introEditedStatus == 2){
      intro = widget.userInfo.newIntro ?? "";
    }

    selectedreligion = widget.userInfo.religion;
    selectedCommunity = widget.userInfo.community;
    goutra = widget.userInfo.gotra ?? "";

    fatherStatus = widget.userInfo.fatherStatus ?? "";
    motherTongue = widget.userInfo.motherTongue ?? "";
    motherStatus = widget.userInfo.motherStatus ?? "";
    nativeCity = widget.userInfo.nativePlace ?? "";
    noOfBrothers = widget.userInfo.brothers ?? "";
    noOfSisters = widget.userInfo.sisters ?? "";
    familyCity = widget.userInfo.residencyStatus ?? "";
    familyType = widget.userInfo.familyType ?? "";

    cityOfBirth = widget.userInfo.cityOfBirth ?? "";
    manglik = widget.userInfo.manglik ?? "";

    state = widget.userInfo.state ?? "";
    city = widget.userInfo.city ?? "";
    zipCode = widget.userInfo.zipCode ?? "";
    highestQualification = widget.userInfo.highestQualification ?? "Ph.D.";

    if(highestQualification == ""){
      highestQualification = "Ph.D.";
    }
    if(highestQualification == "Other"){
      highestQualification = "Others";
    }
    debugPrint("highestQualification ==> ${highestQualification}");

    clgAttended = widget.userInfo.collegeAttended ?? "";
    workWith = widget.userInfo.workingWith ?? "";
    employedIn = widget.userInfo.employedIn ?? "";
    designation = widget.userInfo.workingAs ?? "";
    annualIncome = widget.userInfo.annualIncome ?? "";
    selectedcountry = widget.userInfo.country;
    motherGotra = widget.userInfo.motherGautra ?? "";
    fathergotra = widget.userInfo.fatherGautra ??"";
    familyCity = widget.userInfo.residencyStatus ??'';

    selectedDiet = widget.userInfo.diet;
    selectedprofile = widget.userInfo.postedBy;

    marriedBrothers = widget.userInfo.marriedBrothers ??"";
    marriedSisters = widget.userInfo.marriedSisters ??"";

    healthInfo = widget.userInfo.healthInfo ??"";
    bloodGroup = widget.userInfo.bloodGroup ??"";
    fatherName = widget.userInfo.fatherName ??"";
    motherName = widget.userInfo.motherName ??"";
    selectedFamilyValue = widget.userInfo.familyValues ?? "";
    if(selectedFamilyValue == ""){
      selectedFamilyValue = "Traditional";
    }
    selectedAfflenceValue = widget.userInfo.affluenceLevel ?? "";
    if(selectedAfflenceValue == ""){
      selectedAfflenceValue = "Affluent";
    }


    timeOfBirth = widget.userInfo.birthTime ?? TimeOfDay.now();

    var dateFormat = DateFormat("h");
    var dateFormat2 = DateFormat("mm");

    String tempHoures = timeOfBirth!.hour.toString().length.isOdd? "0${timeOfBirth!.hour.toString()}" : timeOfBirth!.hour.toString();
    String tempMinutes = timeOfBirth!.minute.toString().length.isOdd? "0${timeOfBirth!.minute.toString()}" : timeOfBirth!.minute.toString();

    var utcDate = dateFormat.format(DateTime.parse('2000-12-31 ${tempHoures}:${tempMinutes}:00'));
    var utcDate1 = dateFormat2.format(DateTime.parse('2000-12-31 ${tempHoures}:${tempMinutes}:00'));

    selectedHour = utcDate.length.isOdd? "0${utcDate}" : utcDate;
    selectedMinute = utcDate1.length.isOdd? "0${utcDate1}" : utcDate1;

    selectedAmPm = timeOfBirth!.period.toString().toUpperCase().split('.').last;

    showHoroscope = widget.userInfo.showHoroscope ?? false;

    allowMarketing = widget.userInfo.allowMarketing ?? true;

    selectedDay = widget.userInfo.dateOfBirth!.split("/")[0];
    selectedMonth = widget.userInfo.dateOfBirth!.split("/")[1];
    selectedYear = widget.userInfo.dateOfBirth!.split("/")[2];

    print("~~~~~~~~~~~~~~~~ ${fatherStatus}");

    getHobbies();
    getIntrests();
    getFavMusic();
    getSportsFitness();
    getFavCousine();
    getDressStyle();

    setState(() {});

    super.initState();
  }

  TextEditingController commController = TextEditingController();
  int? commVal = 0;
  int? stateVal = 0;
  int? cityVal = 0;
  String? selectedCommunityFinal = "";

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [],
          backgroundColor: theme.colorCompanion,
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            selectedCommunity = selectedCommunityFinal;

            TimeOfDay tempTimeOfDay;
            String birthDimedateTime;
            if(selectedAmPm == "PM"){
              birthDimedateTime = "TimeOfDay(${(int.parse(selectedHour)+12).toString()}:${selectedMinute})";
              tempTimeOfDay = TimeOfDay(hour:int.parse(selectedHour)+12,minute: int.parse(selectedMinute));
            }else{
              birthDimedateTime = "TimeOfDay(${int.parse(selectedHour).toString()}:${selectedMinute})";
              tempTimeOfDay = TimeOfDay(hour:int.parse(selectedHour),minute: int.parse(selectedMinute));
            }


            final String id = FirebaseAuth.instance.currentUser!.uid;
            setState(() {
              isLoading = true;
            });
            if (noOfBrothers == "" || noOfBrothers == null) noOfBrothers = "0";
            if (noOfSisters == "" || noOfSisters == null) noOfSisters = "0";
            if (marriedBrothers == "" || marriedBrothers == null)
              marriedBrothers = "0";
            if (marriedSisters == "" || marriedSisters == null)
              marriedSisters = "0";


            String tempChildren = maritalStatus == "Never Married" ? "" :  childrenStatus;
            String tempLivingTog = maritalStatus == "Never Married" ? "" :  livingTogetherStatus;

            FirebaseDatabase.instance
                .reference()
                .child('User Information')
                .child(id)
                .update({
              'maritalStatus': maritalStatus,
              'noOfChildren':tempChildren,
              'childrenLivingTogether':tempLivingTog,
              'personHeight': heightPerson,
              'disability': disability,
              //'intro': intro,
              'Community': selectedCommunity,
              'motherTongue': motherTongue,
              'gautra': goutra,
              'FatherStatus': fatherStatus,
              'MotherStatus': motherStatus,
              'residency': familyCity,
              'nativePlace': nativeCity,
              'familyType': familyType,
              'cityOfBirth': cityOfBirth,
              'maglik': manglik,
              'state': state,
              'city': city,
              'living': selectedcountry,
              'zipCode': zipCode,
              'qualification': highestQualification,
              'clg': clgAttended,
              'workAt': workWith,
              'employedIn': employedIn,
              'designation': designation,
              'annualIncome': annualIncome,
              'diet': selectedDiet,
              'Religion': selectedreligion,
              'fatherGotra': fathergotra,
              'motherGotra': motherGotra,
              'marriedBrothers': marriedBrothers,
              'marriedSisters': marriedSisters,
              'brotherCount': noOfBrothers,
              'sisterCount': noOfSisters,
              'ProfileFor': selectedprofile,
              'bloodGroup': bloodGroup,
              'healthInfo': healthInfo,
              'afluenceValue': selectedAfflenceValue,
              'familyValue': selectedFamilyValue,
              'fatherName': fatherName,
              'motherName': motherName,
              'DateOfBirth': selectedDay +
                  '/' +
                  selectedMonth +
                  '/' +
                  selectedYear.toString(),
              'allowMarketing': allowMarketing,
              'timeOfBirth': birthDimedateTime,
              //'timeOfBirth': timeOfBirth.toString(),
              'showHoroscope': showHoroscope
            }).then((value) {

              if(intro2 != ""){
                FirebaseDatabase.instance
                    .reference()
                    .child('User Information')
                    .child(FirebaseAuth.instance.currentUser!.uid)
                    .update({'newIntro': intro2,'introEdited': 1});
              }

              FirebaseDatabase.instance
                  .reference()
                  .child('HobiesAndMore')
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .update({"Hobbies": selectedHobbies});

              FirebaseDatabase.instance
                  .reference()
                  .child('HobiesAndMore')
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .update({"Intrests": selectedIntrested});

              FirebaseDatabase.instance
                  .reference()
                  .child('HobiesAndMore')
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .update({"music": selectedMustic});

              FirebaseDatabase.instance
                  .reference()
                  .child('HobiesAndMore')
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .update({"Fitness": selectedSports});

              FirebaseDatabase.instance
                  .reference()
                  .child('HobiesAndMore')
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .update({"Cousine": selectedFavCousine});

              FirebaseDatabase.instance
                  .reference()
                  .child('HobiesAndMore')
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .update({"dressStyle": selectedDressStyle});
              Provider.of<CurrUserInfo>(context, listen: false)
                  .updateCurrentUser(UserInformation(
                      premiumModel: widget.userInfo.premiumModel,
                      srId: widget.userInfo.srId,
                      phone: widget.userInfo.phone,
                      marriedBrothers: marriedBrothers,
                      marriedSisters: marriedSisters,
                      brothers: noOfBrothers,
                      sisters: noOfSisters,
                      isPremium: widget.userInfo.isPremium,
                      visibility: widget.userInfo.visibility,
                      fatherGautra: fathergotra,
                      motherGautra: motherGotra,
                      id: widget.userInfo.id,
                      imageUrl: widget.userInfo.imageUrl,
                      name: widget.userInfo.name,
                      maritalStatus: maritalStatus,
                      noOfChildren: tempChildren,
                      childrenLivingTogether: tempLivingTog,
                      height: heightPerson,
                      anyDisAbility: disability,
                      allowMarketing: allowMarketing,
                      intro: intro,
                      newIntro: intro2 == "" ? "" : intro2,
                      introEdited: intro2 == "" ? 0 : 1,
                      religion: selectedreligion,
                      community: selectedCommunity,
                      motherTongue: motherTongue,
                      dateOfBirth: selectedDay +
                          '/' +
                          selectedMonth +
                          '/' +
                          selectedYear.toString(),
                      motherStatus: motherStatus,
                      gotra: goutra,
                      fatherStatus: fatherStatus,
                      residencyStatus: familyCity,
                      nativePlace: nativeCity,
                      familyType: familyType,
                      cityOfBirth: cityOfBirth,
                      manglik: manglik,
                      state: state,
                      city: city,
                      country: selectedcountry,
                      zipCode: zipCode,
                      highestQualification: highestQualification,
                      collegeAttended: clgAttended,
                      workingWith: workWith,
                      employedIn: employedIn,
                      workingAs: designation,
                      annualIncome: annualIncome,
                      email: widget.userInfo.email,
                      postedBy: selectedprofile,
                      gender: widget.userInfo.gender,
                      isVerified: widget.userInfo.isVerified,
                      healthInfo: healthInfo,
                      bloodGroup: bloodGroup,
                      affluenceLevel: selectedAfflenceValue,
                      familyValues: selectedFamilyValue,
                      fatherName: fatherName,
                      motherName: motherName,
                      showHoroscope: showHoroscope,
                      birthTime: tempTimeOfDay,
                      //birthTime: timeOfBirth,
                      diet: selectedDiet));
              setState(() {
                isLoading = false;
              });


              print("selectedCommunity===>>>>>$selectedCommunity");
              print("commVal===>>>>>$commVal");
              print("time of birth===>>>>>$birthDimedateTime");
              print("state===>>>>>$state");
              print("city===>>>>>$city");
              print("visibility===>>>>>${widget.userInfo.visibility}");
              print("siblings===>>>>>${marriedBrothers}+${marriedSisters}");

              if(commVal == 1){
                totalProfileCompleted = totalProfileCompleted + percentAdd;
                print("totalProfileCompleted--->>>$totalProfileCompleted");
              }else if(commVal == 2){
                totalProfileCompleted = totalProfileCompleted - percentAdd;
                print("totalProfileCompleted--->>>$totalProfileCompleted");
              }else{}

              if(stateVal == 1){
                totalProfileCompleted = totalProfileCompleted + percentAdd;
                print("totalProfileCompleted--->>>$totalProfileCompleted");
              }else if(stateVal == 2){
                totalProfileCompleted = totalProfileCompleted - percentAdd;
                print("totalProfileCompleted--->>>$totalProfileCompleted");
              }else{}

              if(cityVal == 1){
                totalProfileCompleted = totalProfileCompleted + percentAdd;
                print("totalProfileCompleted--->>>$totalProfileCompleted");
              }else if(cityVal == 2){
                totalProfileCompleted = totalProfileCompleted - percentAdd;
                print("totalProfileCompleted--->>>$totalProfileCompleted");
              }else{}





              // if(selectedCommunity != null){
              //   totalProfileCompleted = totalProfileCompleted + percentAdd;
              //   print("totalProfileCompleted--->>>$totalProfileCompleted");
              // }
              // if(birthDimedateTime.isNotEmpty){
              //   totalProfileCompleted = totalProfileCompleted + percentAdd;
              //   print("totalProfileCompleted--->>>$totalProfileCompleted");
              // }
              // if(state.isNotEmpty){
              //   totalProfileCompleted = totalProfileCompleted + percentAdd;
              //   print("totalProfileCompleted--->>>$totalProfileCompleted");
              // }
              // if(city.isNotEmpty){
              //   totalProfileCompleted = totalProfileCompleted + percentAdd;
              //   print("totalProfileCompleted--->>>$totalProfileCompleted");
              // }
              // if(widget.userInfo.visibility!.isNotEmpty){
              //   totalProfileCompleted = totalProfileCompleted + percentAdd;
              //   print("totalProfileCompleted--->>>$totalProfileCompleted");
              // }
              // if(marriedBrothers.isNotEmpty || marriedSisters.isNotEmpty){
              //   totalProfileCompleted = totalProfileCompleted + percentAdd;
              //   print("totalProfileCompleted--->>>$totalProfileCompleted");
              // }
              print(FirebaseAuth.instance.currentUser!.uid);

              FirebaseDatabase.instance
                  .reference()
                  .child('profileCompleted')
                  .child(FirebaseAuth.instance.currentUser!.uid).update({"profileCompletePercentage": totalProfileCompleted});

              Navigator.of(context).pop(true);
            });
          },
          child: Container(
            height: height * .071,
            alignment: Alignment.center,
            color: theme.colorCompanion,
            child: isLoading
                ? SpinKitThreeBounce(
                    color: Colors.white,
                    size: 25,
                  )
                : Text(
                    'UPDATE',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * .02,
                ),
                Card(
                  elevation: 6,
                  child: Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _basicInfo = !_basicInfo;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Basic Info',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorPrimary,
                                  ),
                                ),
                                Icon(
                                  _basicInfo
                                      ? MdiIcons.chevronDown
                                      : MdiIcons.chevronUp,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _basicInfo
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Profile for',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: selectedprofile,
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
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          selectedprofile = value;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .01,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        children: [
                                          Container(
                                            width: width * .53,
                                            child: TextFormField(
                                              focusNode: FocusNode(
                                                  canRequestFocus: false),
                                              enabled: false,
                                              initialValue:
                                                  widget.userInfo.gender,
                                              cursorColor: theme.colorCompanion,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    Container(
                                      child: Text(
                                        'Date Of Birth',
                                        style:
                                            GoogleFonts.openSans(fontSize: 14),
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
                                            value: selectedDay ?? "1",
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
                                              return DropdownMenuItem(
                                                  value: e, child: Text(e));
                                            }).toList(),
                                            onChanged: (value) {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              selectedDay = value ?? "";
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
                                            value: selectedMonth ?? "Jan",
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
                                              return DropdownMenuItem(
                                                  value: e, child: Text(e));
                                            }).toList(),
                                            onChanged: (value) {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              selectedMonth = value ?? "";
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
                                            value: selectedYear ?? "1999",
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
                                            items: maleYearList.map((e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: Text(
                                                  e.toString(),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              selectedYear = value ?? "";
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * .015,
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
                                      height: height * .005,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: maritalStatus,
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
                                        items: Constants.maritalStatusListNew
                                            .map((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          maritalStatus = value ?? "";
                                          setState(() {});
                                        },
                                      ),
                                    ),




                                    maritalStatus != "Never Married"
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
                                            validator: (val) {
                                              if (val == null) {
                                                return 'Required';
                                              } else
                                                return null;
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            value: livingTogetherStatus,
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


                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        Container(
                                          child: Text(
                                            'No. of Children',
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
                                              value: childrenStatus,
                                            items: Constants.childrenList.map((e) {
                                              return DropdownMenuItem(value: e, child: Text(e));
                                            }).toList(),
                                            onChanged: (value) {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              childrenStatus = value ?? "";
                                            },
                                          ),
                                        ),
                                      ],
                                    ):SizedBox(),



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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: heightPerson,
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
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          heightPerson = value ?? "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Container(
                                      child: Text(
                                        'Any Disability?',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        children: [
                                          Container(
                                            width: width * .53,
                                            child: TextFormField(
                                              focusNode: FocusNode(
                                                  canRequestFocus: false),
                                              initialValue: disability,
                                              onChanged: (val) {
                                                disability = val;
                                              },
                                              cursorColor: theme.colorCompanion,
                                              decoration: InputDecoration(
                                                  hintText: "If Any",
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Container(
                                      child: Text(
                                        'Health Information',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        children: [
                                          Container(
                                            width: width * .53,
                                            child: TextFormField(
                                              focusNode: FocusNode(
                                                  canRequestFocus: false),
                                              onChanged: (val) {
                                                healthInfo = val;
                                              },
                                              initialValue:
                                                  widget.userInfo.healthInfo,
                                              cursorColor: theme.colorCompanion,
                                              decoration: InputDecoration(
                                                enabled: true,
                                                hintText: "Health Info",
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Container(
                                      child: Text(
                                        'Blood Group',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: widget.userInfo.bloodGroup == "" ? "A+" : widget.userInfo.bloodGroup,
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
                                        items:
                                            Constants.bloodGroupList.map((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          bloodGroup = value ?? "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Card(
                  elevation: 6,
                  child: Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _bio = !_bio;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'More about Myself ',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorPrimary,
                                  ),
                                ),
                                Icon(
                                  _bio
                                      ? MdiIcons.chevronDown
                                      : MdiIcons.chevronUp,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _bio
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'About yourself',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
                                      height: height * .06 * 3,
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
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        initialValue: intro,
                                        onChanged: (val) {
                                          intro = val;
                                          intro2 = val;
                                        },
                                        cursorColor: theme.colorCompanion,
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 6,
                                        decoration: InputDecoration(
                                          hintText: "Start typing here...",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),


                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    introEditedStatus == 1?
                                    Text(
                                      "Verification Under Progress",
                                      style: GoogleFonts.ptSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ):introEditedStatus == 2?
                                    Text(
                                      "Submitted About Yourself Rejected",
                                      style: GoogleFonts.ptSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ):SizedBox(),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Card(
                  elevation: 6,
                  child: Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _religious = !_religious;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Religious Background',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorPrimary,
                                  ),
                                ),
                                Icon(
                                  _religious
                                      ? MdiIcons.chevronDown
                                      : MdiIcons.chevronUp,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _religious
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Religion',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: selectedreligion,
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
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          selectedreligion = value;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
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
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: motherTongue,
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
                                        items:
                                            Constants.motherTongueList.map((e) {
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          motherTongue = value ?? "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Container(
                                      child: Text(
                                        'Community',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        initialValue: selectedCommunity,
                                        onChanged: (val) {
                                          // selectedCommunity = val;
                                          if(selectedCommunity == ""){
                                          if(val.isNotEmpty){
                                            setState(() {
                                              commVal = 1;
                                              selectedCommunityFinal = val;
                                              print("1");
                                              print("selectedCommunityFinal==>>>$selectedCommunityFinal");
                                            });
                                          }  else{
                                              setState(() {
                                                commVal = 0;
                                                selectedCommunityFinal = val;
                                                print("emp 0");
                                                print("selectedCommunityFinal==>>>$selectedCommunityFinal");
                                              });
                                            }
                                          } else{
                                            if(val.isEmpty){
                                              setState(() {
                                                commVal = 2;
                                                selectedCommunityFinal = val;
                                                print("2");
                                                print("selectedCommunityFinal==>>>$selectedCommunityFinal");
                                              });
                                            }else{
                                              setState(() {
                                                commVal = 0;
                                                selectedCommunityFinal = val;
                                                print("0");
                                                print("selectedCommunityFinal==>>>$selectedCommunityFinal");
                                              });
                                            }
                                          }
                                        },
                                        // onFieldSubmitted: (val){
                                        //   setState(() {
                                        //     selectedCommunity = val;
                                        //   });
                                        // },
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText: "Enter Community",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
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
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        initialValue: motherGotra,
                                        onChanged: (val) {
                                          motherGotra = val;
                                        },
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText: "Enter Gothra / Gothram",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
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
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        initialValue: fathergotra,
                                        onChanged: (val) {
                                          fathergotra = val;
                                        },
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText: "Enter Gothra / Gothram",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Card(
                  elevation: 6,
                  child: Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _family = !_family;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Family',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorPrimary,
                                  ),
                                ),
                                Icon(
                                  _family
                                      ? MdiIcons.chevronDown
                                      : MdiIcons.chevronUp,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _family
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Family Value',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .005,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: selectedFamilyValue,
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
                                        items: Constants.familyValues.map((e) {
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          selectedFamilyValue = value ?? "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      child: Text(
                                        'Affluence Level',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .005,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: selectedAfflenceValue,
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
                                        items: Constants.afluenceList.map((e) {
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          selectedAfflenceValue = value ??"";
                                        },
                                      ),
                                    ),
                                    SizedBox(height: height * .02),
                                    SizedBox(
                                        height: height * .03,
                                        child: Text(
                                          'More Family info',
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
                                          ),
                                        )),
                                    SizedBox(height: height * .02),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: width * .6,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 18),
                                                      width: width * .15,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              theme.colorGrey,
                                                        ),
                                                        color: theme
                                                            .colorBackground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5,
                                                        ),
                                                      ),
                                                      child: TextFormField(
                                                        focusNode: FocusNode(
                                                            canRequestFocus:
                                                                false),
                                                        initialValue:
                                                            (marriedBrothers !=
                                                                    "0")
                                                                ? marriedBrothers
                                                                : "",
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (val) {
                                                          marriedBrothers = val;
                                                          return null;
                                                        },
                                                        cursorColor: theme
                                                            .colorCompanion,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "0",
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'Married',
                                                        style: GoogleFonts
                                                            .openSans(
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
                                                          EdgeInsets.symmetric(
                                                              horizontal: 18),
                                                      width: width * .15,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              theme.colorGrey,
                                                        ),
                                                        color: theme
                                                            .colorBackground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5,
                                                        ),
                                                      ),
                                                      child: TextFormField(
                                                        focusNode: FocusNode(
                                                            canRequestFocus:
                                                                false),
                                                        initialValue:
                                                            noOfBrothers != "0"
                                                                ? noOfBrothers
                                                                : "",
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (val) {
                                                          noOfBrothers = val;
                                                          return null;
                                                        },
                                                        cursorColor: theme
                                                            .colorCompanion,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "0",
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'Unmarried',
                                                        style: GoogleFonts
                                                            .openSans(
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 18),
                                                      width: width * .15,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              theme.colorGrey,
                                                        ),
                                                        color: theme
                                                            .colorBackground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5,
                                                        ),
                                                      ),
                                                      child: TextFormField(
                                                        focusNode: FocusNode(
                                                            canRequestFocus:
                                                                false),
                                                        initialValue:
                                                            marriedSisters !=
                                                                    "0"
                                                                ? marriedSisters
                                                                : "",
                                                        onChanged: (val) {
                                                          marriedSisters = val;
                                                          return null;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        cursorColor: theme
                                                            .colorCompanion,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "0",
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'Married',
                                                        style: GoogleFonts
                                                            .openSans(
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
                                                          EdgeInsets.symmetric(
                                                              horizontal: 18),
                                                      width: width * .15,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              theme.colorGrey,
                                                        ),
                                                        color: theme
                                                            .colorBackground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5,
                                                        ),
                                                      ),
                                                      child: TextFormField(
                                                        focusNode: FocusNode(
                                                            canRequestFocus:
                                                                false),
                                                        initialValue:
                                                            noOfSisters != "0"
                                                                ? noOfSisters
                                                                : "",
                                                        onChanged: (val) {
                                                          noOfSisters = val;
                                                          return null;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        cursorColor: theme
                                                            .colorCompanion,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "0",
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'Unmarried',
                                                        style: GoogleFonts
                                                            .openSans(
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
                                        'Father\'s Name',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .005,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        initialValue: fatherName,
                                        onChanged: (val) {
                                          fatherName = val;
                                        },
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText: "Enter Name",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
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
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: fatherStatus,
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
                                        items:
                                            Constants.fatherStatusList.map((e) {
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          fatherStatus = value ?? "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Container(
                                      child: Text(
                                        'Father\'s Family is From',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        initialValue: nativeCity,
                                        onChanged: (val) {
                                          nativeCity = val;
                                        },
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText: "Enter Place",
                                          border: InputBorder.none,
                                        ),
                                      ),
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
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: motherStatus,
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
                                        items:
                                            Constants.motherStatusList.map((e) {
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          motherStatus = value ?? "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .005,
                                    ),
                                    Container(
                                      child: Text(
                                        'Mother\'s Name',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .005,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        initialValue: motherName,
                                        onChanged: (val) {
                                          motherName = val;
                                        },
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText: "Enter Name",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Card(
                  elevation: 6,
                  child: Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _astro = !_astro;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Astro Details',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorPrimary,
                                  ),
                                ),
                                Icon(
                                  _astro
                                      ? MdiIcons.chevronDown
                                      : MdiIcons.chevronUp,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _astro
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'City of Birth',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        enabled: false,
                                        initialValue: cityOfBirth,
                                        onChanged: (val) {
                                          cityOfBirth = val;
                                        },
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText: "Enter City",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
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
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: manglik,
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
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          manglik = value ?? "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Container(
                                      child: Text(
                                        'Time of Birth',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * .015),


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
                                            value: selectedHour,
                                            validator: (val) {
                                              if (val == null) {
                                                return 'Required*';
                                              } else
                                                return null;
                                            },
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
                                            value: selectedMinute,
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
                                            value: selectedAmPm,
                                            validator: (val) {
                                              if (val == null) {
                                                return 'Required*';
                                              } else
                                                return null;
                                            },
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18),
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
                                                          '${timeOfBirth!.hourOfPeriod}:${timeOfBirth!.minute} ${timeOfBirth!.period.toString().split('.').last}'))
                                                  : Center(
                                                      child: Text(
                                                          'Not Provided'))),
                                        )),*/
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18),
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
                                          value : showHoroscope,
                                          onChanged: (val) {
                                            setState(() {});
                                            showHoroscope = val ?? false;
                                          },
                                        )),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Card(
                  elevation: 6,
                  child: Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _location = !_location;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8
                                // vertical: 20,
                                // horizontal: 15,
                                ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Location & Education',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorPrimary,
                                  ),
                                ),
                                Icon(
                                  _location
                                      ? MdiIcons.chevronDown
                                      : MdiIcons.chevronUp,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _location
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Country, State, City',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    CSCPicker(
                                      currentState: state,
                                      currentCity: city,
                                      currentCountry: selectedcountry,
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
                                          selectedcountry = value;
                                        });
                                      },
                                      onStateChanged: (value) {
                                        setState(() {
                                          // state = value ?? "";
                                          if(state.isEmpty){
                                            if(value!.isNotEmpty){
                                              setState(() {
                                                stateVal = 1;
                                                state = value ?? "";
                                                print("1");
                                              });
                                            }  else{
                                              print("emp 0");
                                              setState(() {
                                                stateVal = 0;
                                                state = value ?? "";
                                              });
                                            }
                                          } else{
                                            if(value!.isEmpty){
                                              setState(() {
                                                stateVal = 2;
                                                state = value ?? "";
                                                print("2");
                                              });
                                            }else{
                                              setState(() {
                                                print("0");
                                                stateVal = 0;
                                                state = value ?? "";
                                              });
                                            }
                                          }
                                        });
                                      },
                                      onCityChanged: (value) {
                                        setState(() {
                                          // city = value ?? "";
                                          if(city.isEmpty){
                                            if(value!.isNotEmpty){
                                              setState(() {
                                                cityVal = 1;
                                                city = value ?? "";
                                                print("1");
                                              });
                                            }  else{
                                              print("emp 0");
                                              setState(() {
                                                cityVal = 0;
                                                city = value ?? "";
                                              });
                                            }
                                          } else{
                                            if(value!.isEmpty){
                                              setState(() {
                                                cityVal = 2;
                                                city = value ?? "";
                                                print("2");
                                              });
                                            }else{
                                              setState(() {
                                                print("0");
                                                cityVal = 0;
                                                city = value ?? "";
                                              });
                                            }
                                          }
                                        });
                                      }
                                    ),

                                    SizedBox(
                                      height: height * .02,
                                    ),

                                    /* Container(
                                      child: Text(
                                        'Country',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                              focusNode: FocusNode(
                                                  canRequestFocus: false),
  
                                        enabled: false,
                                        initialValue: selectedcountry,
                                        onChanged: (val) {
                                          selectedcountry = val;
                                        },
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText: "Country",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
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
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                              focusNode: FocusNode(
                                                  canRequestFocus: false),
  
                                        enabled: false,
                                        initialValue: state,
                                        onChanged: (val) {
                                          state = val;
                                        },
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText: "Enter State",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Container(
                                      child: Text(
                                        'City',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                              focusNode: FocusNode(
                                                  canRequestFocus: false),
  
                                        onChanged: (val) {
                                          city = val;
                                        },
                                        initialValue: city,
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText: "Enter City",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ), */
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: highestQualification,
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
                                        items: Constants.qualificationList
                                            .map((e) {
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          highestQualification = value ?? "";
                                        },
                                      ),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        onChanged: (val) {
                                          clgAttended = val;
                                        },
                                        initialValue: clgAttended,
                                        cursorColor: theme.colorCompanion,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Specify highest degree college",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        onChanged: (val) {
                                          workWith = val;
                                        },
                                        initialValue: workWith,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: designation,
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
                                        items:
                                            Constants.designationList.map((e) {
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          designation = value ?? "";
                                        },
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
                                    //
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: employedIn,
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
                                        items:
                                            Constants.employedInList.map((e) {
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          employedIn = value ?? "";
                                        },
                                      ),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: annualIncome,
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
                                          annualIncome = value ?? "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Card(
                  elevation: 6,
                  child: Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _lifestyle = !_lifestyle;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lifestyle',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorPrimary,
                                  ),
                                ),
                                Icon(
                                  _lifestyle
                                      ? MdiIcons.chevronDown
                                      : MdiIcons.chevronUp,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _lifestyle
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
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
                                        value: selectedDiet,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: Text('Select'),
                                        items: Constants.dietList.map((e) {
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          selectedDiet = value ?? "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Card(
                  elevation: 6,
                  child: Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _hobies = !_hobies;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Hobbies and More',
                                  style: GoogleFonts.ptSans(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorPrimary,
                                  ),
                                ),
                                Icon(
                                  _hobies
                                      ? MdiIcons.chevronDown
                                      : MdiIcons.chevronUp,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _hobies
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Hobbies',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .015,
                                    ),
                                    MultiSelectDialogField(
                                      initialValue: selectedHobbies,
                                      selectedItemsTextStyle:
                                          GoogleFonts.workSans(
                                              color: Colors.white),
                                      listType: MultiSelectListType.CHIP,
                                      searchable: true,
                                      items: Constants.hobbies
                                          .map((e) => MultiSelectItem(e, e))
                                          .toList(),
                                      title: Text("Select Hobbies"),
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
                                        "Choose Hobbies",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (results) {
                                        selectedHobbies = results;
                                      },
                                    ),
                                    SizedBox(height: height * .02),
                                    Container(
                                        child: Text('Interests',
                                            style: GoogleFonts.openSans(
                                                fontSize: 14))),
                                    SizedBox(height: height * .015),
                                    MultiSelectDialogField(
                                      initialValue: selectedIntrested,
                                      selectedItemsTextStyle:
                                          GoogleFonts.workSans(
                                              color: Colors.white),
                                      listType: MultiSelectListType.CHIP,
                                      searchable: true,
                                      items: Constants.intrests
                                          .map((e) => MultiSelectItem(e, e))
                                          .toList(),
                                      title: Text("Select Intrests"),
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
                                        "Choose Intrests",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (results) {
                                        selectedIntrested = results;
                                      },
                                    ),
                                    SizedBox(height: height * .02),
                                    Container(
                                        child: Text('FavMusic',
                                            style: GoogleFonts.openSans(
                                                fontSize: 14))),
                                    SizedBox(height: height * .015),
                                    MultiSelectDialogField(
                                      initialValue: selectedMustic,
                                      selectedItemsTextStyle:
                                          GoogleFonts.workSans(
                                              color: Colors.white),
                                      listType: MultiSelectListType.CHIP,
                                      searchable: true,
                                      items: Constants.favMusic
                                          .map((e) => MultiSelectItem(e, e))
                                          .toList(),
                                      title: Text("Select Music"),
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
                                        "Choose Music",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (results) {
                                        selectedMustic = results;
                                      },
                                    ),
                                    SizedBox(height: height * .02),
                                    Container(
                                        child: Text('Select/Fitness Activities',
                                            style: GoogleFonts.openSans(
                                                fontSize: 14))),
                                    SizedBox(height: height * .015),
                                    MultiSelectDialogField(
                                      initialValue: selectedSports,
                                      selectedItemsTextStyle:
                                          GoogleFonts.workSans(
                                              color: Colors.white),
                                      listType: MultiSelectListType.CHIP,
                                      searchable: true,
                                      items: Constants.sportsFitnes
                                          .map((e) => MultiSelectItem(e, e))
                                          .toList(),
                                      title: Text("Select Fitness"),
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
                                        "Choose Fitness",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (results) {
                                        selectedSports = results;
                                      },
                                    ),
                                    SizedBox(height: height * .02),
                                    Container(
                                        child: Text('Cousine',
                                            style: GoogleFonts.openSans(
                                                fontSize: 14))),
                                    SizedBox(height: height * .015),
                                    MultiSelectDialogField(
                                      initialValue: selectedFavCousine,
                                      selectedItemsTextStyle:
                                          GoogleFonts.workSans(
                                              color: Colors.white),
                                      listType: MultiSelectListType.CHIP,
                                      searchable: true,
                                      items: Constants.favCousine
                                          .map((e) => MultiSelectItem(e, e))
                                          .toList(),
                                      title: Text("Select Cousine"),
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
                                        "Choose Cousine",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (results) {
                                        selectedFavCousine = results;
                                      },
                                    ),
                                    SizedBox(height: height * .02),
                                    Container(
                                        child: Text('Dress Style',
                                            style: GoogleFonts.openSans(
                                                fontSize: 14))),
                                    SizedBox(height: height * .015),
                                    MultiSelectDialogField(
                                      initialValue: selectedDressStyle,
                                      selectedItemsTextStyle:
                                          GoogleFonts.workSans(
                                              color: Colors.white),
                                      listType: MultiSelectListType.CHIP,
                                      searchable: true,
                                      items: Constants.dressStyle
                                          .map((e) => MultiSelectItem(e, e))
                                          .toList(),
                                      title: Text("Select Dress Style"),
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
                                        "Choose Dress Style",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (results) {
                                        selectedDressStyle = results;
                                      },
                                    ),
                                    SizedBox(height: height * .02),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
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
                SizedBox(
                  height: height * .02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
