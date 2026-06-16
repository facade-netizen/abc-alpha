import 'package:flutter/material.dart';

import '../../../../../reusable/button.dart';
import '../../../../../reusable/calender.dart';
import '../../../../../reusable/colors.dart';
import '../../../../../reusable/date_time_formatter.dart';
import '../../../../../reusable/sized_box_hw.dart';
import '../../../../../reusable/snack_bar.dart';
import '../../betlistConstant/betlist_string_constants.dart';

class KabaddiBetListScreen extends StatefulWidget {
  const KabaddiBetListScreen({super.key});

  @override
  State<KabaddiBetListScreen> createState() => _KabaddiBetListScreenState();
}

class _KabaddiBetListScreenState extends State<KabaddiBetListScreen> {
  TextEditingController fromDateController = TextEditingController(text: formatDateYYYYMMDD(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("KABADDI Book Maker List", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Container(
            color: lightBlueShade,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("Date", style: TextStyle(fontWeight: FontWeight.w500)),
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
                    Text("00:00~23.59", style: TextStyle(fontWeight: FontWeight.w500)),
                    wb5,
                    CustomHoverButton(
                      width: 100,
                      height: 30,
                      onPressed: () {
                        if (fromDateController.text.isEmpty) {
                          return showSnackBar(context, "Please select the date", error: true);
                        }
                      },
                      title: 'Search',
                      textColor: white,
                    ),
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
              columns: kabaddiBetlist.map((header) => DataColumn(label: Text(header))).toList(),
              rows: [],
            ),
          ),
        ],
      ),
    );
  }
}
