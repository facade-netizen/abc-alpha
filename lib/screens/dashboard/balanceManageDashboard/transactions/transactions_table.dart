import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_all_transactions_bloc.dart';
import '../../../../model/transactions_model.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/calender.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/date_time_formatter.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../reusable/style.dart';
import '../../../../services/get_excel_file_from_passed_data_service.dart';
import 'transactions_widgets_and_constant.dart';

class TransactionsTable extends StatefulWidget {
  const TransactionsTable({super.key});

  @override
  State<TransactionsTable> createState() => _TransactionsTableState();
}

class _TransactionsTableState extends State<TransactionsTable> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController fromDateController = TextEditingController(text: formatDateYYYYMMDD(DateTime.now().subtract(Duration(days: 90))));
  TextEditingController toDateController = TextEditingController(text: formatDateYYYYMMDD(DateTime.now()));
  final ScrollController tabHorizontalController = ScrollController();
  final ScrollController filterHorizontalController = ScrollController();
  List<Transactions> transactions = [];
  @override
  void initState() {
    context.read<FetchTransactionsBloc>().add(FetchTransactions());
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
    return BlocBuilder<FetchTransactionsBloc, FetchTransactionsState>(
      builder: (context, fts) {
        if (fts is FetchTransactionsSuccess) {
          transactions = fts.transactions;
        }
        return fts is FetchTransactionsProgress
            ? LoaderContainerWithMessage()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text("All Transactions", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  hb10,
                  Scrollbar(
                    thickness: 4,
                    controller: filterHorizontalController,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: filterHorizontalController,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: size.width - 100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 25,
                                    width: 200,
                                    child: TextFormField(
                                      controller: userIdController,
                                      decoration: tfInputDecoration.copyWith(hintText: "Enter UserId...", contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                                    ),
                                  ),
                                  wb20,
                                  Row(
                                    children: [
                                      const Text("From"),
                                      wb10,
                                      DateBox(
                                        controller: fromDateController,
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (_) => CustomDatePickerDialog(
                                              initialDate: DateTime.now(),
                                              onDateSelected: (date) {
                                                fromDateController.text = formatDateYYYYMMDD(date!);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      wb20,
                                      const Text(" to "),
                                      wb10,
                                      DateBox(
                                        controller: toDateController,
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (_) => CustomDatePickerDialog(
                                              initialDate: DateTime.now(),
                                              onDateSelected: (date) {
                                                toDateController.text = formatDateYYYYMMDD(date!);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  wb20,
                                  ColoredTextButton(name: "Submit", width: 100, fontSize: 13, height: 30, onTap: () {}),
                                  wb20,
                                  CustomOutlineTextButton(
                                    title: "Download",
                                    width: 100,
                                    fontSize: 13,
                                    height: 30,
                                    onPressed: () {
                                      if (transactions.isNotEmpty) {
                                        generateAndDownloadReportInExcel(transactionsColumnNames, generateTransactionsRows(transactions: transactions), "Transaction Report");
                                      } else {
                                        showSnackBar(context, "Please wait");
                                      }
                                    },
                                    boxColor: white,
                                    textColor: black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: fts is FetchTransactionsProgress
                              ? LoaderContainerWithMessage()
                              : fts is FetchTransactionsSuccess
                              ? DataTable(
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
                                  columns: List.generate(transactionsColumnNames.length, (index) => DataColumn(label: Text(transactionsColumnNames[index]))),
                                  rows: fts.transactions.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    var transactions = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text('${index + 1}', style: defaultCellStyle)),
                                        DataCell(Text(transactions.userName, style: defaultCellStyle)),
                                        DataCell(Text(transactions.wlName, style: defaultCellStyle)),
                                        DataCell(Text(transactions.type, style: defaultCellStyle)),
                                        DataCell(Text(transactions.amount.toStringAsFixed(2), style: defaultCellStyle)),
                                        DataCell(Text(transactions.status.toUpperCase(), style: TextStyle(color: transactions.status == "rejected" ? red : green))),
                                        DataCell(Text(transactions.requestAt, style: defaultCellStyle)),
                                        DataCell(Text(transactions.responseAt ?? "-", style: defaultCellStyle)),
                                        DataCell(Text(transactions.remark ?? "-", style: defaultCellStyle)),
                                        DataCell(Text(transactions.ip, style: defaultCellStyle)),
                                      ],
                                    );
                                  }).toList(),
                                )
                              : NoData(),
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
              );
      },
    );
  }
}
