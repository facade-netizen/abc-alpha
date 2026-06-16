import 'package:flutter/material.dart';

import '../../../../../../model/fancy_events_model.dart';
import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/calender.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/custom_alert_dialog.dart';
import '../../../../../../reusable/date_time_formatter.dart';
import '../../../../../../reusable/navigators.dart';
import '../../../../../../reusable/sized_box_hw.dart';

Future showUpdateMarketTimeDialog(BuildContext context, FancyEventData? fancyBetEventData) {
  return showDialog(
    context: context,
    builder: (context) => UpdateMarketTimeDialogBody(fancyBetEventData: fancyBetEventData),
  );
}

class UpdateMarketTimeDialogBody extends StatefulWidget {
  const UpdateMarketTimeDialogBody({super.key, this.fancyBetEventData});
  final FancyEventData? fancyBetEventData;

  @override
  State<UpdateMarketTimeDialogBody> createState() => _UpdateMarketTimeDialogBodyState();
}

class _UpdateMarketTimeDialogBodyState extends State<UpdateMarketTimeDialogBody> {
  TextEditingController dateCtrl = TextEditingController(text: formatDateYYYYMMDD(DateTime.now()));
  TextEditingController timeCtrl = TextEditingController(text: "00:00");
  @override
  void initState() {
    final openDate = widget.fancyBetEventData?.openDate;
    dateCtrl = TextEditingController(text: openDate != null ? formatOnlyDateString(openDate) : formatDateYYYYMMDD(DateTime.now()));
    timeCtrl = TextEditingController(text: openDate != null ? formatOnlyTimeString(openDate) : "00:00");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: "Update Market Odds Time",
      content: SizedBox(
        height: 80,
        width: 400,
        child: Row(
          children: [
            const Text("Market Odds Time", style: TextStyle(fontWeight: FontWeight.w500)),
            wb5,
            DateBox(
              height: 30,
              fontSize: 14,
              width: 150,
              controller: dateCtrl,
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (_) => CustomDatePickerDialog(
                    initialDate: DateTime.now(),
                    allowFutureDates: true,
                    onDateSelected: (date) {
                      dateCtrl.text = formatDateYYYYMMDD(date!);
                    },
                  ),
                );
              },
            ),
            wb5,
            SizedBox(
              height: 30,
              width: 60,
              child: TextFormField(
                controller: timeCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  labelStyle: const TextStyle(fontSize: 14),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: black, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: grey, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
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
              child: CustomHoverButton(
                width: 80,
                height: 30,
                onPressed: () {
                  removeScreen(context);
                },
                title: 'Cancel',
                textColor: white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
