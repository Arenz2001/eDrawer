import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color mainColor = Color.fromARGB(255, 32, 32, 32);
  static const Color secondaryColor = Color.fromARGB(250, 51, 53, 51);
  static const Color detailsColor = Color.fromARGB(255, 255, 209, 0);
  static const Color lightGreyColor = Color.fromARGB(255, 214, 214, 214);
  static const Color textColor = Color.fromARGB(255, 255, 255, 255);

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Baloo2',
    scaffoldBackgroundColor: mainColor,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      color: lightGreyColor,
      titleTextStyle: TextStyle(color: mainColor),
      iconTheme: IconThemeData(
        color: mainColor,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: textColor,
      foregroundColor: mainColor,
    ),
    //colorScheme: const ColorScheme.dark(primary: mainColor, secondary: textColor, tertiary: detailsColor),
    inputDecorationTheme: InputDecorationTheme(
        //focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 0.5, color: textColor)),
        //enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2.0, color: textColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(color: textColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: textColor)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: detailsColor),
        ),
        hintStyle: const TextStyle(color: textColor)),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: detailsColor,
      cursorColor: detailsColor,
      selectionHandleColor: detailsColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: secondaryColor,
      foregroundColor: textColor,
    )),
  );

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Baloo2',
    scaffoldBackgroundColor: textColor,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      color: mainColor,
      iconTheme: IconThemeData(
        color: lightGreyColor,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: mainColor,
      foregroundColor: textColor,
    ),
    //colorScheme: const ColorScheme.light(primary: textColor, secondary: mainColor, onBackground: detailsColor),
    inputDecorationTheme: InputDecorationTheme(
        //focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 0.5, color: textColor)),
        //enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2.0, color: textColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(color: mainColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: mainColor)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: detailsColor),
        ),
        hintStyle: const TextStyle(color: mainColor)),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: detailsColor,
      cursorColor: mainColor,
      selectionHandleColor: mainColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: lightGreyColor,
      foregroundColor: mainColor,
    )),
  );
}
