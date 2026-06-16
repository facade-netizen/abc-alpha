import 'package:flutter/material.dart';

/// get alert dialog box width
double getDialogBoxWidth(BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  double dbw = size.width < 800 ? size.width : size.width * (size.width > 1100 ? 0.39 : 0.10);
  return dbw;
}

/// get screen width
double getScreenWidth(BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  return size.width;
}

/// get text form field width
double getTextFormFieldWidth(BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  double tfw = size.width < 800 ? size.width : size.width * (size.width > 1100 ? 0.36 : 0.5) / 2 - 5;
  return tfw;
}

/// get screen height
double getScreenHeight(BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  return size.height;
}
