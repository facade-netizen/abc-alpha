import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import '../services/web_utils.dart' as web_utils;

Future<Uint8List?> pickPngFile() async {
  if (kIsWeb) {
    final bytes = await web_utils.pickFileBytes(accept: '.png');
    return bytes != null ? Uint8List.fromList(bytes) : null;
  } else {
    final XTypeGroup typeGroup = XTypeGroup(label: 'images', extensions: ['png']);
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file != null) {
      return await file.readAsBytes();
    }
    return null;
  }
}
