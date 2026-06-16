import 'package:flutter/material.dart';

import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/custom_alert_dialog.dart';
import '../../../../../../reusable/sized_box_hw.dart';
import '../../../../../../reusable/style.dart';

Future showFancyRemarkDialog(BuildContext context) {
  return showDialog(context: context, builder: (context) => const FancyRemarkDailogBody());
}

class FancyRemarkDailogBody extends StatefulWidget {
  const FancyRemarkDailogBody({super.key});

  @override
  State<FancyRemarkDailogBody> createState() => _FancyRemarkDailogBodyState();
}

class _FancyRemarkDailogBodyState extends State<FancyRemarkDailogBody> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Remark',
      content: SizedBox(
        width: 500,
        height: 150,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Remark First Row:"),
                SizedBox(
                  height: 30,
                  width: 200,
                  child: TextFormField(
                    readOnly: true,
                    controller: controller,
                    decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                  ),
                ),
              ],
            ),
            hb10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Remark Second Row:"),
                SizedBox(
                  height: 30,
                  width: 200,
                  child: TextFormField(
                    readOnly: true,
                    controller: controller,
                    decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: CustomHoverButton(width: 80, height: 30, onPressed: () {}, title: 'Save', textColor: white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: CustomHoverButton(width: 80, height: 30, onPressed: () {}, title: 'Cancel', textColor: white),
            ),
          ],
        ),
      ],
    );
  }
}
