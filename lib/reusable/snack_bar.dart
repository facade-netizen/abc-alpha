import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String title, {bool error = false}) {
  AnimatedSnackBar.material(
    title,
    duration: Duration(seconds: error ? 5 : 3),
    type: error == true ? AnimatedSnackBarType.error : AnimatedSnackBarType.success,
    desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
  ).show(context);
}

void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

Future<void> closeAllDialogs(BuildContext context) async {
  Navigator.of(context, rootNavigator: true).popUntil((route) => route is! PopupRoute);
}
