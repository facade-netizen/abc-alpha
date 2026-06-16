import 'package:flutter/material.dart';

import '../../../../../reusable/colors.dart';
import '../../betlistConstant/betlist_string_constants.dart';

class SpeicalFancyBetListScreen extends StatefulWidget {
  const SpeicalFancyBetListScreen({super.key});

  @override
  State<SpeicalFancyBetListScreen> createState() => _SpeicalFancyBetListScreenState();
}

class _SpeicalFancyBetListScreenState extends State<SpeicalFancyBetListScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Special Fancy Bet List", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(
            width: size.width,
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
              columns: specialFancyBetlist.map((header) => DataColumn(label: Text(header))).toList(),
              rows: [],
            ),
          ),
        ],
      ),
    );
  }
}
