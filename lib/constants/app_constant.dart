import 'package:flutter/material.dart';

class AppConstants {
  static const String appTitle = 'Alpha Admin Panel';
  static const String ipEndPoint = "https://api.ipify.org?format=json";
  static const String appVersion = "0.0.1";
  static const String build = "18";
}


ValueNotifier<String> ip = ValueNotifier("");
ValueNotifier<String> isp = ValueNotifier("");
ValueNotifier<String> agent = ValueNotifier("");
ValueNotifier<String> address = ValueNotifier("");