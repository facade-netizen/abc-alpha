import 'package:flutter/material.dart';

import 'colors.dart';
import 'navigators.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({super.key, required this.title, this.content, this.actions});
  final String title;
  final Widget? content;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
                ),
                GestureDetector(
                  onTap: () => removeScreen(context),
                  child: Container(
                    color: black,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.close, size: 15, color: white),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
      content: Padding(padding: const EdgeInsets.all(8.0), child: content),
      actions: actions,
    );
  }
}
