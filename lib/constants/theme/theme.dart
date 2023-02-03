import 'package:flutter/material.dart';

class MyTheme {
  static const Color textColor = Color.fromARGB(0xFF, 215, 215, 215);
  static const Color lighterAccentColor = Color.fromARGB(255, 208, 135, 230);
  static const Color backColor = Color.fromARGB(0xFF, 25, 25, 30);
  static const Color accentBackColor = Color.fromARGB(0xFF, 20, 20, 25);
  static const Color lighterAccentBackColor = Color.fromARGB(0xFF, 35, 35, 40);
  static const Color darkTextColor = Color.fromARGB(0xFF, 75, 75, 85);
  static const Color darkerAccentColor = Color.fromARGB(255, 105, 18, 120);

  static ThemeData global = ThemeData(
    fontFamily: 'Baloo2',
    primarySwatch: Colors.purple,
    primaryColorDark: Colors.purple.shade100,
    scaffoldBackgroundColor: backColor,
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: textColor,
      ),
      headline4: TextStyle(
        color: textColor,
      ),
      bodyText2: TextStyle(
        color: textColor,
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      elevation: 0.2,
      backgroundColor: accentBackColor,
      indicatorColor: darkerAccentColor,
      labelType: NavigationRailLabelType.selected,
      selectedIconTheme: IconThemeData(color: Colors.purple.shade50, opacity: 1, size: 24),
      unselectedIconTheme: IconThemeData(color: Colors.purple.shade50, opacity: 1, size: 24),
      selectedLabelTextStyle: TextStyle(color: Colors.purple.shade200),
    ),
    useMaterial3: true,
    backgroundColor: backColor,
    hintColor: textColor,
  );
}
