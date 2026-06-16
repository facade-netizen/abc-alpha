import 'package:flutter/material.dart';

import '../../../../reusable/colors.dart';
import '../betlistConstant/betlist_string_constants.dart';

class ResultSourceScreen extends StatefulWidget {
  const ResultSourceScreen({super.key});

  @override
  State<ResultSourceScreen> createState() => _ResultSourceScreenState();
}

class _ResultSourceScreenState extends State<ResultSourceScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Result Source Management", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Container(
            color: lightBlueShade,
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 8)]),
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
              columns: resultSourceManagement.map((header) => DataColumn(label: Text(header))).toList(),
              rows: [],
            ),
          ),
        ],
      ),
    );
  }
}
