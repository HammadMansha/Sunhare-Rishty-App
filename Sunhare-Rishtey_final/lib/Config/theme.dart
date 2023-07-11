import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppThemeData extends ChangeNotifier {
  // Dark mode flag
  //
  bool darkMode = false;
  //
  // colors
  //
  Color colorGrey = Color.fromARGB(255, 209, 210, 205);

  // Color colorPrimary = Color(0xff009688);
  Color colorPrimary = HexColor('FF1557');
  Color colorCompanion = HexColor('F31654');
  Color colorCompanion2 = HexColor('7E4288');
  Color colorCompanion3 = HexColor('7E4288');
  Color colorCompanion4 = HexColor('B760C8');
  Color chatsend = HexColor('D9F8C4');
  Color chatrevieve = HexColor('E8E8E8');
  Color chatbg = HexColor('B760C8');
  Color status = HexColor('00eaff');

  Color? colorBackground;
  Color? colorBackgroundGray;
  Color? colorDefaultText;
  Color? colorBackgroundDialog;
  MaterialColor? primarySwatch;
  List<Color> colorsGradient = [];
  Color colorDarkModeLight =
      Color.fromARGB(255, 40, 40, 40); // for dialog background in dark mode

  //
  TextStyle? text10white;
  TextStyle? text12;
  TextStyle? text12bold;
  TextStyle? text12grey;
  TextStyle? text14;
  TextStyle? text14primary;
  TextStyle? text14purple;
  TextStyle? text14grey;
  TextStyle? text14bold;
  TextStyle? text14boldPimary;
  TextStyle? text14boldWhite;
  TextStyle? text14boldWhiteShadow;
  TextStyle? text16;
  TextStyle? text16bold;
  TextStyle? text16boldWhite;
  TextStyle? text16Primary;
  TextStyle? text16boldPrimary;
  TextStyle? text18boldPrimary;
  TextStyle? text18bold;
  TextStyle? text20;
  TextStyle? text20bold;
  TextStyle? text20boldPrimary;
  TextStyle? text20boldWhite;
  TextStyle? text20negative;
  TextStyle? text22primaryShadow;

  changeDarkMode() {
    darkMode = !darkMode;
    init();
    notifyListeners();
  }

  init() {
    if (darkMode) {
      colorBackground = _backgroundDarkColor;
      colorDefaultText = _backgroundColor;
      colorBackgroundGray = Colors.white.withOpacity(0.1);
      primarySwatch = black;
      colorBackgroundDialog = colorDarkModeLight;
      Color _color2 = Color.fromARGB(80, 80, 80, 80);
      colorsGradient = [_color2, Colors.black];
    } else {
      Color _color2 = Color.fromARGB(
          80, colorPrimary.red, colorPrimary.green, colorPrimary.blue);
      colorsGradient = [_color2, colorPrimary];
      colorBackgroundDialog = _backgroundColor;
      colorBackgroundGray = Colors.black.withOpacity(0.01);
      colorBackground = _backgroundColor;
      colorDefaultText = _backgroundDarkColor;
      primarySwatch = white;
    }

    text10white = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 10,
    );

    text12 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    text12bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 12,
    );

    text12grey = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    text14 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14primary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14purple = TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
    text14bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14boldPimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14grey = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14boldWhiteShadow = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 14,
        shadows: [
          Shadow(offset: Offset(1, 1), color: Colors.black, blurRadius: 1),
        ]);

    text16bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    text16Primary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    text16boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text18boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text18bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text20bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text20boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20negative = TextStyle(
      // text negative color
      color: colorBackground,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text22primaryShadow = TextStyle(
        // text negative color
        color: colorPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 22,
        shadows: [
          Shadow(offset: Offset(1, 1), color: Colors.black, blurRadius: 1),
        ]);
  }
}

//
// Colors
//
var _backgroundColor = Colors.white;
var _backgroundDarkColor = Colors.black;

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

const MaterialColor black = const MaterialColor(
  0xFF000000,
  const <int, Color>{
    50: const Color(0xFF000000),
    100: const Color(0xFF000000),
    200: const Color(0xFF000000),
    300: const Color(0xFF000000),
    400: const Color(0xFF000000),
    500: const Color(0xFF000000),
    600: const Color(0xFF000000),
    700: const Color(0xFF000000),
    800: const Color(0xFF000000),
    900: const Color(0xFF000000),
  },
);
