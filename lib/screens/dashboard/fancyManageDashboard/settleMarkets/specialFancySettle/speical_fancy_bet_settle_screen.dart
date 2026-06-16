import 'package:flutter/material.dart';

import '../../../../../reusable/colors.dart';
import '../../betlistConstant/betlist_string_constants.dart';

class SpeicalFancyBetSettleScreen extends StatefulWidget {
  const SpeicalFancyBetSettleScreen({super.key});

  @override
  State<SpeicalFancyBetSettleScreen> createState() => _SpeicalFancyBetSettleScreenState();
}

class _SpeicalFancyBetSettleScreenState extends State<SpeicalFancyBetSettleScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Special Fancy Bet Settle Market", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Text("Result Source Reference WebSite Example : Sportsadda,Espncricinfo,Cricbuzz,Fancode,BullScore"),
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
              columns: specialSettleFancy.map((header) => DataColumn(label: Text(header))).toList(),
              rows: [],
            ),
          ),
        ],
      ),
    );
  }
}
