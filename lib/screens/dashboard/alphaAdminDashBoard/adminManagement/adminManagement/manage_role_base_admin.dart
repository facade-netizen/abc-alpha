import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/fetchBlocs/fetch_mapped_users_bloc.dart';
import '../../../../../model/mapped_user_model.dart';
import '../../../../../reusable/button.dart';
import '../../../../../reusable/colors.dart';
import '../../../../../reusable/loader.dart';
import '../../../../../reusable/no_data.dart';
import '../../../../../reusable/sized_box_hw.dart';
import '../../../../../reusable/snack_bar.dart';
import '../../../../../services/get_excel_file_from_passed_data_service.dart';
import 'admin_widgets_and_constants.dart';
import 'update_and_view_admin_dialog.dart';

class ManageRoleBaseAdminScreen extends StatefulWidget {
  const ManageRoleBaseAdminScreen({super.key});

  @override
  State<ManageRoleBaseAdminScreen> createState() => _ManageRoleBaseAdminScreenState();
}

class _ManageRoleBaseAdminScreenState extends State<ManageRoleBaseAdminScreen> {
  @override
  void initState() {
    context.read<FetchMappedUsersBloc>().add(FetchMappedUsers(pageSize: 100, pageNumber: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<MappedUserDetails> userDetailsList = [];
    return BlocBuilder<FetchMappedUsersBloc, FetchMappedUsersState>(
      builder: (context, fms) {
        if (fms is FetchMappedUsersSuccess) {
          userDetailsList = fms.mappedUsersData;
        }
        return fms is FetchMappedUsersProgress
            ? LoaderContainerWithMessage()
            : fms is FetchMappedUsersSuccess
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
                          generateAndDownloadReportInExcel(rbAdminColumnNames, generateRBAdminDataRows(userDetailsList: userDetailsList), "RB Admin Report");
                        } else {
                          showSnackBar(context, "Please wait");
                        }
                      },
                      boxColor: white,
                      textColor: black,
                    ),
                  ),
                  ManageRBAdminTable(mappedUsersData: fms.mappedUsersData.where((user) => user.role != "adminWL").toList()),
                ],
              )
            : NoData(msg: "Unable to fetch admin data");
      },
    );
  }
}

class ManageRBAdminTable extends StatefulWidget {
  const ManageRBAdminTable({super.key, required this.mappedUsersData});
  final List<MappedUserDetails> mappedUsersData;
  @override
  State<ManageRBAdminTable> createState() => _ManageRBAdminTableState();
}

class _ManageRBAdminTableState extends State<ManageRBAdminTable> {
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
                dataRowMaxHeight: 35,
                dataRowMinHeight: 35,
                headingRowHeight: 35,
                border: TableBorder(
                  top: BorderSide(color: black, width: 0.5),
                  bottom: BorderSide(color: black, width: 0.5),
                  left: BorderSide(color: black, width: 0.5),
                  right: BorderSide(color: black, width: 0.5),
                ),
                columns: List.generate(rbAdminColumnNames.length, (index) => DataColumn(label: Text(rbAdminColumnNames[index]))),
                rows: widget.mappedUsersData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var userDetails = entry.value;
                  return DataRow(
                    onSelectChanged: (value) {
                      showResetPasswordChangeDialog(context, userDetails.id);
                    },
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(userDetails.userName)),
                      DataCell(Text(userDetails.firstName)),
                      DataCell(Text(userDetails.lastName)),
                      DataCell(Text(userDetails.enabled ? "Yes" : "No", style: TextStyle(color: userDetails.enabled ? green : red))),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
