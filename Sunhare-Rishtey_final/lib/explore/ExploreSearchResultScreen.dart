import 'dart:math';

import 'package:flutter/material.dart';
import 'package:matrimonial_app/Providers/adsProvider.dart';
import 'package:matrimonial_app/models/advertisementModel.dart';
import 'package:provider/provider.dart';

import '/main.dart';
import '/models/UserModel.dart';
import 'ExplorePersonCard.dart';

class ExploreSearchResultScreen extends StatefulWidget {
  final List<UserInformation> filteredUsers;
  ExploreSearchResultScreen({required this.filteredUsers});
  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<ExploreSearchResultScreen> {
  UserInformation userInfo = UserInformation();
  List<AdvertisementModel> nativeAdsList = [];

  @override
  void initState() {
    Provider.of<AdsProvider>(context, listen: false).getAds().then((value) {
      List<AdvertisementModel> temp =
          Provider.of<AdsProvider>(context, listen: false).nativeAdsList;
      temp.removeWhere((element) => element == null);
      int totalAds = temp.length;
      if (totalAds != 0) {
        temp.shuffle();
        int total = 100 ~/ totalAds;
        for (int i = 0; i < total; i++) {
          nativeAdsList.addAll(temp);
        }
      }
      setState(() {});
    });
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

  random(min, max) {
    return min + Random().nextInt(max - min);
  }

  int adAt = 5;
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
                  int currentAd = index ~/ adAt;
                  if (currentAd < nativeAdsList.length &&
                      nativeAdsList != null &&
                      nativeAdsList.length != 0) {
                    ad = nativeAdsList.elementAt(currentAd);
                  }
                }

                return ExplorePersonCard(
                    user: widget.filteredUsers[index], index: index, ad: ad!);
              },
            ),
    );
  }
}
