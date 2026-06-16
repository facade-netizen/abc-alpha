import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import '../services/web_utils.dart' as web_utils;

Future<void> openUrl(String url) async {
  if (kIsWeb) {
    web_utils.openNewTab(url);
  } else {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
