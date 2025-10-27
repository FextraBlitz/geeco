import 'package:flutter/material.dart';

ThemeData lightMode()  {
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      outline: Color(0xFFD9D9D9),
      shadow: Colors.black,
      primary: Color(0xFF3ACF72),
      secondary: Color(0xFF83BF4F),
      tertiary: Color(0xFF022000),
    )
  );
}

ThemeData darkMode() {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: const Color.fromARGB(255, 53, 53, 53),
      outline: Color(0xFFD9D9D9),
      shadow: Colors.black,
      primary: Color(0xFF384A37),
      secondary: Color(0xFF4C6D2F),
      tertiary: Color(0xFF036603),
    )
  );
}

class ThemeSelector extends ChangeNotifier {
  bool _isDark = false;

  ThemeData theme = lightMode();

  ThemeData get themeData => _isDark ? darkMode() : lightMode();

  set themeData(ThemeData themeData) {
    theme = themeData;
  }

  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

