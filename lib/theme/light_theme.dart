import 'package:flutter/material.dart';
import 'package:user_app/util/color_resources.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Rubik',
  primaryColor: Color(0xFF003E47),
  secondaryHeaderColor: Color(0xFFCFEC7E),
  highlightColor: Color(0xFF003E47),
  backgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white,selectedItemColor: ColorResources.themeLightBackgroundColor),

);