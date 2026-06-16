import 'package:flutter/material.dart';
import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/custom_alert_dialog.dart';
import '../../../../../../reusable/sized_box_hw.dart';

Future<Map<String, String>?> showFancyMarketTypeDailog(BuildContext context) {
  return showDialog<Map<String, String>>(context: context, barrierDismissible: false, builder: (context) => ShowFancyMarketTypeDailogBody());
}

class ShowFancyMarketTypeDailogBody extends StatefulWidget {
  const ShowFancyMarketTypeDailogBody({super.key});

  @override
  State<ShowFancyMarketTypeDailogBody> createState() => _ShowFancyMarketTypeDailogBodyState();
}

class _ShowFancyMarketTypeDailogBodyState extends State<ShowFancyMarketTypeDailogBody> {
  String? selectedMarketType;
  @override
  void initState() {
    super.initState();
  }

  final List<String> hardCodedTypes = ["THREE_SELECTIONS", "OVERS", "BATSMAN", "SINGLE_OVER", "BALL_BY_BALL_SESSION", "KHADDA", "LOTTERY", "ODD_EVEN"];
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Select a Market Type',
      content: SizedBox(
        width: 300,
        height: 400,
        child: RadioGroup<String>(
          groupValue: selectedMarketType,
          onChanged: (value) {
            setState(() {
              selectedMarketType = value;
            });
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Market Day: 1"),
                hb10,
                ...hardCodedTypes.map((entry) {
                  return RadioListTile<String>(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    dense: true,
                    title: Text(entry, style: const TextStyle(fontSize: 14)),
                    value: entry,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: CustomHoverButton(
              width: 80,
              height: 30,
              title: 'Edit',
              textColor: white,
              onPressed: () {
                if (selectedMarketType != null) {
                  Navigator.pop(context, <String, String>{'marketType': selectedMarketType!});
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
