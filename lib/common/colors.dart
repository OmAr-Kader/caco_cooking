import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color mainColor = Color.fromRGBO(143, 148, 251, 1); // Color(0xFF89dad0)
const Color mainTxtColor = Colors.white; // Color(0xFF89dad0)

const Color iconColor1 = Color(0xFFffd28d);
const Color iconColor2 = Color(0xFFfcab88);

//const Color iconColor3 = Color(0xffb26d4f)
const Color iconColor3 = Color(0xffb26d4f);
const Color goldColor = Color.fromARGB(255, 255, 215, 0);

const Color textColorDark = Colors.white;
const Color textColor = Colors.black;

const Color smallTextColorDark = Colors.white70;
const Color smallTextColor = Color(0xB3000000);


bool isTooDark(Color color) {
  double darkness = 1 - (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  if (darkness < 0.5) {
    return false; // It's a light color
  } else {
    return true; // It's a dark color
  }
}

bool get isDarkMode => WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

Color get findTextColor {
  if (isDarkMode) {
    return smallTextColorDark;
  } else {
    return smallTextColor;
  }
}

List<Color> get findGradientColors {
  if (isDarkMode) {
    return [
      const Color.fromRGBO(255, 255, 255, 1.0),
      const Color.fromRGBO(220, 220, 220, 0.6),
    ];
  } else {
    return [
      const Color.fromRGBO(0, 0, 0, 1.0),
      const Color.fromRGBO(25, 25, 25, 0.6),
    ];
  }
}

Color get hintColor {
  if (isDarkMode) {
    return smallTextColor;
  } else {
    return smallTextColorDark;
  }
}

Color get hintColorFull {
  if (isDarkMode) {
    return Colors.black;
  } else {
    return Colors.grey;
  }
}

resetStatusBar() {
  if (isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, // optional
      statusBarIconBrightness: Brightness.light, // Dark == white status bar -- for IOS.
    ));
  } else {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // optional
      statusBarIconBrightness: Brightness.dark, // Dark == white status bar -- for IOS.
    ));
  }
}

TextStyle largeTextStyle(BuildContext context, double size, Color? col) {
  if (isDarkMode) {
    return TextStyle(fontSize: size, fontWeight: FontWeight.w400, fontFamily: 'Roboto', color: col ?? textColorDark);
  } else {
    return TextStyle(fontSize: size, fontWeight: FontWeight.w400, fontFamily: 'Roboto', color: col ?? textColor);
  }
}

TextStyle largeMainTextStyle(BuildContext context, double size) {
  if (isDarkMode) {
    return TextStyle(fontSize: size, fontWeight: FontWeight.w400, fontFamily: 'Roboto', color: mainColor);
  } else {
    return TextStyle(fontSize: size, fontWeight: FontWeight.w400, fontFamily: 'Roboto', color: mainColor);
  }
}

TextStyle smallTextStyle(BuildContext context, double size) {
  if (isDarkMode) {
    return TextStyle(fontSize: size, fontFamily: 'Hind', height: 1.2, color: smallTextColorDark);
  } else {
    return TextStyle(fontSize: size, fontFamily: 'Hind', height: 1.2, color: smallTextColor);
  }
}

SizedBox forCachLoad(double circleDim) {
  return SizedBox(
    width: circleDim,
    height: circleDim,
    child: const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(mainColor)
        )),
  );
}