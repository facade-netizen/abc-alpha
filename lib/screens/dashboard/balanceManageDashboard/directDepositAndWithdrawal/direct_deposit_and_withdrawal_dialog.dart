import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/addBlocs/add_direct_funds_bloc.dart';
import '../../../../bloc/fetchBlocs/fetch_all_users_bloc.dart';
import '../../../../bloc/fetchBlocs/fetch_current_user_info_bloc.dart';
import '../../../../bloc/fetchBlocs/fetch_mapped_users_bloc.dart';
import '../../../../bloc/fetchBlocs/fetch_wl_full_reports_bloc.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/custom_alert_dialog.dart';
import '../../../../reusable/custom_text_form_field.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/navigators.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../reusable/style.dart';

Future showDirectDepositAndWithdrawalDialog(BuildContext context) {
  context.read<FetchMappedUsersBloc>().add(FetchMappedUsers());
  return showDialog(context: context, builder: (context) => DirectDepositAndWithdrawalDialogBody());
}

class DirectDepositAndWithdrawalDialogBody extends StatefulWidget {
  const DirectDepositAndWithdrawalDialogBody({super.key});

  @override
  State<DirectDepositAndWithdrawalDialogBody> createState() => _DirectDepositAndWithdrawalDialogBodyState();
}

class _DirectDepositAndWithdrawalDialogBodyState extends State<DirectDepositAndWithdrawalDialogBody> {
  final GlobalKey<FormState> directDepositWithdrawalFormKey = GlobalKey<FormState>();
  TextEditingController amountCtlr = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  String transactionType = 'Deposit';
  String? selectedUserId;
  double fieldWidth = 300;
  double fieldSpacing = 10;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocConsumer<AddDirectFundsBloc, AddDirectFundsState>(
      listener: (context, ads) {
        if (ads is AddDirectFundsSuccess) {
          showSnackBar(context, "$transactionType successfully");
          context.read<FetchCurrentUserDetailsBloc>().add(FetchCurrentUserDetails());
          context.read<FetchWLFullReportsBloc>().add(FetchWLFullReports());
          removeScreen(context);
        }
        if (ads is AddDirectFundsFailure) {
          context.read<FetchCurrentUserDetailsBloc>().add(FetchCurrentUserDetails());
          showSnackBar(context, "Unable to $transactionType Please try again", error: true);
          removeScreen(context);
        }
      },
      builder: (context, ads) {
        return CustomAlertDialog(
          title: 'Funds',
          content: SizedBox(
            height: 400,
            width: size.width * 0.30,
            child: ads is AddDirectFundsProgress
                ? LoaderContainerWithMessage()
                : Form(
                    key: directDepositWithdrawalFormKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelForTF(title: "Fund Type", topPadding: 0),
                            SizedBox(
                              width: fieldWidth,
                              child: DropdownButtonFormField<String>(
                                initialValue : transactionType,
                                decoration: tfInputDecoration.copyWith(),
                                dropdownColor: white,
                                items: ["Deposit", "Withdrawal"].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    transactionType = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<FetchAllUsersBloc, FetchAllUsersState>(
                          builder: (context, fms) {
                            if (fms is FetchAllUsersSuccess) {
                              final users = fms.users;
                              if (selectedUserId == null && users.isNotEmpty) {
                                selectedUserId = users.first.userId;
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelForTF(title: "User", topPadding: 0),
                                  SizedBox(
                                    width: fieldWidth,
                                    child: DropdownButtonFormField<String>(
                                      initialValue : selectedUserId,
                                      decoration: tfInputDecoration.copyWith(),
                                      dropdownColor: white,
                                      hint: const Text("Select User"),
                                      items: users.map((u) => DropdownMenuItem<String>(value: u.userId, child: Text(u.username))).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedUserId = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }

                            return const Text("No Users Found");
                          },
                        ),
                        CustomTextFormField(
                          width: fieldWidth,
                          lTFPadding: 0,
                          title: 'Amount',
                          controller: amountCtlr,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) => value!.isEmpty ? 'Amount is required' : null,
                        ),
                        CustomTextFormField(
                          width: fieldWidth,
                          lTFPadding: 0,
                          title: 'Remarks',
                          controller: remarksController,
                          validator: (value) => value!.isEmpty ? 'Comment is required' : null,
                        ),
                      ],
                    ),
                  ),
          ),
          actions: ads is AddDirectFundsProgress
              ? []
              : [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: ColoredTextButton(
                      width: 70,
                      height: 30,
                      name: 'Submit',
                      onTap: () {
                        // Validate form
                        if (directDepositWithdrawalFormKey.currentState!.validate()) {
                          // Optional: validate dropdown selection
                          if (selectedUserId == null || selectedUserId!.isEmpty) {
                            showSnackBar(context, "Please select a user", error: true);
                            return;
                          }

                          // Form is valid → prepare payload
                          final Map<String, dynamic> addDirectFundsMap = {
                            "amount": double.tryParse(amountCtlr.text),
                            "remarks": remarksController.text,
                            "action": transactionType == "Deposit" ? 0 : 1,
                            "userId": selectedUserId,
                          };
                          debugPrint("addDirectFundsMap $addDirectFundsMap");
                          context.read<AddDirectFundsBloc>().add(AddDirectFunds(addDirectFundsMap: addDirectFundsMap));
                        } else {
                          showSnackBar(context, "Please fill all required fields", error: true);
                        }
                      },
                    ),
                  ),
                ],
        );
      },
    );
  }
}
