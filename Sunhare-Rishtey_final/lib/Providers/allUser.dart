import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/models/UserModel.dart';
import '/models/primiumModel.dart';

class AllUser with ChangeNotifier {
  List<UserInformation> allUsers = [];
  List<UserInformation> exploreUsers = [];
  List<UserInformation> unremovedUsers = [];

  Future<UserInformation> getUser(id) async {
    UserInformation userInformation = UserInformation();
    final data = await FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .child(id)
        .once();
    final verifiedData = await FirebaseDatabase.instance
        .reference()
        .child('Gov Id')
        .child(id)
        .once();
    Map tempMapData = data.snapshot.value as Map;

    if (data.snapshot.value != null) {
      if (tempMapData['isVerified'] != null && tempMapData['isVerified']) {
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
        if (!hide) {
          hide = tempMapData['isSuspended'] ?? false;
        }
        //  PremiumModel primium = getPrimium(key);
        final dobMap = tempMapData['hideDob'] != null ? tempMapData['hideDob'] as Map : null;
        final mobileMap = tempMapData['hideMobile'] != null
            ? tempMapData['hideMobile'] as Map
            : null;

        bool hideMobile = false;
        bool showDob = false;
        if (dobMap != null)
          dobMap.forEach((key, value) {
            showDob = value ?? false;
          });
        if (mobileMap != null) {
          mobileMap.forEach((key, value) {
            //hideMobile = value;
            if(key == "expireDate"){
              DateTime tempDate = DateTime.parse(value);
              if(DateTime.now().isBefore(tempDate) == false){
                hideMobile = false;
              }else{
                hideMobile = true;
              }
            }else{
              hideMobile = false;
            }
          });
        }
        // log(dobMap.toString());
        if (!hide) {
          userInformation = UserInformation(
              isGovIdVerified: verifiedData.snapshot.value != null
                  ? tempMapData['isVerified']
                  : false,
              govVerifiedBy: verifiedData.snapshot.value != null
                  ? tempMapData['verifiedBy']
                  : "Adhar card",
              hideProfile: hide,
              hideContact: hideMobile,
              hideDob: showDob,
              birthTime: tempMapData['timeOfBirth'] != null ? splitData(tempMapData['timeOfBirth']) : TimeOfDay.now(),

              verifiedBy: tempMapData['verifiedBy'] != null
                  ? tempMapData['verifiedBy']
                  : null,
              isPremium: tempMapData['isPremium'] != null
                  ? tempMapData['isPremium']
                  : false,
              isOnline: tempMapData['isOnline'] ?? false,
              userStatus: tempMapData['LastActive'] != null
                  ? DateTime.parse(tempMapData['LastActive'].toString())
                              .difference(DateTime.now())
                              .inMinutes
                              .abs() <
                          30
                      ? 'Active'
                      : 'Inactive'
                  : 'Inactive',
              showHoroscope: tempMapData['showHoroscope'] != null
                  ? tempMapData['showHoroscope']
                  : true,
              affluenceLevel: tempMapData['afluenceValue'] != null
                  ? tempMapData['afluenceValue']
                  : null,
              familyValues: tempMapData['familyValue'] != null
                  ? tempMapData['familyValue']
                  : null,
              motherName: tempMapData['motherName'] != null
                  ? tempMapData['motherName']
                  : '',
              fatherName: tempMapData['fatherName'] != null
                  ? tempMapData['fatherName']
                  : '',
              bloodGroup: tempMapData['bloodGroup'] != null
                  ? tempMapData['bloodGroup']
                  : '',
              healthInfo: tempMapData['healthInfo'] != null
                  ? tempMapData['healthInfo']
                  : '',
              srId: tempMapData['id'],
              visibility: tempMapData['visibility'] ?? "All Member",
              name: tempMapData['userName'],
              email: tempMapData['email'],
              id: id,
              employedIn: tempMapData['employedIn'] ?? "",
              marriedBrothers: tempMapData['marriedBrothers'],
              marriedSisters: tempMapData['marriedSisters'],
              phone: tempMapData['mobileNo'],
              gender: tempMapData['gender'],
              dateOfBirth: tempMapData['DateOfBirth'],
              religion: tempMapData['Religion'],
              annualIncome: tempMapData['annualIncome'],
              collegeAttended: tempMapData['clg'],
              workingAs: tempMapData['designation'],
              country: tempMapData['living'],
              highestQualification: tempMapData['qualification'],
              workingWith: tempMapData['workAt'],
              anyDisAbility: tempMapData['disability'],
              brothers: tempMapData['brotherCount'],
              sisters: tempMapData['sisterCount'],
              intro: tempMapData['intro'],
              manglik: tempMapData['maglik'],
              city: tempMapData['city'],
              fatherGautra: tempMapData['fatherGotra'],
              motherGautra: tempMapData['motherGotra'],
              diet: tempMapData['diet'],
              imageUrl: tempMapData['imageURL'],
              cityOfBirth: tempMapData['cityOfBirth'],
              employerName: tempMapData['employerName'],
              state: tempMapData['state'],
              residencyStatus: tempMapData['residency'],
              motherStatus: tempMapData['MotherStatus'],
              postedBy: tempMapData['ProfileFor'],
              nativePlace: tempMapData['nativePlace'],
              motherTongue: tempMapData['motherTongue'],
              community: tempMapData['Community'],
              fatherStatus: tempMapData['FatherStatus'],
              grewUpIn: tempMapData['grewUpIn'],
              familyType: tempMapData['familyType'],
              height: tempMapData['personHeight'],
              maritalStatus: tempMapData['maritalStatus'],
              noOfChildren: tempMapData['noOfChildren'],
              childrenLivingTogether: tempMapData['childrenLivingTogether'],
              dateOfCreated: DateTime.parse(tempMapData['DateTime']) ??
                  DateTime.now().subtract(Duration(days: 200)),
              fcmToken: tempMapData['fcm'] ?? '');
        }
      }
    }
    return userInformation;
  }

  Future<void> getAllUsers({gender,maxUser = 0}) async {
    if (allUsers.isNotEmpty) return;
    final mappedData;
    if(maxUser == 0){
      final data = gender != null
          ? await FirebaseDatabase.instance
          .reference()
          .child('User Information')
          .orderByChild("gender")
          .equalTo(gender)
          .once()
          : await FirebaseDatabase.instance
          .reference()
          .child('User Information')
          .once();

      mappedData = data.snapshot.value as Map;

    }else{
      final data = gender != null
          ? await FirebaseDatabase.instance
          .reference()
          .child('User Information')
          .orderByChild("gender")
          .equalTo(gender)
          .limitToFirst(maxUser)
          .once()
          : await FirebaseDatabase.instance
          .reference()
          .child('User Information')
          .once();

      mappedData = data.snapshot.value as Map;
    }


    print("Total Users: ${mappedData.length}");
    final verifiedData =
        await FirebaseDatabase.instance.reference().child('Gov Id').once();
    final verifiedMappedData = verifiedData.snapshot.value as Map;


    if (mappedData != null) {
      mappedData.forEach((key, value) {

        if(value.containsKey('inTrash') && (value['inTrash'] ?? false)){

        }else{
          if (value['isVerified'] != null && value['isVerified']) {

            final hideMap = value['hideProfile'] != null ? value['hideProfile'] as Map : null;
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

            if (!hide) {
              hide = (value['isSuspended'] ?? false) || (value['isVerificationRequired'] ?? false);
            }

            final dobMap = value['hideDob'] != null ? value['hideDob'] as Map : null;
            final mobileMap = value['hideMobile'] != null ? value['hideMobile'] as Map : null;

            bool hideMobile = false;
            bool showDob = false;
            if (dobMap != null)
              dobMap.forEach((key, value) {
                showDob = value ?? false;
              });
            if (mobileMap != null) {
              mobileMap.forEach((key, value) {

                if(key == "expireDate"){
                  DateTime tempDate = DateTime.parse(value);
                  if(DateTime.now().isBefore(tempDate) == false){
                    hideMobile = false;
                  }else{
                    hideMobile = true;
                  }
                }else{
                  hideMobile = false;
                }
                /*if(key == "mobile"){
              }else{
                hideMobile = false;
              }*/
              });
            }

            if (!hide) {
              var govData = verifiedMappedData[key];
              allUsers.add(
                UserInformation(
                    isGovIdVerified: govData != null ? govData['isVerified'] : false,
                    govVerifiedBy: govData != null ? govData['verifiedBy'] : "Adhar card",
                    hideProfile: hide,
                    hideContact: hideMobile,
                    hideDob: showDob,
                    birthTime: value['timeOfBirth'] != null ? splitData(value['timeOfBirth']) : TimeOfDay.now(),
                    verifiedBy: value['verifiedBy'] != null ? value['verifiedBy'] : null,
                    isPremium: value['isPremium'] != null ? value['isPremium'] : false,
                    isOnline: value['isOnline'] ?? false,
                    userStatus: value['LastActive'] != null
                        ? DateTime.parse(value['LastActive'].toString())
                        .difference(DateTime.now())
                        .inMinutes
                        .abs() <
                        30
                        ? 'Active'
                        : 'Inactive'
                        : 'Inactive',
                    showHoroscope: value['showHoroscope'] != null ? value['showHoroscope'] : true,
                    affluenceLevel: value['afluenceValue'] != null ? value['afluenceValue'] : null,
                    familyValues: value['familyValue'] != null ? value['familyValue'] : null,
                    motherName: value['motherName'] != null ? value['motherName'] : '',
                    fatherName: value['fatherName'] != null ? value['fatherName'] : '',
                    bloodGroup: value['bloodGroup'] != null ? value['bloodGroup'] : '',
                    healthInfo: value['healthInfo'] != null ? value['healthInfo'] : '',
                    srId: value['id'],
                    visibility: value['visibility'] ?? "All Member",
                    name: value['userName'],
                    email: value['email'],
                    id: key,
                    employedIn: value['employedIn'] ?? "",
                    marriedBrothers: value['marriedBrothers'],
                    marriedSisters: value['marriedSisters'],
                    phone: value['mobileNo'],
                    gender: value['gender'],
                    dateOfBirth: value['DateOfBirth'],
                    religion: value['Religion'],
                    annualIncome: value['annualIncome'],
                    collegeAttended: value['clg'],
                    workingAs: value['designation'],
                    country: value['living'],
                    highestQualification: value['qualification'],
                    workingWith: value['workAt'],
                    anyDisAbility: value['disability'],
                    brothers: value['brotherCount'],
                    sisters: value['sisterCount'],
                    intro: value['intro'],
                    manglik: value['maglik'],
                    city: value['city'],
                    fatherGautra: value['fatherGotra'],
                    motherGautra: value['motherGotra'],
                    diet: value['diet'],
                    imageUrl: value['imageURL'],
                    cityOfBirth: value['cityOfBirth'],
                    employerName: value['employerName'],
                    state: value['state'],
                    residencyStatus: value['residency'],
                    motherStatus: value['MotherStatus'],
                    postedBy: value['ProfileFor'],
                    nativePlace: value['nativePlace'],
                    motherTongue: value['motherTongue'],
                    community: value['Community'],
                    fatherStatus: value['FatherStatus'],
                    grewUpIn: value['grewUpIn'],
                    familyType: value['familyType'],
                    height: value['personHeight'],
                    maritalStatus: value['maritalStatus'],
                    noOfChildren: value['noOfChildren'],
                    childrenLivingTogether: value['childrenLivingTogether'],
                    dateOfCreated: DateTime.parse(value['DateTime']) ??
                        DateTime.now().subtract(Duration(days: 200)),
                    clickCount: value['clickCount'] ?? 0,
                    fcmToken: value['fcm'] ?? ''
                ),
              );
            }
          }
        }

      });

      allUsers.removeWhere(
          (element) => element.id == FirebaseAuth.instance.currentUser!.uid);

      unremovedUsers = [...allUsers];
      allUsers.shuffle();
    }
  }

  Future<void> getExploreUsers() async {
    if (exploreUsers.length != 0) return;
    final data = await FirebaseDatabase.instance
        .reference()
        .child('User Information')
        .once();

    final mappedData = data.snapshot.value as Map;
    print("Total Users: ${mappedData.length}");

    final verifiedData =
        await FirebaseDatabase.instance.reference().child('Gov Id').once();
    final verifiedMappedData = verifiedData.snapshot.value as Map;

    if (mappedData != null) {
      mappedData.forEach((key, value) {
        if (value['isVerified'] != null && value['isVerified']) {
          final hideMap =
              value['hideProfile'] != null ? value['hideProfile'] as Map : null;
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
          if (!hide) {
            hide = (value['isSuspended'] ?? false) ||
                (value['isVerificationRequired'] ?? false);
          }
          //  PremiumModel primium = getPrimium(key);
          final dobMap =
              value['hideDob'] != null ? value['hideDob'] as Map : null;
          final mobileMap =
              value['hideMobile'] != null ? value['hideMobile'] as Map : null;

          bool hideMobile = false;
          bool showDob = false;
          if (dobMap != null)
            dobMap.forEach((key, value) {
              showDob = value ?? false;
            });
          if (mobileMap != null) {
            mobileMap.forEach((key, value) {
              //hideMobile = value;
              if(key == "expireDate"){
                DateTime tempDate = DateTime.parse(value);
                if(DateTime.now().isBefore(tempDate) == false){
                  hideMobile = false;
                }else{
                  hideMobile = true;
                }
              }else{
                hideMobile = false;
              }
            });
          }
          // log(dobMap.toString());
          if (!hide) {
            var govData = verifiedMappedData[key];
            exploreUsers.add(
              UserInformation(
                  isGovIdVerified:
                      govData != null ? govData['isVerified'] : false,
                  govVerifiedBy:
                      govData != null ? govData['verifiedBy'] : "Adhar card",
                  hideProfile: hide,
                  hideContact: hideMobile,
                  hideDob: showDob,
                  birthTime: value['timeOfBirth'] != null ? splitData(value['timeOfBirth']) : TimeOfDay.now(),
                  verifiedBy:
                      value['verifiedBy'] != null ? value['verifiedBy'] : null,
                  isPremium:
                      value['isPremium'] != null ? value['isPremium'] : false,
                  isOnline: value['isOnline'] ?? false,
                  userStatus: value['LastActive'] != null
                      ? DateTime.parse(value['LastActive'].toString())
                                  .difference(DateTime.now())
                                  .inMinutes
                                  .abs() <
                              30
                          ? 'Active'
                          : 'Inactive'
                      : 'Inactive',
                  showHoroscope: value['showHoroscope'] != null
                      ? value['showHoroscope']
                      : true,
                  affluenceLevel: value['afluenceValue'] != null
                      ? value['afluenceValue']
                      : null,
                  familyValues: value['familyValue'] != null
                      ? value['familyValue']
                      : null,
                  motherName:
                      value['motherName'] != null ? value['motherName'] : '',
                  fatherName:
                      value['fatherName'] != null ? value['fatherName'] : '',
                  bloodGroup:
                      value['bloodGroup'] != null ? value['bloodGroup'] : '',
                  healthInfo:
                      value['healthInfo'] != null ? value['healthInfo'] : '',
                  srId: value['id'],
                  visibility: value['visibility'] ?? "All Member",
                  name: value['userName'],
                  email: value['email'],
                  id: key,
                  employedIn: value['employedIn'] ?? "",
                  marriedBrothers: value['marriedBrothers'],
                  marriedSisters: value['marriedSisters'],
                  phone: value['mobileNo'],
                  gender: value['gender'],
                  dateOfBirth: value['DateOfBirth'],
                  religion: value['Religion'],
                  annualIncome: value['annualIncome'],
                  collegeAttended: value['clg'],
                  workingAs: value['designation'],
                  country: value['living'],
                  highestQualification: value['qualification'],
                  workingWith: value['workAt'],
                  anyDisAbility: value['disability'],
                  brothers: value['brotherCount'],
                  sisters: value['sisterCount'],
                  intro: value['intro'],
                  manglik: value['maglik'],
                  city: value['city'],
                  fatherGautra: value['fatherGotra'],
                  motherGautra: value['motherGotra'],
                  diet: value['diet'],
                  imageUrl: value['imageURL'],
                  cityOfBirth: value['cityOfBirth'],
                  employerName: value['employerName'],
                  state: value['state'],
                  residencyStatus: value['residency'],
                  motherStatus: value['MotherStatus'],
                  postedBy: value['ProfileFor'],
                  nativePlace: value['nativePlace'],
                  motherTongue: value['motherTongue'],
                  community: value['Community'],
                  fatherStatus: value['FatherStatus'],
                  grewUpIn: value['grewUpIn'],
                  familyType: value['familyType'],
                  height: value['personHeight'],
                  maritalStatus: value['maritalStatus'],
                  noOfChildren: value['noOfChildren'],
                  childrenLivingTogether: value['childrenLivingTogether'],
                  dateOfCreated: DateTime.parse(value['DateTime']) ??
                      DateTime.now().subtract(Duration(days: 200)),
                  fcmToken: value['fcm'] ?? ''),
            );
          }
        }
      });
    }
  }

  removeSameGender(String gender) {
    allUsers.removeWhere((element) => element.gender == gender);
    notifyListeners();
  }

  removeBlockedByUsers(List blockedBy) {
    allUsers.removeWhere((element) => blockedBy.contains(element.id));
    notifyListeners();
  }

  splitData(String time) {
    if (time != null) {
      try {
        List t = time.split('');
        log(t.toString());
        int hr = int.parse(t[10]) * 10 + int.parse(t[11]);
        int minute = int.parse(t[13]) * 10 + int.parse(t[14]);
        //  log(TimeOfDay(hour: hr, minute: minute).toString());

        return TimeOfDay(hour: hr, minute: minute);
      } catch (e) {
        return null;
      }
    } else
      return null;
  }

  getPrimium(String key) async {
    final premi = await FirebaseDatabase.instance
        .reference()
        .child('ActiveMembership')
        .child(key)
        .once();
    PremiumModel premiumValues;
    Map tempMapData = premi.snapshot.value as Map;
    if (tempMapData.isNotEmpty) {
      premiumValues = PremiumModel(
          dateOfPerchase: DateTime.parse(tempMapData['DateOfPerchase']),
          validTill: DateTime.parse(tempMapData['ValidTill']),
          contact: tempMapData['contacts'],
          name: tempMapData['name'],
          packageName: tempMapData['packageName'],
          isActive: tempMapData['ValidTill'] != null
              ? (DateTime.parse(tempMapData['ValidTill'])
                          .compareTo(DateTime.now()) >
                      0)
                  ? true
                  : false
              : false);

      return premiumValues;
    } else {
      premiumValues = PremiumModel();
      return premiumValues;
    }
  }

  UserInformation searchedUser(String id) {
    UserInformation user = allUsers.firstWhere((element) => element.id == id);
    return user;
  }
}
