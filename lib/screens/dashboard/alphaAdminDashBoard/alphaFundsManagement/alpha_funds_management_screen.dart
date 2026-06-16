import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_current_user_info_bloc.dart';
import '../../../../model/user_details_model.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/formatters.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../reusable/style.dart';
import '../../../../services/get_excel_file_from_passed_data_service.dart';
import 'alpha_funds_widgets_and_constants.dart';
import 'show_add_points_dialog.dart';

class AlphaFundsManagementScreen extends StatefulWidget {
  const AlphaFundsManagementScreen({super.key});

  @override
  State<AlphaFundsManagementScreen> createState() => _AlphaFundsManagementScreenState();
}

class _AlphaFundsManagementScreenState extends State<AlphaFundsManagementScreen> {
  List<History> history = [];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<FetchCurrentUserDetailsBloc, FetchCurrentUserDetailsState>(
      builder: (context, cus) {
        if (cus is FetchCurrentUserDetailsSuccess) {
          history = cus.userDetails.history;
        }
        return cus is FetchCurrentUserDetailsProgress
            ? LoaderContainerWithMessage()
            : cus is FetchCurrentUserDetailsSuccess
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text("Manage Fund", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 300,
                              decoration: BoxDecoration(border: Border.all()),
                              child: DataTable(
                                columnSpacing: 20,
                                headingRowHeight: 0,
                                dataRowMinHeight: 25,
                                dataRowMaxHeight: 25,
                                horizontalMargin: 5,
                                columns: const [
                                  DataColumn(label: Text('')),
                                  DataColumn(label: Text('')),
                                ],
                                rows: [
                                  DataRow(cells: [DataCell(Text('Total Point')), DataCell(Text(formattedAmounts(cus.userDetails.netPoint)))]),
                                  DataRow(cells: [DataCell(Text('Net Remaining Point')), DataCell(Text(formattedAmounts(cus.userDetails.balancePoint)))]),
                                  DataRow(cells: [DataCell(Text('Net Point Sold')), DataCell(Text(formattedAmounts(cus.userDetails.soldPoint)))]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: CustomOutlineTextButton(
                                title: "Download",
                                width: 100,
                                fontSize: 13,
                                height: 30,
                                onPressed: () {
                                  if (history.isNotEmpty) {
                                    generateAndDownloadReportInExcel(
                                      alphaFundsColumnNames,
                                      generateAlphaHistoryRows(history: history, userName: cus.userDetails.userName),
                                      "Alpha Balance Report",
                                    );
                                  } else {
                                    showSnackBar(context, "Please wait");
                                  }
                                },
                                boxColor: white,
                                textColor: black,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ColoredTextButton(
                            name: "Add Points",
                            width: 100,
                            fontSize: 13,
                            height: 30,
                            onTap: () {
                              showAddPointsDialog(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: size.height - 300,
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
                          columns: List.generate(alphaFundsColumnNames.length, (index) => DataColumn(label: Text(alphaFundsColumnNames[index]))),
                          rows: cus.userDetails.history.asMap().entries.map((entry) {
                            int index = entry.key;
                            var transHistory = entry.value;
                            return DataRow(
                              cells: [
                                DataCell(Text('${index + 1}', style: defaultCellStyle)),
                                DataCell(Text(cus.userDetails.userName, style: defaultCellStyle)),
                                DataCell(Text(formattedAmounts(transHistory.amount), style: defaultCellStyle)),
                                DataCell(Text(transHistory.transType.toUpperCase(), style: defaultCellStyle)),
                                DataCell(Text(transHistory.date, style: defaultCellStyle)),
                                DataCell(Text(transHistory.comment, style: defaultCellStyle)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomOutlineTextButton(height: 25, width: 50, onPressed: () {}, title: 'Prev'),
                      wb10,
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          border: Border.all(color: black, width: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: const Text('1', style: TextStyle(color: yellowTextColor)),
                        ),
                      ),
                      wb10,
                      CustomOutlineTextButton(height: 25, width: 50, onPressed: () {}, title: 'Next'),
                      wb10,
                      SizedBox(
                        width: 60,
                        height: 30,
                        child: TextField(
                          decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      wb10,
                      CustomOutlineTextButton(height: 25, width: 50, onPressed: () {}, title: 'Go', textColor: black),
                    ],
                  ),
                ],
              )
            : NoData();
      },
    );
  }
}
