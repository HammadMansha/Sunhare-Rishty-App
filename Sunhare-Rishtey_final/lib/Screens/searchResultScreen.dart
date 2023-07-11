import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrimonial_app/Providers/adsProvider.dart';
import 'package:matrimonial_app/Providers/ContactsProvider.dart';
import 'package:matrimonial_app/Providers/favouriteUserProvider.dart';
import 'package:matrimonial_app/customs/widgets/PersonCard.dart';
import 'package:matrimonial_app/models/advertisementModel.dart';
import 'package:provider/provider.dart';

import '/Providers/getUserInfo.dart';
import '/main.dart';
import '/models/UserModel.dart';

class SearchResultScreen extends StatefulWidget {
  final Map requestStatus;
  final List<UserInformation> filteredUsers;
  SearchResultScreen({required this.filteredUsers, required this.requestStatus});
  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  bool isPremium = false;
  bool isMatch = true;

  Future increaseContactAndUpdate(String id) async {
    FirebaseDatabase.instance
        .reference()
        .child('Contacts viewed')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({'$id': true});
  }

  showPopUp(String id) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Container(
                child: Text(
                    'Do you really wants to use your one cotanct to see .'),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    increaseContactAndUpdate(id).then((value) {
                      // contacts.add(id);

                      Provider.of<ContactProvider>(context, listen: false)
                          .addContacts(id);
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(msg: 'Contact Unlocked');
                    });
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            ));
  }

  void _showPopupMenu(double width, double height, List<PopupMenuEntry> popupItem) async {
    await showMenu(
      color: Colors.black,
      context: context,
      position: RelativeRect.fromLTRB(
          width * .1, height * .57, width * .8, height * .08),
      items: popupItem,
      elevation: 8.0,
    );
  }

  List<String> favIds = [];
  List<String> contacts = [];
  UserInformation userInfo = UserInformation();
  List<AdvertisementModel> nativeAdsList = [];
  int adAt = 5;

  @override
  void initState() {
    // adAt = random(startIndex, endIndex);
    List<AdvertisementModel> temp =
        Provider.of<AdsProvider>(context, listen: false).nativeAdsList;
    if (temp.length != 0) {
      temp.shuffle();
      int total = 100 ~/ temp.length;
      for (int i = 0; i < total; i++) {
        nativeAdsList.addAll(temp);
      }
    }
    userInfo = Provider.of<CurrUserInfo>(context, listen: false).currentUser;
    favIds = Provider.of<FavUsers>(context, listen: false).favUserIds;
    isPremium = userInfo.isPremium ?? false;
    contacts = Provider.of<ContactProvider>(context, listen: false).contacts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Results'),
          backgroundColor: theme.colorCompanion,
        ),
        body: matches());
  }

  Map requestStatus = {};
  getRequests() async {
    FirebaseDatabase.instance
        .reference()
        .child('userReq')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        requestStatus = event.snapshot.value as Map;
        setState(() {});
      }
    });
  }

  random(min, max) {
    return min + Random().nextInt(max - min);
  }

  int startIndex = 5, endIndex = 8;

  matches() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height * .9,
      child: widget.filteredUsers.length == 0
          ? Container(
              child: Center(
                child: Container(
                  child: Text(
                    'No New Matches as of now !',
                    style: theme.text12bold,
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: widget.filteredUsers.length,
              itemBuilder: (context, index) {
                List<PopupMenuItem> popupItem = [];
                popupItem = [];
                if (widget.filteredUsers[index].verifiedBy != null) {
                  popupItem.add(
                    PopupMenuItem(
                        child: Text(
                          widget.filteredUsers[index].verifiedBy ?? "",
                          style: TextStyle(color: Colors.white),
                        ),
                        value: 'verify'),
                  );
                }

                AdvertisementModel? ad = AdvertisementModel();
                if ((index + 1) % adAt == 0) {
                  ad = nativeAdsList[index ~/ adAt];
                }

                return PersonCard(
                  user: widget.filteredUsers[index],
                  users: widget.filteredUsers,
                  currentUserInfo: userInfo,
                  isFavourite: favIds.contains(widget.filteredUsers[index].id),
                  isRequestSent: requestStatus.keys
                      .contains(widget.filteredUsers[index].id),
                  index: index,
                  ad: ad!,
                );
              },
            ),
    );
  }
}
