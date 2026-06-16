import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_settlement_data_bloc.dart';
import '../../../../model/settlement_model.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/formatters.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../services/get_excel_file_from_passed_data_service.dart';

class SettlementDetails extends StatefulWidget {
  const SettlementDetails({super.key});

  @override
  State<SettlementDetails> createState() => _SettlementDetailsState();
}

class _SettlementDetailsState extends State<SettlementDetails> {
  List<SettlementData> settlementData = [];
  @override
  void initState() {
    context.read<FetchSettlementBloc>().add(FetchSettlement());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchSettlementBloc, FetchSettlementState>(
      builder: (context, sds) {
        if (sds is FetchSettlementSuccess) {
          settlementData = sds.settlement.data;
        }
        return sds is FetchSettlementProgress
            ? LoaderContainerWithMessage()
            : sds is FetchSettlementSuccess
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text("Settlement Details", style: TextStyle(fontWeight: FontWeight.bold)),
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
                        if (settlementData.isNotEmpty) {
                          generateAndDownloadReportInExcel(settlementHeader, generateSettlementData(userDetailsList: settlementData), "Settlement Report");
                        } else {
                          showSnackBar(context, "Please wait");
                        }
                      },
                      boxColor: white,
                      textColor: black,
                    ),
                  ),
                  ManageAdminTable(mappedUsersData: settlementData),
                ],
              )
            : NoData(msg: "Unable to fetch admin data");
      },
    );
  }
}

class ManageAdminTable extends StatefulWidget {
  const ManageAdminTable({super.key, required this.mappedUsersData});
  final List<SettlementData> mappedUsersData;
  @override
  State<ManageAdminTable> createState() => _ManageAdminTableState();
}

class _ManageAdminTableState extends State<ManageAdminTable> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: double.infinity,
      height: size.height - 250,
      child: widget.mappedUsersData.isEmpty
          ? NoData()
          : Padding(
              padding: const EdgeInsets.all(8.0),
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
                columns: List.generate(settlementHeader.length, (index) => DataColumn(label: Text(settlementHeader[index]))),
                rows: widget.mappedUsersData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var userDetails = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(userDetails.wlName.toUpperCase())),
                      DataCell(Text(userDetails.active.toUpperCase())),
                      DataCell(Text(formattedAmounts(userDetails.pointRate))),
                      DataCell(Text(formattedAmounts(userDetails.credit))),
                      DataCell(Text(formattedAmounts(userDetails.current))),
                      DataCell(Text(formattedAmounts(userDetails.netBalance))),
                      DataCell(Text(formattedAmounts(userDetails.amt))),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
