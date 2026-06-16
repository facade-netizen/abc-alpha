import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  primaryColorDark: secondaryColor,
  primaryColorLight: secondaryColor,
  iconTheme: const IconThemeData(color: lightGrey),
  dividerTheme: const DividerThemeData(color: divider, thickness: 1),
  tabBarTheme: const TabBarThemeData(indicatorColor: primaryColor, labelColor: primaryColor),
  dialogTheme: const DialogThemeData(actionsPadding: EdgeInsets.zero, shape: RoundedRectangleBorder()),
  scrollbarTheme: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(grey), mainAxisMargin: 10),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: black),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: black),
    displayMedium: TextStyle(color: black),
    displaySmall: TextStyle(color: black),
    headlineLarge: TextStyle(color: black),
    headlineMedium: TextStyle(color: black),
    headlineSmall: TextStyle(color: black),
    titleLarge: TextStyle(color: black),
    titleMedium: TextStyle(color: black),
    titleSmall: TextStyle(color: black),
    bodyLarge: TextStyle(color: black),
    bodyMedium: TextStyle(color: black),
    bodySmall: TextStyle(color: black),
    labelLarge: TextStyle(color: black),
    labelMedium: TextStyle(color: black),
    labelSmall: TextStyle(color: black),
  ),
);

final ThemeData rangeSelectorTheme = ThemeData(
  datePickerTheme: const DatePickerThemeData(
    headerForegroundColor: littleLightGrey,
    headerBackgroundColor: littleLightGrey,
    rangePickerHeaderForegroundColor: littleLightGrey,
    rangePickerHeaderBackgroundColor: littleLightGrey,
  ),
  iconTheme: const IconThemeData(color: white),
);
