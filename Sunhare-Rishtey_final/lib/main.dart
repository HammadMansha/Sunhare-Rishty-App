import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrimonial_app/Providers/BlockedUsersProvider.dart';
import 'package:matrimonial_app/Providers/adsProvider.dart';
import 'package:matrimonial_app/Providers/hideProvider.dart';
import 'package:matrimonial_app/Providers/UserRequestProvider.dart';
import 'package:matrimonial_app/Screens/AcceptInvitationScreen.dart';
import 'package:matrimonial_app/Screens/OtpScreenNewUser.dart';
import 'package:provider/provider.dart';
import '/Config/theme.dart';
import '/Providers/allUser.dart';
import '/Providers/ContactsProvider.dart';
import '/Providers/favouriteUserProvider.dart';
import '/Providers/getUserInfo.dart';
import '/Providers/mobilenoProvider.dart';
import '/Providers/imagesProvider.dart';
import '/Providers/UserProvider.dart';
import '/Screens/Splash.dart';

AppThemeData theme = AppThemeData();

int firstPageCompleted = 16;
int secondPageCompleted = 14;
int thirdPageCompleted = 20;
int fourthPageCompleted = 18;
int fifthPageCompleted = 18;

int totalProfileCompleted = 88;

int percentAdd = 2;

// for intertitial
InterstitialAd? interstitial;
int numInterstitialLoadAttempts = 0;
const int maxFailedLoadAttempts = 3;


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          statusBarColor: theme.colorCompanion
        ),
  );

  theme.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CurrUserInfo(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppThemeData(),
        ),
        ChangeNotifierProvider(
          create: (_) => AllUser(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserRequestProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Mobileno(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ImageListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavUsers(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContactProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HideProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BlockedUsersProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sunhare Rishtey',
      home: SplashScreen(),
      // home: AcceptInvitationScreen(),
    );
  }
}
