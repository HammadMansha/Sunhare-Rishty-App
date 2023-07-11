import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/Providers/getUserInfo.dart';
import 'package:matrimonial_app/customs/Utils.dart';
import 'package:matrimonial_app/models/UserModel.dart';
import 'package:matrimonial_app/models/parternerInfoModel.dart';
import 'package:provider/provider.dart';

class PlayGround extends StatefulWidget {
  PlayGround({Key? key}) : super(key: key);

  @override
  _PlayGroundState createState() => _PlayGroundState();
}

class _PlayGroundState extends State<PlayGround> with WidgetsBindingObserver {
  List<PartnerInfo> partnerInfoList = [];
  UserInformation currentUser = UserInformation();
  List matchedUserIds = [];

  Future<List<PartnerInfo>> getPrefrenceList() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child('Partner Prefrence')
        .once();
    if (data.snapshot.value == null) return [];
    Map values = data.snapshot.value as Map;
    matchedUserIds = values.keys.toList();

    List<PartnerInfo> partnerInfoList = [];
    values.forEach((key, value) {
      partnerInfoList.add(PartnerInfo(
          id: key,
          maritalStatusForAll: value['maritalStatusForAll'] ?? false,
          selectedMaritalStatusList: value['maritalStatusList'] ?? [],
          motherToungueForAll: value['motherToungeForAll'] ?? true,
          selectedMotherToungueList: value['motherToungueList'] ?? [],
          religionForAll: value['religionForAll'] ?? true,
          selectedReligionList: value['religionList'] ?? [],
          city: value['city'] ?? '',
          country: value['country'],
          workingWith: value['workingWith'],
          workingAs: value['designation'],
          diet: value['diet'],
          maritalStatus: value['maritalStatus'],
          maxAge: value['maxAge'],
          minAge: value['minAge'],
          maxIncome: value['maxIncome'],
          minIncome: value['minIncome'],
          motherTong: value['motherTounge'],
          qualification: value['qualification'],
          community: value['community'],
          religion: value['religion'],
          state: value['state'],
          selectedDesignation: value['designationList'] ?? [],
          maxHeight: value['maxHeight'],
          selectedDietList: value['dietList'] ?? [],
          selectedQualificationList: value['qualificationList'] ?? [],
          designationOpenForAll: value['desigForAll'] ?? true,
          dietForAll: value['dietForAll'] ?? true,
          qualificationOpenForAll: value['qualificationForAll'] ?? true,
          locationForAll: value['locationForAll'] ?? true,
          selectedLocationList: value['locationList'] ?? [],
          minHeight: value['minHeight']));
    });
    return partnerInfoList;
  }

  Future<UserInformation> getCurrUser() async {
    final ref = Provider.of<CurrUserInfo>(context, listen: false);
    await ref.getData();
    return ref.currentUser;
  }

  bool checkPref(List selectedList, String partnerInfo, bool openForAll) {
    return !(openForAll || selectedList.contains(partnerInfo));
  }

  filterUsers() {
    for (PartnerInfo partnerInfo in partnerInfoList) {
      if (checkPref(partnerInfo.selectedMaritalStatusList ?? [],
          currentUser.maritalStatus ?? "", partnerInfo.maritalStatusForAll ?? false)) {
        matchedUserIds.remove(partnerInfo.id);
      } else if (checkPref(partnerInfo.selectedDietList ?? [], currentUser.diet ?? "",
          partnerInfo.dietForAll ?? false)) {
        matchedUserIds.remove(partnerInfo.id);
      } else if (checkPref(partnerInfo.selectedDesignation ?? [],
          currentUser.workingAs ?? "", partnerInfo.designationOpenForAll ?? false)) {
        matchedUserIds.remove(partnerInfo.id);
      } else if (checkPref(
          partnerInfo.selectedQualificationList ??[],
          currentUser.highestQualification ?? "",
          partnerInfo.qualificationOpenForAll ?? false)) {
        matchedUserIds.remove(partnerInfo.id);
      } else if (checkPref(partnerInfo.selectedReligionList ?? [],
          currentUser.religion ?? "", partnerInfo.religionForAll ?? false)) {
        matchedUserIds.remove(partnerInfo.id);
      } else if (checkPref(partnerInfo.selectedMotherToungueList ?? [],
          currentUser.motherTongue ?? "", partnerInfo.motherToungueForAll ?? false)) {
        matchedUserIds.remove(partnerInfo.id);
      } else if (checkPref(partnerInfo.selectedLocationList ?? [], currentUser.state ?? "",
          partnerInfo.locationForAll ?? false)) {
        matchedUserIds.remove(partnerInfo.id);
      } else if (currentUser.dateOfBirth != null &&
          ((partnerInfo.minAge != null &&
                  int.parse(partnerInfo.minAge ?? "") >
                      calculateAge(currentUser.dateOfBirth ?? "")) ||
              (partnerInfo.maxAge != null &&
                  int.parse(partnerInfo.maxAge ?? "") <
                      calculateAge(currentUser.dateOfBirth ?? "")))) {
        matchedUserIds.remove(partnerInfo.id);
      } else if (currentUser.annualIncome != null) {
        int income = countIncome(currentUser.annualIncome ?? "");
        if ((partnerInfo.minIncome != null &&
                countIncome(partnerInfo.minIncome ?? "") > income) ||
            (partnerInfo.maxIncome != null &&
                countIncome(partnerInfo.maxIncome ?? "") < income)) {
          matchedUserIds.remove(partnerInfo.id);
        }
      } else if (currentUser.height != null) {
        String str = currentUser.height!.split(' - ')[1];
        int elementHeight = int.parse(str.substring(0, str.length - 2));
        if ((partnerInfo.maxHeight != null &&
                elementHeight > calculateHeight(partnerInfo.maxHeight ?? "")) ||
            (partnerInfo.minHeight != null &&
                elementHeight < calculateHeight(partnerInfo.minHeight ?? ""))) {
          matchedUserIds.remove(partnerInfo.id);
        }
      }
    }
  }

  @override
  void initState() {
    getCurrUser().then((value) {
      currentUser = value;
      getPrefrenceList().then((value) {
        partnerInfoList = value;
        filterUsers();
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.paused) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.only(top: 24.0),
          child: ListView.builder(
              itemCount: matchedUserIds.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: Icon(Icons.list),
                    title: Text("${matchedUserIds[index]}"));
              }),
        ),
      ),
    );
  }
}
