import 'package:intl/intl.dart';
import 'package:matrimonial_app/models/UserModel.dart';

class PartnerInfo {
  final String? id;
  final String? minAge;
  final String? minHeight;
  final String? maritalStatus;
  final String? religion;
  final String? motherTong;
  final String? country;
  final String? state;
  final String? city;
  final String? qualification;
  final String? workingWith;
  final String? workingAs;
  final String? proffesionArea;
  final String? minIncome;
  final String? diet;
  final String? maxAge;
  final String? maxIncome;
  final String? maxHeight;
  final String? community;
  final bool? qualificationOpenForAll;
  final bool? designationOpenForAll;
  final bool? dietForAll;
  final bool? locationForAll;
  final bool? maritalStatusForAll;
  final bool? religionForAll;
  final bool? motherToungueForAll;
  final bool? manglikForAll;
  final bool? employedInForAll;
  final List? selectedDietList;
  final List? selectedManglikList;
  final List? selectedDesignation;
  final List? selectedQualificationList;
  final List? selectedLocationList;
  final List? selectedMaritalStatusList;
  final List? selectedReligionList;
  final List? selectedMotherToungueList;
  final List? selectedEmployedInList;

  PartnerInfo(
      {this.id,
      this.minAge,
      this.minIncome,
      this.maxIncome,
      this.maxAge,
      this.city,
      this.country,
      this.diet,
      this.minHeight,
      this.maritalStatus,
      this.motherTong,
      this.proffesionArea,
      this.qualification,
      this.religion,
      this.state,
      this.workingAs,
      this.workingWith,
      this.community,
      this.selectedDesignation,
      this.selectedQualificationList,
      this.selectedDietList,
      this.designationOpenForAll,
      this.dietForAll,
      this.qualificationOpenForAll,
      this.manglikForAll,
      this.locationForAll,
      this.selectedLocationList,
      this.maxHeight,
      this.maritalStatusForAll,
      this.motherToungueForAll,
      this.employedInForAll,
      this.religionForAll,
      this.selectedMaritalStatusList,
      this.selectedManglikList,
      this.selectedMotherToungueList,
      this.selectedEmployedInList,
      this.selectedReligionList});

  static PartnerInfo fromJson(key, pref) {
    return PartnerInfo(
        id: key,
        maritalStatusForAll: pref.value['maritalStatusForAll'] ?? false,
        selectedMaritalStatusList: pref.value['maritalStatusList'] ?? [],
        motherToungueForAll: pref.value['motherToungeForAll'] ?? true,
        selectedMotherToungueList: pref.value['motherToungueList'] ?? [],
        religionForAll: pref.value['religionForAll'] ?? true,
        manglikForAll: pref.value['manglikForAll'] ?? true,
        employedInForAll: pref.value['employedInForAll'] ?? true,
        selectedEmployedInList: pref.value['emplyedInList'] ?? [],
        selectedReligionList: pref.value['religionList'] ?? [],
        selectedManglikList: pref.value['selectedManglikList'] ?? [],
        city: pref.value['city'] ?? '',
        country: pref.value['country'],
        workingWith: pref.value['workingWith'],
        workingAs: pref.value['designation'],
        diet: pref.value['diet'],
        maritalStatus: pref.value['maritalStatus'],
        maxAge: pref.value['maxAge'],
        minAge: pref.value['minAge'],
        maxIncome: pref.value['maxIncome'],
        minIncome: pref.value['minIncome'],
        motherTong: pref.value['motherTounge'],
        qualification: pref.value['qualification'],
        community: pref.value['community'],
        religion: pref.value['religion'],
        state: pref.value['state'],
        selectedDesignation: pref.value['designationList'] ?? [],
        maxHeight: pref.value['maxHeight'],
        selectedDietList: pref.value['dietList'] ?? [],
        selectedQualificationList: pref.value['qualificationList'] ?? [],
        designationOpenForAll: pref.value['desigForAll'] ?? true,
        dietForAll: pref.value['dietForAll'] ?? true,
        qualificationOpenForAll: pref.value['qualificationForAll'] ?? true,
        locationForAll: pref.value['locationForAll'] ?? true,
        selectedLocationList: pref.value['locationList'] ?? [],
        minHeight: pref.value['minHeight']);
  }

  static bool checkPref(
      List selectedList, String partnerInfo, bool openForAll) {
    return !(openForAll || selectedList.contains(partnerInfo));
  }

  static int countIncome(String annualIncome) {
    String str = annualIncome.replaceFirst("-", "").replaceFirst(" lakhs", "");
    if (str == "Not Working" || str == "" || str.contains("<")) {
      return 0;
    } else if (str.contains(">")) {
      return 100000;
    } else {
      return int.parse(str);
    }
  }

  static int calculateHeight(String height) {
    String str = height.split(' - ')[1];
    return int.parse(str.substring(0, str.length - 2));
  }

  static int calculateAge(String dobirth) {
    var now = DateTime.now();
    final DateFormat format = new DateFormat("dd/MMM/yyyy");
    var dob = format.parse(dobirth);
    return (now.difference(dob).inDays ~/ 365);
  }

  static bool matchPreferences(
      PartnerInfo partnerInfo, UserInformation currentUser) {
    if (checkPref(partnerInfo.selectedMaritalStatusList ?? [],
        currentUser.maritalStatus ?? "", partnerInfo.maritalStatusForAll ?? false)) {
      return false;
    }
    if (checkPref(partnerInfo.selectedDietList ?? [], currentUser.diet ?? "",
        partnerInfo.dietForAll ?? false)) {
      return false;
    }
    if (checkPref(partnerInfo.selectedDesignation ?? [], currentUser.workingAs ?? "",
        partnerInfo.designationOpenForAll ?? false)) {
      return false;
    }
    if (checkPref(
        partnerInfo.selectedQualificationList ?? [],
        currentUser.highestQualification ??"",
        partnerInfo.qualificationOpenForAll ?? false)) {
      return false;
    }
    if (checkPref(partnerInfo.selectedReligionList ?? [], currentUser.religion ?? "",
        partnerInfo.religionForAll ?? false)) {
      return false;
    }
    if (checkPref(partnerInfo.selectedMotherToungueList ?? [],
        currentUser.motherTongue ?? "", partnerInfo.motherToungueForAll ?? false)) {
      return false;
    }
    if (checkPref(partnerInfo.selectedLocationList ?? [], currentUser.state ?? "",
        partnerInfo.locationForAll ?? false)) {
      return false;
    }
    if (checkPref(partnerInfo.selectedEmployedInList ?? [], currentUser.employedIn ?? "",
        partnerInfo.employedInForAll ?? false)) {
      return false;
    }
    if (currentUser.dateOfBirth != null &&
        ((partnerInfo.minAge != null &&
                int.parse(partnerInfo.minAge ?? "0") >
                    calculateAge(currentUser.dateOfBirth ?? "")) ||
            (partnerInfo.maxAge != null &&
                int.parse(partnerInfo.maxAge ?? "0") <
                    calculateAge(currentUser.dateOfBirth ?? "")))) {
      return false;
    }
    if (currentUser.annualIncome != null) {
      int income = countIncome(currentUser.annualIncome ?? "");
      if ((partnerInfo.minIncome != null &&
              countIncome(partnerInfo.minIncome ?? "0") > income) ||
          (partnerInfo.maxIncome != null &&
              countIncome(partnerInfo.maxIncome ?? "0") < income)) {
        return false;
      }
    }
    if (currentUser.height != null) {
      String str = currentUser.height!.split(' - ')[1];
      int elementHeight = int.parse(str.substring(0, str.length - 2));
      if ((partnerInfo.maxHeight != null &&
              elementHeight > calculateHeight(partnerInfo.maxHeight ?? "0")) ||
          (partnerInfo.minHeight != null &&
              elementHeight < calculateHeight(partnerInfo.minHeight ?? "0"))) {
        return false;
      }
    }
    if (checkPref(partnerInfo.selectedManglikList ?? [], currentUser.manglik ?? "",
        partnerInfo.manglikForAll ?? false)) {
      return false;
    }
    return true;
  }
}
