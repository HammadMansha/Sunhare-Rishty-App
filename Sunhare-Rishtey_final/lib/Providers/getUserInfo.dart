import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/models/GovIdModel.dart';
import '/models/UserModel.dart';
import '/models/parternerInfoModel.dart';
import '/models/primiumModel.dart';

class CurrUserInfo with ChangeNotifier {
  UserInformation currentUser = UserInformation();
  PartnerInfo partnerInfo = PartnerInfo();
  bool isVerificationRequired = false;
  bool isVerificationPending = false;
  GovIdModel govDataModel = GovIdModel();

  Future<UserInformation> getData() async {
    print("Test data");

    print("currentUser!.uid====>>>${FirebaseAuth.instance.currentUser!.uid}");
    final premi = await FirebaseDatabase.instance
        .reference()
        .child('ActiveMembership')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once();
    PremiumModel premiumValues;
    DateTime validTill2;

    Map tempData = {};

    if(premi.snapshot.value != null ) {
      tempData = premi.snapshot.value as Map;
    }

    if (tempData != null && tempData.isNotEmpty) {
      print("get info ValidTill${tempData['ValidTill'].toString().contains("T")}");
      if(tempData['ValidTill'].toString().contains("T")){
        validTill2 = DateTime.parse(
            "${tempData['ValidTill'].split('T')[0]} 00:00:00.000");
        validTill2 = validTill2.add(Duration(days: 1));
      }else{
        validTill2 = DateTime.parse(
            "${tempData['ValidTill'].toString().replaceFirst(" ","T").split('T')[0]} 00:00:00.000");
        validTill2 = validTill2.add(Duration(days: 1));
      }

      premiumValues = PremiumModel(
          dateOfPerchase: DateTime.parse(tempData['DateOfPerchase']),
          validTill: DateTime.parse(tempData['ValidTill']),
          contact: tempData['contacts'],
          name: tempData['name'],
          packageName: tempData['packageName'],
          isActive: tempData['ValidTill'] != null
              ? (validTill2.compareTo(DateTime.now()) > 0)
              : false);
    } else {
      premiumValues = PremiumModel();
    }

    final data = await FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once();
    Map tempMapData = data.snapshot.value as Map;
    if (tempMapData != null && tempMapData.isNotEmpty) {
      final hideMap = tempMapData['hideProfile'] != null
          ? tempMapData['hideProfile'] as Map
          : null;
      bool hide = false;
      if (hideMap != null) {
        hideMap.forEach((key, value) {
          if(key == "unHideDate"){
            DateTime tempDate = DateTime.parse(value);
            if(DateTime.now().isBefore(tempDate) == false){
              hide = false;
            }else{
              hide = true;
            }
          }
          /*if (value) {
            hide = value;
          }*/
        });
      }

      List<String> blockedById = [];

      if (tempMapData['Blocked By'] != null) {
        tempMapData['Blocked By'].forEach((key, value) {
          blockedById.add(key);
        });
      }

      currentUser = UserInformation(
          hideProfile: hide,
          isSuspended: tempMapData['isSuspended'] ?? false,
          premiumModel: premiumValues,
          affluenceLevel: tempMapData['afluenceValue'] ?? null,
          familyValues: tempMapData['familyValue'] ?? null,
          motherName: tempMapData['motherName'] ?? '',
          fatherName: tempMapData['fatherName'] ?? '',
          showHoroscope: tempMapData['showHoroscope'] ?? false,
          birthTime: tempMapData['timeOfBirth']!= null ? splitData(tempMapData['timeOfBirth']) : TimeOfDay.now(),
          bloodGroup: tempMapData['bloodGroup'] ?? "",
          healthInfo: tempMapData['healthInfo'] ?? '',
          employedIn: tempMapData['employedIn'] ?? '',
          visibility: tempMapData['visibility'] ?? "All Member",
          isPremium: tempData.isNotEmpty && (premiumValues?.isActive ?? false),
          fatherGautra: tempMapData['fatherGotra'],
          motherGautra: tempMapData['motherGotra'],
          blockedByList: blockedById,
          name: tempMapData['userName'] ?? "",
          srId: tempMapData['id']?? "",
          email: tempMapData['email'] ?? "",
          id: data.snapshot.key,
          marriedBrothers: tempMapData['marriedBrothers'] ?? "",
          marriedSisters: tempMapData['marriedSisters'] ?? "",
          gender: tempMapData['gender'] ?? "",
          phone: tempMapData['mobileNo'] ?? "",
          dateOfBirth: tempMapData['DateOfBirth'] ?? "15/Feb/1994",
          religion: tempMapData['Religion'] ?? "",
          annualIncome: tempMapData['annualIncome'] ?? "",
          collegeAttended: tempMapData['clg'] ?? "",
          workingAs: tempMapData['designation'] ?? "",
          country: tempMapData['living'] ?? "",
          highestQualification: tempMapData['qualification'] ?? "Ph.D.",
          workingWith: tempMapData['workAt'] ?? "",
          anyDisAbility: tempMapData['disability'] ?? "",
          brothers: tempMapData['brotherCount'] ?? "",
          sisters: tempMapData['sisterCount'] ?? "",
          intro: tempMapData['intro'] ?? "",
          manglik: tempMapData['maglik'] ?? "",
          city: tempMapData['city'] ?? "",
          allowMarketing: tempMapData['allowMarketing'] ?? true,
          diet: tempMapData['diet'] ?? "",
          imageUrl: tempMapData['imageURL'] ?? "",
          gotra: tempMapData['gautra'] ?? "",
          zipCode: tempMapData['zipCode'] ?? "",
          cityOfBirth: tempMapData['cityOfBirth'] ?? "",
          employerName: tempMapData['employerName'] ?? "",
          state: tempMapData['state'] ?? "",
          residencyStatus: tempMapData['residency'] ?? "",
          motherStatus: tempMapData['MotherStatus'] ?? "",
          postedBy: tempMapData['ProfileFor'] ?? "",
          nativePlace: tempMapData['nativePlace'] ?? "",
          motherTongue: tempMapData['motherTongue'] ?? "",
          community: tempMapData['Community'] ?? "",
          fatherStatus: tempMapData['FatherStatus'] ?? "",
          grewUpIn: tempMapData['grewUpIn'] ?? "",
          familyType: tempMapData['familyType'] ?? "",
          height: tempMapData['personHeight'] ?? "",
          partnerInfo: partnerInfo,
          isVerified: tempMapData['isVerified'] ?? "",
          noOfChildren: tempMapData['noOfChildren']?? "",
          childrenLivingTogether: tempMapData['childrenLivingTogether'] ?? "",
          introEdited: tempMapData['introEdited'] ?? 0,
          newIntro: tempMapData['newIntro'] ?? "",
          maritalStatus: tempMapData['maritalStatus'] ?? "",
      dateOfCreated: DateTime.parse(tempMapData['DateTime']));
      isVerificationPending = tempMapData['isVerificationPending'] ?? false;
      isVerificationRequired = tempMapData['isVerificationRequired'] ?? false;
    }

    final pref = await FirebaseDatabase.instance
        .reference()
        .child('Partner Prefrence')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once();
    Map temp = pref.snapshot.value as Map;
    bool maritalStatusForAll = currentUser.maritalStatus != "Never Married";
    List selectedMaritalStatusList = [];
    if (!maritalStatusForAll) {
      selectedMaritalStatusList = ["Never Married"];
    }
    if (temp != null && temp.isNotEmpty) {
      partnerInfo = PartnerInfo(
          maritalStatusForAll:
              temp['maritalStatusForAll'] ?? maritalStatusForAll,
          selectedMaritalStatusList:
              temp['maritalStatusList'] ?? selectedMaritalStatusList,
          motherToungueForAll: temp['motherToungeForAll'] ?? true,
          selectedMotherToungueList: temp['motherToungueList'] ?? [],
          manglikForAll: temp['manglikForAll'] ?? true,
          selectedManglikList: temp['selectedManglikList'] ?? [],
          employedInForAll: temp['employedInForAll'] ?? true,
          selectedEmployedInList: temp['emplyedInList'] ?? [],
          religionForAll: temp['religionForAll'] ?? true,
          selectedReligionList: temp['religionList'] ?? [],
          city: temp['city'] ?? '',
          country: temp['country'],
          workingWith: temp['workingWith'],
          workingAs: temp['designation'],
          diet: temp['diet'],
          maritalStatus: temp['maritalStatus'],
          maxAge: temp['maxAge'],
          minAge: temp['minAge'],
          maxIncome: temp['maxIncome'],
          minIncome: temp['minIncome'],
          motherTong: temp['motherTounge'],
          qualification: temp['qualification'],
          community: temp['community'],
          religion: temp['religion'],
          state: temp['state'],
          selectedDesignation: temp['designationList'] ?? [],
          maxHeight: temp['maxHeight'],
          selectedDietList: temp['dietList'] ?? [],
          selectedQualificationList: temp['qualificationList'] ?? [],
          designationOpenForAll: temp['desigForAll'] ?? true,
          dietForAll: temp['dietForAll'] ?? true,
          qualificationOpenForAll: temp['qualificationForAll'] ?? true,
          locationForAll: temp['locationForAll'] ?? true,
          selectedLocationList: temp['locationList'] ?? [],
          minHeight: temp['minHeight']);
    } else {
      partnerInfo = PartnerInfo(
          maritalStatusForAll: maritalStatusForAll,
          selectedMaritalStatusList: selectedMaritalStatusList,
          motherToungueForAll: true,
          selectedMotherToungueList: [],
          religionForAll: true,
          selectedReligionList: [],
          city: '',
          selectedDesignation: [],
          selectedDietList: [],
          selectedQualificationList: [],
          designationOpenForAll: true,
          dietForAll: true,
          qualificationOpenForAll: true,
          locationForAll: true,
          manglikForAll: true,
          selectedManglikList: [],
          employedInForAll: true,
          selectedEmployedInList: [],
          selectedLocationList: []);
    }
    updatePartnerInfo(partnerInfo);
    return currentUser;
  }

  Future<GovIdModel> getGovData() async {
    final govData = await FirebaseDatabase.instance
        .reference()
        .child('Gov Id')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once();
    final tempMapdata = govData.snapshot.value as Map;

    if (tempMapdata != null && tempMapdata.isNotEmpty) {
      this.govDataModel = GovIdModel.fromJson(tempMapdata);
      return this.govDataModel;
    } else {
      return this.govDataModel;
    }
  }

  void updatePartnerInfo(PartnerInfo partnerInfo) {
    currentUser.partnerInfo = partnerInfo;
    notifyListeners();
  }

  void updateCurrentUser(UserInformation userInformation) {
    currentUser = userInformation;
    currentUser.partnerInfo = partnerInfo;
    notifyListeners();
  }

  void updateImageUrl(String url) {
    currentUser.imageUrl = url;
    notifyListeners();
  }

  void updateVisibility(String val) {
    currentUser.visibility = val;
  }

  splitData(String time) {
    if (time != null) {
      try {
        List t = time.split('');
        log(t.toString());
        int hr = int.parse(t[10]) * 10 + int.parse(t[11]);
        int minute = int.parse(t[13]) * 10 + int.parse(t[14]);
        log(TimeOfDay(hour: hr, minute: minute).toString());

        return TimeOfDay(hour: hr, minute: minute);
      } catch (e) {
        return null;
      }
    } else
      return null;
  }
}
