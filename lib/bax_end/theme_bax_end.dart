import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    outline: Color(0xFFD9D9D9),
    shadow: Colors.black,
    primary: Color(0xFF3ACF72),
    secondary: Color(0xFF83BF4F),
    tertiary: Color(0xFF022000)
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 53, 53, 53),
    outline: Color(0xFFD9D9D9),
    shadow: Colors.white,
    primary: Color(0xFF384A37),
    secondary: Color(0xFF4C6D2F),
    tertiary: Color(0xFF011200)
  )
);

class ThemeSelector with ChangeNotifier {
  ThemeData theme = lightMode;

  ThemeData get themeData => theme;

  set themeData(ThemeData themeData) {
    theme = themeData;
    notifyListeners();
  }

  void toggle() {
    if(theme == lightMode) themeData = darkMode;
    else themeData = lightMode;
  }
}

