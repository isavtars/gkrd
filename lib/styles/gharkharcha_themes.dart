//making things of appa

import 'package:flutter/material.dart';

import 'color.dart';

class GkThemsData {
  static final lightTheme = ThemeData(
  
    canvasColor: kCardColor,
    textTheme: const TextTheme(
        bodyLarge: TextStyle(color: kFontBlackC),
        bodyMedium: TextStyle(color: kFontBlackC),
        bodySmall: TextStyle(color: kFontBlackC)),
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    primaryColor: kGreenColor,
    colorScheme: const ColorScheme.light(),
    cardColor: kCardColor,
    inputDecorationTheme: InputDecorationTheme(
      hoverColor: kGreenColor,
      focusColor: kTextFieldColor,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kTextFieldBorderC),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kTextFieldBorderC),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  //darkThem
  static final darkTheme = ThemeData(
      canvasColor: kDarkCardC,
      datePickerTheme: const DatePickerThemeData(
          todayBorder: BorderSide(color: kDarkGreenColor),
          rangePickerSurfaceTintColor: kDarkGreenColor),
      scaffoldBackgroundColor: kDarkScaffoldC,
      colorScheme: const ColorScheme.dark(),
      cardColor: kDarkCardC,
      primaryColor: kDarkGreenColor,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
          hoverColor: kDarkGreenColor,
          focusColor: kDarkGreenColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          )));

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
