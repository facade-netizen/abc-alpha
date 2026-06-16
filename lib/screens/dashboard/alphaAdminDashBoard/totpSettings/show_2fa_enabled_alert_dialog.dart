import 'package:flutter/material.dart';

import '../../../../reusable/custom_alert_dialog.dart';

Future showEnabledAlertDialog(BuildContext context) {
  return showDialog(context: context, builder: (context) => Show2faEnabledAlertDialogBody());
}

class Show2faEnabledAlertDialogBody extends StatelessWidget {
  const Show2faEnabledAlertDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: "Alert 2FA Enabled",
      content: SizedBox(
        height: 100,
        width: 100,
        child: Center(child: Text("Your account already has Two-Factor Authentication (2FA) / TOTP enabled.", textAlign: TextAlign.center)),
      ),
    );
  }
}
