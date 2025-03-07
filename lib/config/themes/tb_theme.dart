import 'package:flutter/material.dart';
import 'package:thingsboard_app/utils/transition/page_transitions.dart';

const int _tbPrimaryColorValue = 0xFFE02129; // Updated Primary Color
const Color _tbPrimaryColor = Color(_tbPrimaryColorValue);
const Color _tbSecondaryColor = Color(0xFFE53935); // Updated Secondary Color
const Color _tbDarkPrimaryColor = Color(0xFFE53935);

const int _tbTextColorValue = 0xFF282828;
const Color _tbTextColor = Color(_tbTextColorValue);

var tbTypography = Typography.material2018();

const tbMatIndigo = MaterialColor(
  _tbPrimaryColorValue,
  <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: _tbPrimaryColor,
    600: _tbSecondaryColor,
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  },
);

const tbDarkMatIndigo = MaterialColor(
  _tbPrimaryColorValue,
  <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: _tbDarkPrimaryColor,
    600: _tbSecondaryColor,
    700: Color(0xFFD32F2F),
    800: _tbPrimaryColor,
    900: Color(0xFFB71C1C),
  },
);

final ThemeData theme = ThemeData(primarySwatch: tbMatIndigo);

ThemeData tbTheme = ThemeData(
  useMaterial3: false,
  primarySwatch: tbMatIndigo,
  colorScheme: theme.colorScheme
      .copyWith(primary: tbMatIndigo, secondary: _tbSecondaryColor),
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
  textTheme: tbTypography.black,
  primaryTextTheme: tbTypography.black,
  typography: tbTypography,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: _tbTextColor,
    iconTheme: IconThemeData(color: _tbTextColor),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: _tbPrimaryColor,
    unselectedItemColor: _tbPrimaryColor.withAlpha((255 * 0.38).ceil()),
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: FadeOpenPageTransitionsBuilder(),
      TargetPlatform.android: FadeOpenPageTransitionsBuilder(),
    },
  ),
);

final ThemeData darkTheme =
ThemeData(primarySwatch: tbDarkMatIndigo, brightness: Brightness.dark);

ThemeData tbDarkTheme = ThemeData(
  primarySwatch: tbDarkMatIndigo,
  colorScheme: darkTheme.colorScheme.copyWith(secondary: _tbSecondaryColor),
  brightness: Brightness.dark,
);