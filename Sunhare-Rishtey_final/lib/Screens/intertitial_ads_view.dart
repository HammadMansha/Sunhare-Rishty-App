import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrimonial_app/main.dart';

import 'Splash.dart';

class IntertitialAdsView {

static final AdRequest request = AdRequest(
  keywords: <String>['foo', 'bar'],
  contentUrl: 'http://foo.com/bar.html',
  nonPersonalizedAds: true,
);

void createInterstitialAd() {
  InterstitialAd.load(
      adUnitId: interID,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          interstitial = ad;
          numInterstitialLoadAttempts = 0;
          interstitial!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          numInterstitialLoadAttempts += 1;
          interstitial = null;
          if (numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ));
}

void showInterstitialAd() {
  if (interstitial == null) {
    print('Warning: attempt to show interstitial before loaded.');
    return;
  }
  interstitial!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
        print('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
      createInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createInterstitialAd();
    },
  );
      interstitial!.show();
      interstitial = null;
  }
}
