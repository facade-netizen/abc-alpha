import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_all_users_bloc.dart';
import '../../../../model/all_users_model.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/formatters.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../services/get_excel_file_from_passed_data_service.dart';
import '../../alphaAdminDashBoard/adminManagement/adminManagement/update_and_view_admin_dialog.dart';

class WlAdminDetails extends StatefulWidget {
  const WlAdminDetails({super.key});

  @override
  State<WlAdminDetails> createState() => _WlAdminDetailsState();
}

class _WlAdminDetailsState extends State<WlAdminDetails> {
  @override
  void initState() {
    context.read<FetchAllUsersBloc>().add(FetchAllUsers(role: 'adminWL'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<AllUserData> userDetailsList = [];
    return BlocBuilder<FetchAllUsersBloc, FetchAllUsersState>(
      builder: (context, fms) {
        if (fms is FetchAllUsersSuccess) {
          userDetailsList = fms.users;
        }
        return fms is FetchAllUsersProgress
            ? LoaderContainerWithMessage()
            : fms is FetchAllUsersSuccess
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text("WL Admin", style: TextStyle(fontWeight: FontWeight.bold)),
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
                        if (userDetailsList.isNotEmpty) {
                          generateAndDownloadReportInExcel(wlAdminColumnNames, generateRBAdminData(userDetailsList: userDetailsList), "WL Admin Report");
                        } else {
                          showSnackBar(context, "Please wait");
                        }
                      },
                      boxColor: white,
                      textColor: black,
                    ),
                  ),
                  ManageAdminTable(mappedUsersData: fms.users.where((user) => user.role == "adminWL").toList()),
                ],
              )
            : NoData(msg: "Unable to fetch admin data");
      },
    );
  }
}

class ManageAdminTable extends StatefulWidget {
  const ManageAdminTable({super.key, required this.mappedUsersData});
  final List<AllUserData> mappedUsersData;
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
                columns: List.generate(wlAdminColumnNames.length, (index) => DataColumn(label: Text(wlAdminColumnNames[index]))),
                rows: widget.mappedUsersData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var userDetails = entry.value;
                  return DataRow(
                    onSelectChanged: (value) {
                      showResetPasswordChangeDialog(context, userDetails.userId);
                    },
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(userDetails.username)),
                      DataCell(Text(userDetails.wlName.toUpperCase())),
                      DataCell(Text(userDetails.active, style: TextStyle(color: userDetails.active == "Active" ? green : red))),
                      DataCell(Text(formattedAmounts(userDetails.balance))),
                      DataCell(Text(formattedAmounts(userDetails.exposure))),
                      DataCell(Text(formattedAmounts(userDetails.pnl))),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
