import 'package:flutter/material.dart';

import '../../../../../reusable/button.dart';
import '../../../../../reusable/calender.dart';
import '../../../../../reusable/colors.dart';
import '../../../../../reusable/date_time_formatter.dart';
import '../../../../../reusable/sized_box_hw.dart';
import '../../betlistConstant/betlist_string_constants.dart';

class KabaddiBookMakerSettleScreen extends StatefulWidget {
  const KabaddiBookMakerSettleScreen({super.key});

  @override
  State<KabaddiBookMakerSettleScreen> createState() => _KabaddiBookMakerSettleScreenState();
}

class _KabaddiBookMakerSettleScreenState extends State<KabaddiBookMakerSettleScreen> {
  TextEditingController fromDateController = TextEditingController(text: formatDateYYYYMMDD(DateTime.now()));
  TextEditingController toDateController = TextEditingController(text: formatDateYYYYMMDD(DateTime.now()));
  TextEditingController fromTimeController = TextEditingController(text: "00:00");
  TextEditingController toTimeController = TextEditingController(text: "23:59");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("KABADDI BookMaker Settle Market", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Container(
            color: lightBlueShade,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("From", style: TextStyle(fontWeight: FontWeight.w500)),
                    wb5,
                    DateBox(
                      height: 30,
                      fontSize: 14,
                      width: 150,
                      controller: fromDateController,
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => CustomDatePickerDialog(
                            initialDate: DateTime.now(),
                            allowFutureDates: true,
                            onDateSelected: (date) {
                              fromDateController.text = formatDateYYYYMMDD(date!);
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
                        controller: fromTimeController,
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
                    wb5,
                    const Text("To", style: TextStyle(fontWeight: FontWeight.w500)),
                    wb5,
                    DateBox(
                      height: 30,
                      fontSize: 14,
                      width: 150,
                      controller: toDateController,
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => CustomDatePickerDialog(
                            initialDate: DateTime.now(),
                            allowFutureDates: true,
                            onDateSelected: (date) {
                              toDateController.text = formatDateYYYYMMDD(date!);
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
                        controller: toTimeController,
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
                    wb5,
                    CustomHoverButton(width: 100, height: 30, title: 'Search', textColor: white, onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              showCheckboxColumn: false,
              headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
              headingTextStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
              dataRowMinHeight: 60,
              dataRowMaxHeight: 60,
              headingRowHeight: 30,
              border: TableBorder(
                top: BorderSide(color: grey, width: 0.5),
                bottom: BorderSide(color: grey, width: 0.5),
              ),
              columns: kabaddisettle.map((header) => DataColumn(label: Text(header))).toList(),
              rows: [],
            ),
          ),
        ],
      ),
    );
  }
}
