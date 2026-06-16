import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_wl_full_reports_bloc.dart';
import '../../../../model/wl_full_report_model.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/formatters.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../reusable/style.dart';
import '../../../../services/get_excel_file_from_passed_data_service.dart';
import 'wl_account_and_constant.dart';

class WlAccountSummaryTable extends StatefulWidget {
  const WlAccountSummaryTable({super.key});

  @override
  State<WlAccountSummaryTable> createState() => _WlAccountSummaryTableState();
}

class _WlAccountSummaryTableState extends State<WlAccountSummaryTable> {
  final ScrollController tabHorizontalController = ScrollController();
  final ScrollController filterHorizontalController = ScrollController();
  List<WlFullReportsData> wlFullReports = [];
  @override
  void initState() {
    context.read<FetchWLFullReportsBloc>().add(FetchWLFullReports());
    super.initState();
  }

  @override
  void dispose() {
    tabHorizontalController.dispose();
    filterHorizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<FetchWLFullReportsBloc, FetchWLFullReportsState>(
      builder: (context, wfr) {
        double totalPointValue = 0.0;
        double totalNetPoint = 0.0;
        double totalNetValue = 0.0;
        double totalWL = 0.0;
        double totalpnl = 0.0;
        double totalLivePoint = 0.0;
        double totalLiveValue = 0.0;
        double totalCompanyValue = 0.0;
        if (wfr is FetchWLFullReportsSuccess) {
          wlFullReports = wfr.wlFullReports;
          totalPointValue = wfr.wlFullReportsResponse.totalPointValue;
          totalNetPoint = wfr.wlFullReportsResponse.totalNetPoint;
          totalNetValue = wfr.wlFullReportsResponse.totalNetValue;
          totalWL = wfr.wlFullReportsResponse.totalWL;
          totalpnl = wfr.wlFullReportsResponse.totalPnl;
          totalLivePoint = wfr.wlFullReportsResponse.totalLivePoint;
          totalLiveValue = wfr.wlFullReportsResponse.totalLiveValue;
          totalCompanyValue = wfr.wlFullReportsResponse.totalCompanyValue;
        }
        return wfr is FetchWLFullReportsProgress
            ? LoaderContainerWithMessage()
            : wfr is FetchWLFullReportsSuccess
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text("Accounts", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Scrollbar(
                    thickness: 4,
                    controller: filterHorizontalController,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: filterHorizontalController,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: size.width - 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomOutlineTextButton(
                                title: "Download",
                                width: 100,
                                fontSize: 13,
                                height: 30,
                                onPressed: () {
                                  if (wlFullReports.isNotEmpty) {
                                    generateAndDownloadReportInExcel(accountColumnNames, generateWLaccountRows(wlFullReports: wlFullReports), "Accounts Report");
                                  } else {
                                    showSnackBar(context, "Please wait");
                                  }
                                },
                                boxColor: white,
                                textColor: black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: size.height - (300),
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
                              columns: List.generate(accountColumnNames.length, (index) => DataColumn(label: Text(accountColumnNames[index]))),
                              rows: [
                                ...wfr.wlFullReports.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  var wfr = entry.value;
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${index + 1}', style: defaultCellStyle)),
                                      DataCell(Text(wfr.wlName, style: defaultCellStyle)),
                                      DataCell(Text(formattedAmounts(wfr.pointValue), style: defaultCellStyle)),
                                      DataCell(Text(formattedAmounts(wfr.netPoint), style: defaultCellStyle)),
                                      DataCell(Text(formattedAmounts(wfr.netValue), style: defaultCellStyle)),
                                      DataCell(Text(formattedAmounts(wfr.totalWL), style: defaultCellStyle)),
                                      DataCell(
                                        Text(
                                          formattedAmounts(wfr.pnl),
                                          style: TextStyle(
                                            color: wfr.pnl > 0
                                                ? green
                                                : wfr.pnl < 0
                                                ? red
                                                : black,
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(formattedAmounts(wfr.livePoint), style: defaultCellStyle)),
                                      DataCell(Text(formattedAmounts(wfr.liveValue), style: defaultCellStyle)),
                                      DataCell(Text(formattedAmounts(wfr.companyValue), style: defaultCellStyle)),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: DataTable(
                              showCheckboxColumn: false,
                              headingTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: black),
                              dataRowMinHeight: 35,
                              dataRowMaxHeight: 35,
                              headingRowHeight: 35,
                              border: TableBorder(
                                top: BorderSide(color: black, width: 0.5),
                                bottom: BorderSide(color: black, width: 0.5),
                              ),
                              columns: [
                                DataColumn(
                                  label: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(formattedAmounts(totalPointValue), style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(formattedAmounts(totalNetPoint), style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(formattedAmounts(totalNetValue), style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(formattedAmounts(totalWL), style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(
                                    formattedAmounts(totalpnl),
                                    style: TextStyle(
                                      color: totalpnl > 0
                                          ? green
                                          : totalpnl < 0
                                          ? red
                                          : black,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(formattedAmounts(totalLivePoint), style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(formattedAmounts(totalLiveValue), style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(formattedAmounts(totalCompanyValue), style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                              rows: [],
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
                  ),
                ],
              )
            : NoData();
      },
    );
  }
}
