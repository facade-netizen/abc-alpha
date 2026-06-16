import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/updateBlocs/reset_password_bloc.dart';
import '../../../../../constants/app_constant.dart';
import '../../../../../reusable/button.dart';
import '../../../../../reusable/colors.dart';
import '../../../../../reusable/custom_alert_dialog.dart';
import '../../../../../reusable/loader.dart';
import '../../../../../reusable/navigators.dart';
import '../../../../../reusable/sized_box_hw.dart';
import '../../../../../reusable/snack_bar.dart';
import '../../../../../reusable/style.dart';

Future showResetPasswordChangeDialog(BuildContext context,String userId) {
  return showDialog(
    context: context,
    builder: (context) => ChangeResetPasswordDialogBody(userId: userId),
  );
}

class ChangeResetPasswordDialogBody extends StatefulWidget {
  const ChangeResetPasswordDialogBody({super.key, required this.userId});
  final String userId;

  @override
  State<ChangeResetPasswordDialogBody> createState() => _ChangeResetPasswordDialogBodyState();
}

class _ChangeResetPasswordDialogBodyState extends State<ChangeResetPasswordDialogBody> {
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController cfmPasswordController = TextEditingController();
  final TextEditingController yourPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, cps) {
        if (cps is ResetPasswordSuccess) {
          showSnackBar(context, "Password updated successfully");
          removeScreen(context);
        }
        if (cps is ResetPasswordFailure) {
          showSnackBar(context, "Unable update your password. Please try again!", error: true);
          removeScreen(context);
        }
      },
      builder: (context, cps) {
        return CustomAlertDialog(
          title: 'Change Password',
          content: SizedBox(
            height: 130,
            width: 400,
            child: cps is ResetPasswordProgress
                ? LoaderContainerWithMessage()
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("New Password"),
                          Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 200,
                                child: TextFormField(
                                  controller: newPassController,
                                  obscureText: true,
                                  obscuringCharacter: "*",
                                  decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                                ),
                              ),
                              Text("*", style: TextStyle(color: red)),
                            ],
                          ),
                        ],
                      ),
                      hb12,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("New Password Confirm"),
                          Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 200,
                                child: TextFormField(
                                  controller: cfmPasswordController,
                                  obscureText: true,
                                  obscuringCharacter: "*",
                                  decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                                ),
                              ),
                              Text("*", style: TextStyle(color: red)),
                            ],
                          ),
                        ],
                      ),
                      hb12,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Your Password"),
                          Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 200,
                                child: TextFormField(
                                  controller: yourPasswordController,
                                  obscureText: true,
                                  obscuringCharacter: "*",
                                  decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                                ),
                              ),
                              Text("*", style: TextStyle(color: red)),
                            ],
                          ),
                        ],
                      ),
                      hb10,
                    ],
                  ),
          ),
          actions: cps is ResetPasswordProgress
              ? []
              : [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Divider()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ColoredTextButton(
                      width: 100,
                      name: 'Change',
                      onTap: () {
                        if (yourPasswordController.text.isNotEmpty && newPassController.text.isNotEmpty) {
                          Map<String, dynamic> changePasswordMap = {
                            "userId": widget.userId,
                            "userPassword": newPassController.text.trim(),
                            "updatorPassword": yourPasswordController.text.trim(),
                            "ip": ip.value,
                            "isp": isp.value,
                          };
                          context.read<ResetPasswordBloc>().add(ResetPassword(resetPassword: changePasswordMap));
                        } else {
                          showSnackBar(context, "Please fill in all the fields.");
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
