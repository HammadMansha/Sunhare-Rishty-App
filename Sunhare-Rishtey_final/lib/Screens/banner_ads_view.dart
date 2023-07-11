import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrimonial_app/main.dart';

import 'Splash.dart';

class BannerAdView extends StatefulWidget {
  @override
  _BannerAdViewState createState() => _BannerAdViewState();
}

class _BannerAdViewState extends State<BannerAdView> {
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: bannerID,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    if(isBannerShowAds){
    _createBottomBannerAd();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: _isBottomBannerAdLoaded
          ? Container(
        height: _bottomBannerAd.size.height.toDouble(),
        width: _bottomBannerAd.size.width.toDouble(),
        child: AdWidget(ad: _bottomBannerAd),
      )
          : SizedBox(),
    );
  }
}