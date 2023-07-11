import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrimonial_app/main.dart';

import 'Splash.dart';

class NativeAdsView extends StatefulWidget {
  const NativeAdsView({super.key});

  @override
  State<NativeAdsView> createState() => _NativeAdsViewState();
}

class _NativeAdsViewState extends State<NativeAdsView> {
  NativeAd? _ad;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _ad = NativeAd(
      adUnitId: nativeID,
      // factoryId: 'listTileMedium',
      request: const AdRequest(),
      listener: NativeAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          var _add = ad as NativeAd;
          print("**** AD ***** ${_add.responseInfo}");
          setState(() {
            _ad = _add;
            isAdLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
        // Called when a click is recorded for a NativeAd.
        onAdClicked: (Ad ad) => print('Ad clicked.'),
      ),
    );
    _ad!.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ad != null && isAdLoaded
        ? Container(
      height: 55.0,
      alignment: Alignment.center,
      child: AdWidget(ad: _ad!),
    )
        : Container(
      height: 55,
    );
  }
}