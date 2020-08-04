import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/*ThemeData myTheme() {
  return ThemeData(brightness: Brightness.dark, fontFamily: 'Sans');
}*/

const Color primaryColor = Color(0xFF028A84);
const Color secondaryColor = Color(0xFF03BBB3);
const Color primaryColorDark = Color(0xFF015753);

const Color primaryTextColor = Color(0xFFFFFFFF);
const Color secondaryTextColor = primaryColorDark;

const Color deActiveState = Color(0xFFCCD1D2);
const Color deActiveStateText = Color(0xFF8A8989);

final ThemeData kLightGalleryTheme = _buildLightTheme();
final ThemeData kDarkGalleryTheme = _buildDarkTheme();
final ThemeData customTheme = _buildCustomTheme();

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
      title: base.title.copyWith(fontFamily: 'Sans', color: primaryTextColor),
      subtitle: base.subtitle.copyWith());
}

ThemeData _buildCustomTheme() {
  const Color primaryColor = Color(0xFFFFC107);
  const Color secondaryColor = Color(0xFFFF5722);
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData(
      brightness: Brightness.light,
      accentColorBrightness: Brightness.light,
      primaryColor: primaryColor,
      primaryColorDark: const Color(0xFFffa000),
      primaryColorLight: secondaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      toggleableActiveColor: const Color(0xFFFF5722),
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      errorColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      fontFamily: 'Sans');
  return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme));
}

ThemeData _buildDarkTheme() {
  //const Color primaryColor = Color(0xFF0175c2);
  //const Color secondaryColor = Color(0xFF13B9FD);
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData(
      brightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      primaryColor: primaryColor,
      accentColor: secondaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: secondaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      toggleableActiveColor: secondaryColor,
      canvasColor: const Color(0xFF202124),
      scaffoldBackgroundColor: const Color(0xFF202124),
      backgroundColor: const Color(0xFF202124),
      errorColor: const Color(0xFFB00020),
      textTheme: TextTheme(
        caption: TextStyle(color: secondaryColor),
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      fontFamily: 'Sans');
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

ThemeData _buildLightTheme() {
  const Color primaryColor = Color(0xFF0175c2);
  const Color secondaryColor = Color(0xFF13B9FD);
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData(
      brightness: Brightness.light,
      accentColorBrightness: Brightness.dark,
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      toggleableActiveColor: const Color(0xFF1E88E5),
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      errorColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      fontFamily: 'Sans');
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}
