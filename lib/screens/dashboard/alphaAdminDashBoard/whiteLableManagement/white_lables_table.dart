import 'package:flutter/material.dart';

import '../../../../../reusable/colors.dart';
import '../../../../model/white_lable_model.dart';
import '../../../../reusable/no_data.dart' show NoData;
import '../../../../reusable/style.dart';
import 'update_white_lable_dialog.dart';

class WhiteLablesTable extends StatelessWidget {
  const WhiteLablesTable({super.key, required this.whiteLables});
  final List<WhiteLableAppData> whiteLables;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: whiteLables.isEmpty
          ? NoData()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: double.infinity,
                height: size.height,
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                  headingTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: black),
                  dataRowMinHeight: 35,
                  dataRowMaxHeight: 35,
                  headingRowHeight: 35,
                  border: TableBorder(
                    top: BorderSide(color: black, width: 0.5),
                    bottom: BorderSide(color: black, width: 0.5),
                    left: BorderSide(color: black, width: 0.5),
                    right: BorderSide(color: black, width: 0.5),
                  ),
                  columns: [
                    DataColumn(label: Text('S.No')),
                    DataColumn(label: Text('App Logo')),
                    DataColumn(label: Text('App Name')),
                    DataColumn(label: Text('App Id')),
                    DataColumn(label: Text('Platform')),
                    DataColumn(label: Text('App Version')),
                    DataColumn(label: Text('App Track')),
                    DataColumn(label: Text('Active')),
                    DataColumn(label: Text('Maintenance')),
                    DataColumn(label: Text('Remarks')),
                    DataColumn(label: Text('Released On')),
                  ],
                  rows: whiteLables.asMap().entries.map((entry) {
                    int index = entry.key;
                    var wlDetails = entry.value;
                    return DataRow(
                      onSelectChanged: (value) async {
                        await updateAndViewWL(context, whiteLableAppData: wlDetails);
                      },
                      cells: [
                        DataCell(Text('${index + 1}', style: defaultCellStyle)),
                        DataCell(CircleAvatar(backgroundColor: wlDetails.isEnabled ? green : red, child: Image.network(wlDetails.logo))),
                        DataCell(Text(wlDetails.appName.toUpperCase(), style: defaultCellStyle)),
                        DataCell(Text(wlDetails.appId, style: defaultCellStyle)),
                        DataCell(Text(wlDetails.platform, style: defaultCellStyle)),
                        DataCell(Text(wlDetails.appVersion, style: defaultCellStyle)),
                        DataCell(Text(wlDetails.appTrack, style: defaultCellStyle)),
                        DataCell(Text(wlDetails.isEnabled ? "Yes" : "No", style: defaultCellStyle)),
                        DataCell(Text(wlDetails.inMaintenance ? "Yes" : "Ongoing", style: defaultCellStyle)),
                        DataCell(Text(wlDetails.remarks, style: defaultCellStyle)),
                        DataCell(Text(wlDetails.releasedOn, style: defaultCellStyle)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
