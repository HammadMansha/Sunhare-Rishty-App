import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/models/advertisementModel.dart';

class AdsProvider with ChangeNotifier {
  List<AdvertisementModel> interestialAdsList = [];
  List<AdvertisementModel> bannerAdsList = [];
  List<AdvertisementModel> nativeAdsList = [];

  Future<void> getAds() async {
    final requests = await FirebaseDatabase.instance
        .reference()
        .child('Advertisement')
        .once();
    final mappedData = requests.snapshot.value as Map;
    if (mappedData != null) {
      mappedData.forEach((key, value) {


        if(value['Expiry'] != null){
          DateTime tempDate = DateTime.parse(value['Expiry']);
          if(DateTime.now().isBefore(tempDate) == true && value['status']){
              var adModel = AdvertisementModel(
                title: value['title'],
                image: value['imageURL'],
                months: value['months'],
                dateCreated: DateTime.parse(value['createdOn']),
              );
              switch (value['adType'] ?? "Interstitial") {
                case "Banner":
                  {
                    bannerAdsList.add(adModel);
                    break;
                  }
                case "Native":
                  {
                    nativeAdsList.add(adModel);
                    break;
                  }
                default:
                  {
                    interestialAdsList.add(adModel);
                  }
              }
          }
        } else{
          if (value['status'] != null && value['status']) {
            var adModel = AdvertisementModel(
              title: value['title'],
              image: value['imageURL'],
              months: value['months'],
              dateCreated: DateTime.parse(value['createdOn']),
            );
            switch (value['adType'] ?? "Interstitial") {
              case "Banner":
                {
                  bannerAdsList.add(adModel);
                  break;
                }
              case "Native":
                {
                  nativeAdsList.add(adModel);
                  break;
                }
              default:
                {
                  interestialAdsList.add(adModel);
                }
            }
          }
        }
      });
    }

  }

}
