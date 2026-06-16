import 'dart:async';

import 'web_utils.dart' as web_utils;

///To save the Excel file in the device
Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  web_utils.downloadBase64(bytes, fileName);
}
