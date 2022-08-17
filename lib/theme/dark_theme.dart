import 'package:flutter/material.dart';
import 'package:user_app/util/color_resources.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: Color(0xFF689da7),
  brightness: Brightness.dark,
  secondaryHeaderColor: Color(0xFFaaa818),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.black, selectedItemColor: ColorResources.themeDarkBackgroundColor),
);
