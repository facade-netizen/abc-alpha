import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_wl_net_reports_bloc.dart';
import '../../../../model/wl_report_model.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/formatters.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../reusable/style.dart';
import '../../../../services/get_excel_file_from_passed_data_service.dart';
import 'reports_widgets_and_contants.dart';

class WLAdminReportsScreen extends StatefulWidget {
  const WLAdminReportsScreen({super.key});
  @override
  State<WLAdminReportsScreen> createState() => _WLAdminReportsScreenState();
}

class _WLAdminReportsScreenState extends State<WLAdminReportsScreen> {
  List<WLNetReports> wlNetReports = [];

  @override
  void initState() {
    context.read<FetchWLNetReportsBloc>().add(FetchWLNetReports());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<FetchWLNetReportsBloc, FetchWLNetReportsState>(
      builder: (context, wns) {
        if (wns is FetchWLNetReportsSuccess) {
          wlNetReports = wns.wlNetReports;
        }
        return wns is FetchWLNetReportsProgress
            ? LoaderContainerWithMessage()
            : wns is FetchWLNetReportsSuccess
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text("WL Reports", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  hb10,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: CustomOutlineTextButton(
                      title: "Download",
                      width: 100,
                      fontSize: 13,
                      height: 30,
                      onPressed: () {
                        if (wlNetReports.isNotEmpty) {
                          generateAndDownloadReportInExcel(wlReportsColumnNames, generateWLReportsDataRows(wlNetReports: wlNetReports), "WL Report");
                        } else {
                          showSnackBar(context, "Please wait");
                        }
                      },
                      boxColor: white,
                      textColor: black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity,
                        height: size.height - 250,
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
                          columns: List.generate(wlReportsColumnNames.length, (index) => DataColumn(label: Text(wlReportsColumnNames[index]))),
                          rows: wns.wlNetReports.asMap().entries.map((entry) {
                            int index = entry.key;
                            var wlDetails = entry.value;
                            return DataRow(
                              cells: [
                                DataCell(Text('${index + 1}', style: defaultCellStyle)),
                                DataCell(Text(wlDetails.wlName.toUpperCase(), style: defaultCellStyle)),
                                DataCell(Text(wlDetails.adminName, style: defaultCellStyle)),
                                DataCell(Text(formattedAmounts(wlDetails.points), style: defaultCellStyle)),
                                DataCell(Text(formattedAmounts(wlDetails.pointValue), style: defaultCellStyle)),
                                DataCell(Text(formattedAmounts(wlDetails.value), style: defaultCellStyle)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : NoData();
      },
    );
  }
}
