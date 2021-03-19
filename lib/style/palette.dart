import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Palette {
  const Palette();

  static const Color mainColor = const Color(0xFF151C26);
  static const Color secondColor = const Color(0xFFf4C10F);
  static const Color titleColor = const Color(0xFF5a606b);
  static const Color whiteText = const Color(0xFFFFFFFF);
  static const Color pinkBox = const Color(0xFFA88499);
  static const Color greyBox = const Color(0xFFECE6E6);
  static const Color lightPink = const Color(0xFFECE6E6);
  static const Color pinkText = const Color(0xFF745C6A);
  static const Color blurColor = const Color(0xFFF5F2EF);
  static const Color starColor = const Color(0xFFE2E2E2);
  static const Color greyText = const Color(0xFFAFAFAF);
  static const Color buttonWhite = const Color(0xFFF5F5F5);
  static const Color balckColor = const Color(0xFF000000);
  static const Color labelColor = const Color(0xFF95989A);
  static const Color textField = const Color(0xFFFAF8F7);
  static const Color moreLightPink = const Color(0xFFE7DFE1);
  static const Color boxWhite = const Color(0xFFFAFAFA);
  static const Color rose = const Color.fromRGBO(247, 127, 151, 0.67);
  static const Color blur = const Color.fromRGBO(137, 137, 137, 0.92);
  static const Color darkPink = const Color(0xFF725365);
  static const Color textGrey = const Color(0xFF868686);


  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      //* Custom Google Font
      //  fontFamily: Devfest.google_sans_family,
      primarySwatch: Colors.red,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,

      backgroundColor: isDarkTheme ? Colors.black : Color(0xFFF5F2EF),

      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),

      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),

      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),

      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      // cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme
          .of(context)
          .buttonTheme
          .copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}
