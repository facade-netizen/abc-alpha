import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../model/mapped_user_model.dart';
import '../../../../../reusable/button.dart';
import '../../../../../reusable/colors.dart';
import '../../../../../reusable/custom_alert_dialog.dart';
import '../../../../../reusable/custom_text_form_field.dart';
import '../../../../../reusable/snack_bar.dart';
import '../../../../../reusable/style.dart';

Future<dynamic> manageAdminFundsDialog(BuildContext context, {required MappedUserDetails userDetails}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext ctxt) {
      return ManageFundsDialogBody(userDetails: userDetails);
    },
  );
}

class ManageFundsDialogBody extends StatefulWidget {
  const ManageFundsDialogBody({super.key, required this.userDetails});
  final MappedUserDetails userDetails;
  @override
  State<ManageFundsDialogBody> createState() => _ManageFundsDialogBodyState();
}

class _ManageFundsDialogBodyState extends State<ManageFundsDialogBody> {
  final fundFormKey = GlobalKey<FormState>();
  TextEditingController amountCtlr = TextEditingController();
  TextEditingController commentCtlr = TextEditingController();

  String transactionType = 'Deposit';
  double fieldWidth = 300;
  double fieldSpacing = 10;
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Manage ${widget.userDetails.userName.toUpperCase()} Funds',
      content: SizedBox(
        height: 300,
        width: 350,
        child: Form(
          key: fundFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                spacing: fieldSpacing * 2,
                runSpacing: fieldSpacing,
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
                    title: 'Comment',
                    controller: commentCtlr,
                    validator: (value) => value!.isEmpty ? 'Comment is required' : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ColoredTextButton(
            name: "Update",
            width: 200,
            onTap: () {
              if (fundFormKey.currentState!.validate()) {
                fundFormKey.currentState!.save();
                setState(() {});
                List<Map<String, dynamic>> addUserDepositWithdrawalMap = [];
                final amount = double.parse(amountCtlr.text);
                addUserDepositWithdrawalMap.add({
                  'transType': transactionType == 'Deposit' ? 0 : 1,
                  'amount': amount,
                  'comment': commentCtlr.text,
                  'userId': widget.userDetails.id,
                });
              } else {
                showSnackBar(context, "Please fill all required fields", error: true);
              }
            },
          ),
        ),
      ],
    );
  }
}
